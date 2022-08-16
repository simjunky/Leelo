
# TODO: rewrite docstring
# Transitions data from one year to the next to prepare next simulation
"""
This is currently the function called to transition the data from one year to the next to prepare the next simulation
"""
function data_transition(model::JuMP.Model, config::AbstrConfiguration, data::ModelData, i_current_year::Int64)

    # TODO: remove unneeded outputs
    @info "transition() called"

    year = data
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

        data.pexistingG[:, :, y + i] = data.pexistingG[:, :, y + i] + pG .* (data.years[y + i] .<= data.years[y] .+ data.lifetimeG[g, y])
    end


    return nothing
end
