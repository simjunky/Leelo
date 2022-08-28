module Leelo


# TODO: neccessairy import statements
using JuMP
import CPLEX

# TODO: change using statements to import statements and use dot notation to keep namespace clean
import XLSX # used by DataInput.jl
using DataFrames # used by DataInput.jl
using HDF5 # used for saving variable results by WriteVariables.jl and Visualization.jl
import Plots # for visualizing data, used by Visualization.jl
import StatsPlots # for visualizing data, used by Visualization.jl



# Configuration
abstract type AbstrConfiguration end
struct SingleObjectiveBasicConfig <: AbstrConfiguration end
struct SingleObjectiveMultiServiceConfig <: AbstrConfiguration end
struct MultiObjectiveBasicConfig <: AbstrConfiguration end
struct MultiObjectiveMultiServiceConfig <: AbstrConfiguration end




# DATA STRUCTURE
include("ModelData.jl")
# DATA IMPORTS
include("ReadParameters.jl")
# MODEL VARIABLES
include("ModelVariables.jl")
# MODEL CONSTRAINTS
include("ModelConstraints.jl")
# MODEL OBJECTIVE
include("ModelObjective.jl")
# WRITING MODEL VARIABLES TO FILE
include("WriteVariables.jl")
# MODEL TRANSITIONS
include("ModelTransition.jl")
# PLOTTING
include("Visualization.jl")
# WRITING MODEL PARAMETERS TO FILE
include("WriteParameters.jl")




# TODO: make all functions consistend by adding ! where arguments are mutated
# export statements
export greet
export function_to_test

export run_sim

export ModelData
export read_model_parameters

export AbstrConfiguration
export SingleObjectiveBasicConfig
export SingleObjectiveMultiServiceConfig
export MultiObjectiveBasicConfig
export MultiObjectiveMultiServiceConfig

export build_base_model
export add_model_variables
export add_model_constraints
export add_single_objective_constraints
export add_multi_service_constraints
export add_model_objective

export write_variables
export data_transition

export write_parameters
export create_plots




# TODO: remove these these two functions at some point...
"""
    greet()

Prints "Hello World!" to the console.
"""
greet() = print("Hello World!")

function function_to_test()::String
    return "Result-String"
end




"""
    run_sim(; config::AbstrConfiguration = SingleObjectiveBasicConfig(), scenario_dir::String = "data/TestScenario/input_data/")

This function runs the entire simulation and plotting procedure depending on a given configuration `config` and the scenario specified by `scenario_dir`.

# Short Procedure Description

Parameter data is read from the input files in the scenario `input_data` directory.
Then, for every benchmark year of the simulation, a new `JuMP` model is built (`build_base_model`), populated with variables (`add_model_variables`), constraints (`add_model_constraints`) and an objective (`add_model_objective`) and then run (`optimize!`). The result from the optimization is saved (`write_variables`) and lastly the parameters prepared for the next benchmark year (`data_transition`).
After the final year the final parameters are saved together with the yearly optimization results (`write_parameters`).
Lastly, plots are created from the saved data (`create_plots`).

# Arguments

**`config`** is the configuration specifying what the optimization objective is.

**`scenario_dir`** is the relative path to the chosen scenarios directory. This directory must contain the scenario's parameter files inside an `input_data` sub-directory.

"""
function run_sim(; config::AbstrConfiguration = SingleObjectiveBasicConfig(), scenario_dir::String = "data/TestScenario")

    #TODO: maybe use some args::Vector{String} and do config this way...?

    @info "run_sim() called"

    # TODO: identify the correct configuration from the arguments:
    #config = SingleObjectiveBasicConfig()

    # TODO: identify where to load the data from and load it:
    data = read_model_parameters(scenario_dir = scenario_dir)

    # TODO: remove unneeded output
    @info data

    # iterate through all years to be modeled
    # for each year a model will be created, solved and the results carried to the next year
    for y in 1:data.n_years

        # Build an empty model and set optimizer parameters
        model = build_base_model()

        # add model variables and trivial bounds
        add_model_variables(model, config, data, y)

        # add model constraints and equations
        add_model_constraints(model, config, data, y)

        # add model objective function
        add_model_objective(model, config)

        @info "Created model:" model

        # solve the model for current year
        optimize!(model)

        if termination_status(model) != OPTIMAL
            @error "The model could not be solved correctly"
            @info "Termination Status:" termination_status(model)
            return nothing
        end

        # save values of model variables in HDF5 file
        write_variables(model, data, y, scenario_dir = scenario_dir)

        # transition data to next year
        data_transition(model, data, y)
    end

    # after all simulations write existing capacities of each years to file
    write_parameters(data, scenario_dir = scenario_dir)

    # plot model results
    # TODO: to be extended to visualize more aspects
    create_plots(scenario_dir = scenario_dir)

    @info "end of run_sim()"
    return nothing
end




# MODEL BUILDING
"""
    build_base_model()::JuMP.Model

This function creates an empty `JuMP.Model` using the `CPLEX` optimizer. It also sets some optimizer parameters, e.g. convergence tolerance.

"""
function build_base_model()::JuMP.Model

    # the direct model is used to avoid automatic bridging between the JuMP model and the solver.
    model = JuMP.direct_model(CPLEX.Optimizer())


    # set the parameters of the CPLEX optimizer.
    # these are chosen to match the ones found in the older implementation to ensure comparability.
    # TODO: optimize these after comparisons have bee made and correctness has been established.
    # parameter names according to the old C API: https://www.ibm.com/docs/en/icos/12.10.0?topic=cplex-list-parameters

    # Controls which algorithm is used to solve continuous linear models or to solve the root relaxation of a MIP. 4 means Barrier algorithm.
    set_optimizer_attribute(model, "CPX_PARAM_LPMETHOD", 4)

    # Specifies type of optimality that CPLEX targets (optimal convex or first-order satisfaction) as it searches for a solution. 2 means it searches for a solution that satisfies first-order optimality conditions, but is not necessarily globally optimal.
    set_optimizer_attribute(model, "CPXPARAM_OptimalityTarget", 2)

    # Decides which crossover is performed at the end of a barrier optimization. 0 means CPLEX decides automatically.
    set_optimizer_attribute(model, "CPX_PARAM_BARCROSSALG", 0)

    # Specifies type of solution (basic or non basic) that CPLEX produces for a linear program (LP) or quadratic program (QP). 2 means CPLEX computes a primal-dual pair of solution-vectors.
    set_optimizer_attribute(model, "CPXPARAM_SolutionType", 2)

    # Decides how to scale the problem matrix. 1 means more aggressive scaling.
    set_optimizer_attribute(model, "CPX_PARAM_SCAIND", 1)

    # Emphasizes precision in numerically unstable or difficult problems. 1 means exercise extreme caution in computation.
    set_optimizer_attribute(model, "CPX_PARAM_NUMERICALEMPHASIS", 1)

    # Influences pivot selection during basis factoring. From 0.0001 to 0.99999, default would have been 0.01.
    set_optimizer_attribute(model, "CPX_PARAM_EPMRK", 0.9999)

    # Sets the tolerance on complementarity for convergence. The barrier algorithm terminates with an optimal solution if the relative complementarity is smaller than this value. Default would have been 1e-8.
    set_optimizer_attribute(model, "CPX_PARAM_BAREPCOMP", 0.0001)

    return model
end




end # module
