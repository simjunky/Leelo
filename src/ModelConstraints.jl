
# TODO: rewrite docstring
# Constraint creation
"""
This is currently the function called to add constraints to the model
"""
function add_model_constraints(model::JuMP.Model, config::AbstrConfiguration, data::ModelData)

    # TODO: remove unneeded outputs
    @info "add_model_constraints() called"

    #@constraint(model, constraint_name, 6x + 8y >= 100)

    #TODO:
    i_current_year #index of current year

    #TODO: all other indices should be called using "data." e.g. data.n_buses



    # Constraints on the Objective function.

    # the yearly operational cost of renewable power generation
    # Calculated by multiplying the operational expenses of a renewable generator by its produced power within a timestep times the duration of the timestep.
    @constraint(model, eOperationCostR, OCr == sum((data.CostOperationVarR[r, i_current_year] * powerR[t, b, r] * data.dt) for t in 1:n_timesteps, b in 1:n_buses, r in 1:n_ren_generators))


    # the yearly operational cost of conventional power generators
    # Calculated by multiplying the operational expenses of a conventional generator by its produced power within a timestep times the duration of the timestep.
    @constraint(model, eOperationCostR, OCg == sum((data.CostOperationVarG[g, i_current_year] * powerG[t, b, g] * data.dt) for t in 1:n_timesteps, b in 1:n_buses, g in 1:n_conv_generators))


    # the yearly operational cost of energy storage
    # It is the sum of the operational cost of storage technologies and of conversion technologies.
    # The operational cost of conversion technologies is calculated by multiplying the operational expenses of a convention technology by its produced power within a timestep times the duration of the timestep.
    # The operational cost of storage technologies is calculated by multiplying the operational expenses of a storage technology by its stored and released power within a timestep times the duration of the timestep.
    @constraint(model, eOperationCostS, OCs == sum((data.CostOperationConvCT[ct, i_current_year] * powerCT[t, b, ct] * data.dt) for t in 1:n_timesteps, b in 1:n_buses, ct in 1:n_conversion_technologies) + sum((data.CostOperationVarST[st, i_current_year] * storedST[t, b, st] * data.dt) for t in 1:n_timesteps, b in 1:n_buses, st in 1:n_storage_technologies))


    # the yearly operational cost of power lines
    # Calculated by multiplying the operational expenses of a power line by its transported power in both directions within a timestep times the duration of the timestep.
    @constraint(model, eOperationCostL, OCl == sum((data.CostOperationVarL[l] * (powerLpos[t, l] + powerLneg[t, l]) * data.dt) for t in 1:n_timesteps, l in 1:n_lines))


    # other yearly operational costs
    # Calculated as the sum of different penalty costs. Those are the costs of unserved power and spilled power, as well as ficticious power flows. Additionally it contais the coal power ramping penalties.
    # TODO: why is qfictitious not multiplied by data.dt as the rest??
    @constraint(model, eOperationCostO, OCo == sum((data.costUnserved * powerunserved[t, b] * data.dt) for t in 1:n_timesteps, b in 1:n_buses) + sum((data.costSpilled * powerspilled[t, b] * data.dt) for t in 1:n_timesteps, b in 1:n_buses) + sum((data.costFictitiousFlows * qfictitious[t, h]) for t in 1:n_timesteps, h in 1:data.n_hydro_generators) )

    # TODO: add the coal ramping things to the constraint above!
    # OCo =e= sum((t,b),CostUnserved*powerunserved(t,b)*dt) +  sum((t,b),CostSpilled*powerspilled(t,b)*dt) + sum((t,h),CostFictitiousFlows*qfictitious(t,h)) + sum((t,b),CostRampsCoal_hourly*(rampsAuxCoal1(t,b)+rampsAuxCoal2(t,b))) +  sum((t,b),CostRampsCoal_daily*(rampsAuxCoal3(t,b)+rampsAuxCoal4(t,b))) +  sum((t,b),CostWTCoal*(rampsAuxCoal1(t,b)+rampsAuxCoal2(t,b)+ rampsAuxCoal3(t,b)+rampsAuxCoal4(t,b)))


    # yearly fixed operational costs of storage
    # in k€
    # TODO: probably in k$ and not €... ?
    # Calculated as the sum of the yearly fixed operating costs of storages and conversion technologies, which depend on the preexisting and newly installed capacities.
    @constraint(model, eOperationCostFixedS, OCfs == sum((data.costOperationFixST[st, i_current_year] * (1000 * eST[b, st] + data.vExistingST[b, st, i_current_year])) for b in 1:data.n_buses, st in 1:data.n_storage_technologies) + sum((data.costOperationFixCT[ct, i_current_year] * (1000 * pCT[b, ct] + data.pexistingCT[b, st, i_current_year])) for b in 1:data.n_buses, ct in 1:data.n_conversion_technologies) )


    # yearly fixed operational costs of conventional, renewable, hydro and run-of-river power generation and transmission lines
    # in k€
    # TODO: probably in k$ and not €... ?
    # Calculated as the sum of the yearly fixed operating costs of storages and conversion technologies, which depend on the preexisting and newly installed capacities.
    @constraint(model, eOperationCostFixedS, OCfs == sum((data.costOperationFixG[g, i_current_year] * (1000 * pG[b, g] + data.pexistingG[b, st, i_current_year])) for b in 1:data.n_buses, g in 1:data.n_conv_generators) + sum((data.costOperationFixR[r, i_current_year] * (1000 * pR[b, r] + data.pexistingR[b, r, i_current_year])) for b in 1:data.n_buses, r in 1:data.n_ren_generators) + sum((data.costOperationFixH[h] * (1000 * pH[h] + data.pexistingH[h, i_current_year])) for h in 1:data.n_hydro_generators) + sum((data.costOperationFixRoR[ror] * data.pMaxRoR[ror]) for ror in 1:data.n_ror_generators) + sum((data.costOperationFixL[l] * (1000 * pL[l] + data.capLExisting[l, i_current_year])) for l in 1:data.n_lines) )


    # yearly total operational costs
    # in Dollar
    # Calculated as the sum of all precalculated operational costs
    @constraint(model, eOperationCostT, OCfs == OCr + OCg + OCs + OCl + OCo + (1000 * OCfo) + (OCfs * 1000) )


    # yearly investment into renewable power generation
    # Calculated multiplying the interest dependent annuity factor with the capital cost of renewable generators times the newly built capacity (scaled to MW)
    @constraint(model, eInvestmentCostR, ICr == sum((data.annuityR[r] * costCapR[r, i_current_year] * 1000 * pR[b, r]) for b in 1:data.n_buses, r in 1:data.n_ren_generators) )





    eInvestmentCostG               .. ICg =e= sum((b,g),AnnuityG(g)*CostCapG(g)*1000*pG(b,g));
    eInvestmentCostS               .. ICs =e= sum((b,st),AnnuityST(st)*CostCapST(st)*1000*eST(b,st))+ sum((b,ct),AnnuityCT(ct)*CostCapCT(ct)*1000*pCT(b,ct));
    eInvestmentCostL               .. ICl =e= sum((l),AnnuityL(l)*CostCapL(l)*1000*pL(l));
    eInvestmentCostH               .. ICh =e= sum(h,CostCapUpgradeH(h)*1000*pH(h));
    eInvestmentCostO               .. ICo =e= 0;
    eInvestmentCostT               .. ICt =e= FractionOfYear*1000*(ICr+ICg+ICs+ICl+ICo+ICh);

#=


eInvestmentCostR               investment cost renewables
eInvestmentCostG               investment cost generators
eInvestmentCostS               investment cost storage
eInvestmentCostL               investment cost lines
eInvestmentCostH               investment cost hydropower
eInvestmentCostO               investment cost others
eInvestmentCostT               investment cost total


eGHGr                            GHG from renewables
eGHGct                           GHG from ct
eGHGst                           GHG from storage Tech
eGHGothers                       GHG from ror hydropower and generators
eGHGoperation                    Total taxable GHG (operation only)
eTotalGHG                      sum of emissions GHG
//eEpsilonHydropeaking           epsilon contrained objective function for hydropeaking
eCostGHG                       cost of GHG (tax incurred)
eTotalCost                     sum of all costs
//*MOO
//eTotalHydropeaking             sum of ramps of hydropower cascades as proxy to hydropeaking
//eTotalTransmission             sum of new installed transmission lines
//eTotalPMatter                  sum of emissions Particulate Matter
//eEpsilonTransmission           epsilon contrained objective function for transmission

//eEpsilonPMatter                epsilon contrained objective function for particulate matter
//eEpsilonGHG                    epsilon contrained objective function for greenhouse gases

eObjectiveFunction             single objective function (costs)
=#

    return nothing
end
