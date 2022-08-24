module Leelo


# TODO: neccessairy import statements
using JuMP
import CPLEX

# TODO: change using statements to import statements and use dot notation to keep namespace clean
#using CSV #not used anymore
import XLSX # used by DataInput.jl
using DataFrames # used by DataInput.jl
using HDF5



# Configuration
abstract type AbstrConfiguration end
struct SingleObjectiveBasicConfig <: AbstrConfiguration end
struct SingleObjectiveMultiServiceConfig <: AbstrConfiguration end
struct MultiObjectiveBasicConfig <: AbstrConfiguration end
struct MultiObjectiveMultiServiceConfig <: AbstrConfiguration end



# TODO: include codefiles containing other functionality
# DATA STRUCTURE
include("ModelData.jl")
# DATA IMPORTS
include("DataInput.jl")
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



# export statements
export greet
export function_to_test

export run_sim

export ModelData
export read_model_data

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

export write_results
export plot_data
export plot_results
export create_plots



# TODO: remove these thest functions at some point...
"""
    greet()

Prints "Hello World!" to the console.
"""
greet() = print("Hello World!")

function function_to_test()::String
    return "Result-String"
end



"""
    run_sim(; config::AbstrConfiguration = SingleObjectiveBasicConfig())

Runs the entire simulation and plotting procedure depending on given configuration `config`.
"""
function run_sim(; config::AbstrConfiguration = SingleObjectiveBasicConfig())

    #TODO: maybe use some args::Vector{String} and do config this way...?

    @info "run_sim() called"

    # TODO: identify the correct configuration from the arguments:
    #config = SingleObjectiveBasicConfig()

    # TODO: identify where to load the data from and load it:
    data = read_model_data()

    # iterate through all years to be modeled
    # for each year a model will be created, solved and the results carried to the next year
    for y in 1:data.n_years

        # Build model depending on config and data
        model = build_base_model(config, data)

        # add model variables and trivial bounds
        add_model_variables(model, config, data, y)

        # add model constraints and equations
        add_model_constraints(model, config, data, y)

        # add model objective function
        add_model_objective(model, config)

        # solve the model for current year
        optimize!(model)

        # save values of model variables in HDF5 file
        write_variables(model, data.years[y])

        # transition data to next year
        #data_transition(model, config, data, y)

        #TODO: remove:
        break
    end

    # write all data to files
    # plot all data
    # plot some overarching figures

    # write output to file
    write_results(model, config, data, "ThisFileName")
    create_plots(model, config, data)

    @info "end of run_sim()"
    return nothing
end

# TODO: make all functions consistend by adding ! where arguments are mutated



# MODEL BUILDING
function build_base_model(config::AbstrConfiguration, data::ModelData)::JuMP.Model

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

    # TODO: remove unneeded output:
    @info "Created model with CPLEX:" model

    return model
end



# RESULTS WRITING
function write_results(model::JuMP.Model, config::AbstrConfiguration, data::ModelData, file_name::String)
    @info "write_results() called for file " * file_name
    return
end



# PLOTTING (DATA & RESULT)
function plot_data(data::ModelData)
    @info "plot_data() called"
    return
end



function plot_results(model::JuMP.Model, config::AbstrConfiguration, data::ModelData)
    @info "plot_results() called"
    return
end



function create_plots(model::JuMP.Model, config::AbstrConfiguration, data::ModelData)
    @info "create_plots() called"
    plot_data(data)
    plot_results(model, config, data)
    return
end



end # module
