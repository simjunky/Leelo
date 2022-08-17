
# TODO: rewrite docstring
# Transitions data from one year to the next to prepare next simulation
"""
    data_transition(model::JuMP.Model, config::AbstrConfiguration, data::ModelData, i_current_year::Int64)

This is currently the function called to transition the data from one year to the next to prepare the next simulation

# Keywords

**`model`** is the `JuMP` model containing all constraints and variables of the current year. For this function to be called, the `optimize!()` function has to already been called, such that the model variables have a value accessible by the `value()` function.

**`config`** is the configuration.

**`data`** is the datastructure containing all the parameters of the model and of the type `ModelData`.

**`i_current_year`** is the index of the current year in `data.years`.

"""
function data_transition(model::JuMP.Model, config::AbstrConfiguration, data::ModelData, i_current_year::Int64)

    # TODO: remove unneeded outputs
    @info "transition() called"

    #=
    i_current_year >= data.n_years ?
    if yes, then stop right here.
    else:
    i_next_year = i_current_year + 1
    =#
    #=
    TODO List:
    determine next year (if existent)
    determine indices of current and next year
    get all newly greated G, R, ST, CT, ROR, etc. and determine how long they live
    update the phaseout data
    update the existing capacities using the newly built & phased out data

    lastly: set next year to current year
    =#

    pG = model[:pG]
    i = 1
    while data.years[y + i] <= data.years[y] + data.lifetimeG[g, y]
        body
    end

    y_end = data.n_years

    for i in y:data.n_years
        data.pexistingG[:, :, y + i] = data.pexistingG[:, :, y + i] + pG .* (data.years[y + i] .<= data.years[y] .+ data.lifetimeG[:, y])
    end


    return nothing
end
