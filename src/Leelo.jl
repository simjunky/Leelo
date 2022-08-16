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
