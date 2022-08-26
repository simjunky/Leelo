
"""
    data_transition(model::JuMP.Model, config::AbstrConfiguration, data::ModelData, i_current_year::Int64)

This is the function called to transition the data from one year to the next to prepare the next simulation. It updates existing capacities and phase outs.

# Keywords

**`model`** is the `JuMP` model containing all constraints and variables of the current year. For this function to be called, the `optimize!()` function has to already been called, such that the model variables have a value accessible by the `value()` function.

**`data`** is the datastructure containing all the parameters of the model and of the type `ModelData`.

**`i_current_year`** is the index of the current year in `data.years`.

"""
function data_transition(model::JuMP.Model, data::ModelData, i_current_year::Int64)

    # TODO: remove unneeded outputs
    @info "transition() called"


    # get needed variables from the model
    pG = model[:pG]
    pR = model[:pR]
    pCT = model[:pCT]
    eST = model[:eST]
    pH = model[:pH]
    pL = model[:pL]


    # for every year left to compute, we update the existing capacities according to the newly built ones.
    # Also the newly built capacities are added to the phase out capacities when their lifetime is over.
    # Note: there are no phase outs for hydropower and power lines
    for i in 1:(data.n_years - i_current_year)

        # update existing capacities for conventional generators (all years until the end of life)
        data.pexistingG[:, :, i_current_year + i] = data.pexistingG[:, :, i_current_year + i] + value.(pG) .* transpose(data.years[i_current_year + i] .<= data.years[i_current_year] .+ data.lifetimeG[:, i_current_year])

        # update the phased out capacities for conventional generators
        data.pGpho[:, :, i_current_year + i] .+= value.(pG) .* transpose(data.years[i_current_year + i - 1] .== data.years[i_current_year] .+ data.lifetimeG[:, i_current_year])


        # update capacities for renewable generators
        data.pexistingR[:, :, i_current_year + i] = data.pexistingR[:, :, i_current_year + i] + value.(pR) .* transpose(data.years[i_current_year + i] .<= data.years[i_current_year] .+ data.lifetimeR[:, i_current_year])

        # update the phased out capacities for renewable generators
        data.pRpho[:, :, i_current_year + i] .+= value.(pR) .* transpose(data.years[i_current_year + i - 1] .== data.years[i_current_year] .+ data.lifetimeR[:, i_current_year])


        # update capacities for conversion technologies
        data.pexistingCT[:, :, i_current_year + i] = data.pexistingCT[:, :, i_current_year + i] + value.(pCT) .* transpose(data.years[i_current_year + i] .<= data.years[i_current_year] .+ data.lifetimeCT[:, i_current_year])

        # update the phased out capacities for conversion technologies
        data.pCTpho[:, :, i_current_year + i] .+= value.(pCT) .* transpose(data.years[i_current_year + i - 1] .== data.years[i_current_year] .+ data.lifetimeCT[:, i_current_year])


        # update capacities for storage tehnologies
        data.vExistingST[:, :, i_current_year + i] = data.vExistingST[:, :, i_current_year + i] + value.(eST) .* transpose(data.years[i_current_year + i] .<= data.years[i_current_year] .+ data.lifetimeST[:, i_current_year])

        # update the phased out capacities for storage technologies
        data.eSTpho[:, :, i_current_year + i] .+= value.(eST) .* transpose(data.years[i_current_year + i - 1] .== data.years[i_current_year] .+ data.lifetimeST[:, i_current_year])


        # update capacities for hydro cascades
        # note that hydro generators do not have a lifetime built in, therefore no checking needed
        data.pexistingH[:, i_current_year + i] = data.pexistingH[:, i_current_year + i] + value.(pH)

        # update capacities for power lines
        # note that power lines do have a lifetime built in, but it is considered long enough to not be considered here, only for the anuities
        data.capLExisting[:, i_current_year + i] = data.capLExisting[:, i_current_year + i] + value.(pL)

    end

    return nothing
end
