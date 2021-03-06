module Leelo


# TODO: neccessairy import statements
import JuMP
import CPLEX

# TODO: change using statements to import statements and use dot notation to keep namespace clean
using CSV # used by DataInput.jl
using DataFrames # used by DataInput.jl


# TODO: include codefiles containing other functionality
# DATA STRUCTURE
include("ModelData.jl")
# DATA IMPORTS
include("DataInput.jl")
# MODEL VARIABLES
include("ModelVariables.jl")
# MODEL CONSTRAINTS
include("ModelConstraints.jl")


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
export add_model_objective

export write_results
export plot_data
export plot_results
export create_plots

greet() = print("Hello World!")

function function_to_test()::String
    return "Result-String"
end


"Runs the entire simulation and plotting procedure depending on given arguments"
function run_sim(args::Vector{String})
    @info "run_sim() called"

    # TODO: identify the correct configuration from the arguments:
    config = SingleObjectiveBasicConfig()

    # TODO: identify where to load the data from and load it:
    data = read_model_data()

    # Build model depending on config and data
    model = build_base_model(config, data)

    # add model variables
    add_model_variables(model, config, data)
    # add model constraints
    add_model_constraints(model, config, data)
    # add model objective function
    add_model_objective(model, config, data)

    # solve the model
    JuMP.optimize!(model)

    # write output to file
    write_results(model, config, data, "ThisFileName")
    create_plots(model, config, data)


    @info "end of run_sim()"
    return nothing
end


# Configuration
abstract type AbstrConfiguration end
struct SingleObjectiveBasicConfig <: AbstrConfiguration end
struct SingleObjectiveMultiServiceConfig <: AbstrConfiguration end
struct MultiObjectiveBasicConfig <: AbstrConfiguration end
struct MultiObjectiveMultiServiceConfig <: AbstrConfiguration end


# MODEL BUILDING
function build_base_model(config::AbstrConfiguration, data::ModelData)::JuMP.Model
    model = JuMP.direct_model(CPLEX.Optimizer())
    @info "Created model with CPLEX:" model
    return model
end


# Objective creation
function add_model_objective(model::JuMP.Model, config::AbstrConfiguration, data::ModelData)
    # TODO
    #= from the knapsack example:
    x = model[:x]
    @objective(model, Max, sum(v.profit * x[k] for (k, v) in data.objects))
    return
    =#
    @info "add_model_objective() called"
    return
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
