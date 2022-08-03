
# TODO: rewrite docstring
# Objective creation
"""
TODO
"""
function add_model_objective(model::JuMP.Model, config::AbstrConfiguration)

    # TODO: remove unneeded outputs
    @info "adding objective function"

    # TODO: config not yet in use... only needed for Multiobjective optimization... when LCA is implemented...
    
    TotalCost = model[:TotalCost]
    @objective(model, Min, TotalCost)

    return nothing
end
