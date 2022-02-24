module Leelo

export greet
export function_to_test

greet() = print("Hello World!")

function function_to_test()::String
    return "Result-String"
end



# Variable creation
function add_model_variables(model::JuMP.Model, config::AbstrConfiguration, data::ModelData)
    # TODO something along the lines of return @variabl(model, blablabla)
    @info "add_model_variables() called"
    return
end


# Constraint creation
function add_model_constraints(model::JuMP.Model, config::AbstrConfiguration, data::ModelData)
    # TODO something along the lines of return @variabl(model, blablabla)
    @info "add_model_constraints() called"
    return
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
