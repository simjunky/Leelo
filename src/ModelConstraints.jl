
# TODO: rewrite docstring
# Constraint creation
"""
    add_model_constraints(model::JuMP.Model, config::SingleObjectiveBasicConfig, data::ModelData, i_current_year::Int64)

TODO

# Arguments

"""
function add_model_constraints(model::JuMP.Model, config::SingleObjectiveBasicConfig, data::ModelData, i_current_year::Int64)

    # TODO: remove unneeded outputs
    @info "adding constraints for single objective optimization"

    add_single_objective_constraints(model, data, i_current_year)

    return nothing
end



# TODO: rewrite docstring
# Constraint creation
"""
    add_model_constraints(model::JuMP.Model, config::SingleObjectiveMultiServiceConfig, data::ModelData, i_current_year::Int64)

TODO

# Arguments

"""
function add_model_constraints(model::JuMP.Model, config::SingleObjectiveMultiServiceConfig, data::ModelData, i_current_year::Int64)

    # TODO: remove unneeded outputs
    @info "adding constraints for single objective multi service optimization"

    add_single_objective_constraints(model, data, i_current_year)
    add_multi_service_constraints(model, data, i_current_year)

    return nothing
end



# TODO: rewrite docstring
# Constraint creation for one specific year
"""
    add_single_objective_constraints(model::JuMP.Model, data::ModelData, i_current_year::Int64)

This is currently the function called to add constraints to the model for the computation for one given year.

# Arguments

"""
function add_single_objective_constraints(model::JuMP.Model, data::ModelData, i_current_year::Int64)

    # TODO: remove unneeded outputs
    @info "add_single_objective_constraints() called for " * string(i_current_year)

    #TODO: all other indices should be called using "data." e.g. data.n_buses

    # Constraints on the Objective function.

    # the yearly operational cost of renewable power generation
    # Calculated by multiplying the operational expenses of a renewable generator by its produced power within a timestep times the duration of the timestep.
    OCr = model[:OCr]
    powerR = model[:powerR]
    @constraint(model, eOperationCostR, OCr == sum((data.costOperationVarR[r, i_current_year] * powerR[t, b, r] * data.dt) for t in 1:data.n_timesteps, b in 1:data.n_buses, r in 1:data.n_ren_generators))


    # the yearly operational cost of conventional power generators
    # Calculated by multiplying the operational expenses of a conventional generator by its produced power within a timestep times the duration of the timestep.
    OCg = model[:OCg]
    powerG = model[:powerG]
    @constraint(model, eOperationCostG, OCg == sum((data.costOperationVarG[g, i_current_year] * powerG[t, b, g] * data.dt) for t in 1:data.n_timesteps, b in 1:data.n_buses, g in 1:data.n_conv_generators))


    # the yearly operational cost of energy storage
    # It is the sum of the operational cost of storage technologies and of conversion technologies.
    # The operational cost of conversion technologies is calculated by multiplying the operational expenses of a convention technology by its produced power within a timestep times the duration of the timestep.
    # The operational cost of storage technologies is calculated by multiplying the operational expenses of a storage technology by its stored and released power within a timestep times the duration of the timestep.
    OCs = model[:OCs]
    powerCT = model[:powerCT]
    storedST = model[:storedST]
    @constraint(model, eOperationCostS, OCs == sum((data.costOperationConvCT[ct, i_current_year] * powerCT[t, b, ct] * data.dt) for t in 1:data.n_timesteps, b in 1:data.n_buses, ct in 1:data.n_conversion_technologies) + sum((data.costOperationVarST[st, i_current_year] * storedST[t, b, st] * data.dt) for t in 1:data.n_timesteps, b in 1:data.n_buses, st in 1:data.n_storage_technologies))


    # the yearly operational cost of power lines
    # Calculated by multiplying the operational expenses of a power line by its transported power in both directions within a timestep times the duration of the timestep.
    OCl = model[:OCl]
    powerLpos = model[:powerLpos]
    powerLneg = model[:powerLneg]
    @constraint(model, eOperationCostL, OCl == sum((data.costOperationVarL[l] * (powerLpos[t, l] + powerLneg[t, l]) * data.dt) for t in 1:data.n_timesteps, l in 1:data.n_lines))


    # other yearly operational costs
    # Calculated as the sum of different penalty costs. Those are the costs of unserved power and spilled power, as well as ficticious power flows. Additionally it contais the coal power ramping penalties.
    # TODO: why is qfictitious not multiplied by data.dt as the rest??
    OCo = model[:OCo]
    powerunserved = model[:powerunserved]
    powerspilled = model[:powerspilled]
    qfictitious = model[:qfictitious]
    rampsCoalHourlyPos = model[:rampsCoalHourlyPos]
    rampsCoalHourlyNeg = model[:rampsCoalHourlyNeg]
    rampsCoalDailyPos = model[:rampsCoalDailyPos]
    rampsCoalDailyNeg = model[:rampsCoalDailyNeg]
    @constraint(model, eOperationCostO, OCo == sum((data.costUnserved * powerunserved[t, b] * data.dt) for t in 1:data.n_timesteps, b in 1:data.n_buses) + sum((data.costSpilled * powerspilled[t, b] * data.dt) for t in 1:data.n_timesteps, b in 1:data.n_buses) + sum((data.costFictitiousFlows * qfictitious[t, h]) for t in 1:data.n_timesteps, h in 1:data.n_hydro_generators) + sum( data.costRampsCoal_hourly * (rampsCoalHourlyPos[t, b] + rampsCoalHourlyNeg[t, b]) for t in 1:data.n_timesteps, b in 1:data.n_buses) + sum( data.costRampsCoal_daily * (rampsCoalDailyPos[t, b] + rampsCoalDailyNeg[t, b]) for t in 1:data.n_timesteps, b in 1:data.n_buses) )


    # yearly fixed operational costs of storage
    # in k€
    # TODO: probably in k$ and not €... ?
    # Calculated as the sum of the yearly fixed operating costs of storages and conversion technologies, which depend on the preexisting and newly installed capacities.
    OCfs = model[:OCfs]
    eST = model[:eST]
    pCT = model[:pCT]
    @constraint(model, eOperationCostFixedS, OCfs == sum((data.costOperationFixST[st, i_current_year] * (1000 * eST[b, st] + data.vExistingST[b, st, i_current_year])) for b in 1:data.n_buses, st in 1:data.n_storage_technologies) + sum((data.costOperationFixCT[ct, i_current_year] * (1000 * pCT[b, ct] + data.pexistingCT[b, ct, i_current_year])) for b in 1:data.n_buses, ct in 1:data.n_conversion_technologies) )


    # yearly fixed operational costs of conventional, renewable, hydro and run-of-river power generation and transmission lines
    # in k€
    # TODO: probably in k$ and not €... ?
    # Calculated as the sum of the yearly fixed operating costs of storages and conversion technologies, which depend on the preexisting and newly installed capacities.
    OCfo = model[:OCfo]
    pG = model[:pG]
    pR = model[:pR]
    pH = model[:pH]
    pL = model[:pL]
    @constraint(model, eOperationCostFixedO, OCfo == sum((data.costOperationFixG[g, i_current_year] * (1000 * pG[b, g] + data.pexistingG[b, g, i_current_year])) for b in 1:data.n_buses, g in 1:data.n_conv_generators) + sum((data.costOperationFixR[r, i_current_year] * (1000 * pR[b, r] + data.pexistingR[b, r, i_current_year])) for b in 1:data.n_buses, r in 1:data.n_ren_generators) + sum((data.costOperationFixH[h] * (1000 * pH[h] + data.pexistingH[h, i_current_year])) for h in 1:data.n_hydro_generators) + sum((data.costOperationFixRoR[ror] * data.pMaxRoR[ror]) for ror in 1:data.n_ror_generators) + sum((data.costOperationFixL[l] * (1000 * pL[l] + data.capLExisting[l, i_current_year])) for l in 1:data.n_lines) )


    # yearly total operational costs
    # in Dollar
    # Calculated as the sum of all precalculated operational costs
    OCt = model[:OCt]
    @constraint(model, eOperationCostT, OCt == OCr + OCg + OCs + OCl + OCo + (1000 * OCfo) + (OCfs * 1000) )


    # yearly investment into renewable power generation
    # Calculated multiplying the interest dependent annuity factor with the capital cost of renewable generators times the newly built capacity (scaled to MW)
    ICr = model[:ICr]
    @constraint(model, eInvestmentCostR, ICr == sum((data.annuityR[r] * data.costCapR[r, i_current_year] * 1000 * pR[b, r]) for b in 1:data.n_buses, r in 1:data.n_ren_generators) )


    # yearly investment into conventional power plants
    # Calculated multiplying the interest dependent annuity factor with the capital cost of conventional generators times the newly built capacity (scaled to MW)
    ICg = model[:ICg]
    @constraint(model, eInvestmentCostG, ICg == sum((data.annuityG[g] * data.costCapG[g, i_current_year] * 1000 * pG[b, g]) for b in 1:data.n_buses, g in 1:data.n_conv_generators) )


    # yearly investment into energy storage and conversion technologies
    # Calculated as the sum of each investment cost. Those are in turn calculated by multiplying the interest dependent annuity factor with the capital cost of installation per MW times the newly built capacity (scaled to MW)
    ICs = model[:ICs]
    @constraint(model, eInvestmentCostS, ICs == sum((data.annuityST[st] * data.costCapST[st, i_current_year] * 1000 * eST[b, st]) for b in 1:data.n_buses, st in 1:data.n_storage_technologies) + sum((data.annuityCT[ct] * data.costCapCT[ct, i_current_year] * 1000 * pCT[b, ct]) for b in 1:data.n_buses, ct in 1:data.n_conversion_technologies) )


    # yearly investment into transmission lines
    # Calculated by multiplying the interest dependent annuity factor with the capital cost per installed MW times the newly built capacity (scaled to MW)
    ICl = model[:ICl]
    @constraint(model, eInvestmentCostL, ICl == sum((data.annuityL[l] * data.costCapL[l] * 1000 * pL[l]) for l in 1:data.n_lines) )


    # yearly investment into transmission lines
    # Calculated by multiplying the interest dependent annuity factor with the capital cost per installed MW times the newly built capacity (scaled to MW)
    ICh = model[:ICh]
    @constraint(model, eInvestmentCostH, ICh == sum((data.costCapUpgradeH[h] * 1000 * pH[h]) for h in 1:data.n_hydro_generators) )


    # TODO: remove this after code review
    # The following equation has not been implemented. GAMS code was:
    # eInvestmentCostO     .. ICo =e= 0;


    # total yearly investment costs
    # Calculated as the sum sum of all individual investment costs, scaled down to match the simulated time span.
    # TODO: why is there a *1000??? (It also was in the GAMS code)
    ICt = model[:ICt]
    @constraint(model, eInvestmentCostT, ICt == data.fractionOfYear * 1000 * (ICr + ICg + ICs + ICl + ICh) )


    # yearly greenhouse gas emissions of renewable power generation
    # Calculated by adding emissions resulting from power plant operation (dependent on produced power), from upstream and downstream emissions depending on installed capacity
    GHGr = model[:GHGr]
    @constraint(model, eGHGr, GHGr == sum((powerR[t, b, r] * data.GHGOperationR[r] * data.dt) for t in 1: data.n_timesteps, b in 1:data.n_buses, r in 1:data.n_ren_generators) + sum((1000 * pR[b, r] * data.GHGupstreamR[r] * data.dt) for b in 1:data.n_buses, r in 1:data.n_ren_generators) + sum((data.pRpho[b, r, i_current_year] * data.GHGdownstreamR[r] * data.dt) for b in 1:data.n_buses, r in 1:data.n_ren_generators) )


    # yearly greenhouse gas emissions of conversion technologies
    # Calculated by adding emissions resulting from conversion technology operation (dependent on converted power), from upstream and downstream emissions depending on installed capacity
    GHGct = model[:GHGct]
    @constraint(model, eGHGct, GHGct == sum((powerCT[t, b, ct] * data.GHGOperationCT[ct] * data.dt) for t in 1: data.n_timesteps, b in 1:data.n_buses, ct in 1:data.n_conversion_technologies) + sum((1000 * pCT[b, ct] * data.GHGupstreamCT[ct] * data.dt) for b in 1:data.n_buses, ct in 1:data.n_conversion_technologies) + sum((data.pCTpho[b, ct, i_current_year] * data.GHGdownstreamCT[ct] * data.dt) for b in 1:data.n_buses, ct in 1:data.n_conversion_technologies) )


    # TODO: why is here no *dt in each sum as in the other GHG calculations?
    # yearly greenhouse gas emissions of storage technologies
    # Calculated by adding emissions resulting from storage operation (dependent on stored power), from upstream and downstream emissions depending on installed capacity
    GHGst = model[:GHGst]
    @constraint(model, eGHGst, GHGst == sum((storedST[t, b, st] * data.GHGOperationST[st]) for t in 1: data.n_timesteps, b in 1:data.n_buses, st in 1:data.n_storage_technologies) + sum((1000 * eST[b, st] * data.GHGupstreamST[st]) for b in 1:data.n_buses, st in 1:data.n_storage_technologies) + sum((data.eSTpho[b, st, i_current_year] * data.GHGdownstreamST[st]) for b in 1:data.n_buses, st in 1:data.n_storage_technologies) )


    # other yearly greenhouse gas emissions including Hyropower, run-of-river power and conventional power generation
    # Calculated by adding emissions resulting from generator operation (dependent on generated power)
    GHGo = model[:GHGo]
    powerRoR = model[:powerRoR]
    powerH = model[:powerH]
    @constraint(model, eGHGothers, GHGo == sum((powerRoR[t, ror] * data.GHGOperationRoR[ror] * data.dt) for t in 1: data.n_timesteps, ror in 1:data.n_ror_generators) + sum((powerH[t, h] * data.GHGOperationH[h] * data.dt) for t in 1:data.n_timesteps, h in 1:data.n_hydro_generators) + sum((powerG[t, b, g] * data.GHGOperationG[g] * data.dt) for t in 1:data.n_timesteps, b in 1:data.n_buses, g in 1:data.n_conv_generators) )


    # sum yearly operational greenhouse gas emissions
    # Calculated by adding oparational emissions resulting from all sources
    GHGoperation = model[:GHGoperation]
    @constraint(model, eGHGoperation, GHGoperation == GHGo + sum((powerR[t, b, r] * data.GHGOperationR[r] * data.dt) for t in 1: data.n_timesteps, b in 1:data.n_buses, r in 1:data.n_ren_generators) + sum((powerCT[t, b, ct] * data.GHGOperationCT[ct] * data.dt) for t in 1: data.n_timesteps, b in 1:data.n_buses, ct in 1:data.n_conversion_technologies) + sum((storedST[t, b, st] * data.GHGOperationST[st]) for t in 1: data.n_timesteps, b in 1:data.n_buses, st in 1:data.n_storage_technologies) )


    # sum yearly operational greenhouse gas emissions
    # Calculated by adding oparational emissions resulting from all sources
    TGHG = model[:TGHG]
    @constraint(model, eTotalGHG, TGHG == GHGr + GHGst + GHGct + GHGo)


    # yearly carbon taxes related to greenhouse gas emissions
    # Calculated by multiplying the operational GHG emissions with the carbon tax per Kg of CO2
    CostGHG = model[:CostGHG]
    @constraint(model, eCostsGHG, CostGHG == GHGoperation * (data.carbonTax[i_current_year] / 1000) )


    # yearly total costs of the system
    # Calculated by adding total investment and operational costs and carbon tax
    TotalCost = model[:TotalCost]
    @constraint(model, eTotalCost, TotalCost == ICt + OCt + CostGHG)


    # TODO: remove this after code review
    # The following equation has not been implemented. GAMS code was:
    # eObjectiveFunction:single objective function (costs)
    # eObjectiveFunction     .. Z =e= TCosts;


#=
TODO: those 5 LCA equations and constraints...
Multiobjective with LCA

eOpTLCA(ic)                      ..OpTLCA(ic)=e=
sum((t,b,r),powerR(t,b,r)*LCAopR(r,ic)*dt)
+sum((t,b,g),powerG(t,b,g)*LCAopG(g,ic)*dt)
+sum((t,b,ct),powerCT(t,b,ct)*LCAopCT(ct,ic)*dt)
+sum((t,b,st),storedST(t,b,st)*LCAopST(st,ic))
+sum((t,h),powerH(t,h)*LCAopH(ic)*dt)
+sum((t,l),(powerLpos(t,l)+powerLneg(t,l))*LCAopL(ic)*dt)
+sum((t,ror),powerRoR(t,ror)*LCAopRoR(ic)*dt);

eConTLCA(ic)                     ..ConTLCA(ic)=e=sum((b,r),pR(b,r)*1000*LCAconR(r,ic))+sum((b,g),pG(b,g)*1000*LCAconG(g,ic))+sum((b,ct),pCT(b,ct)*1000*LCAconCT(ct,ic))+sum((b,st),eST(b,st)*1000*LCAconST(st,ic))+sum(h,pH(h)*1000*LCAconH(ic))+sum((l),pL(l)*1000*LCAconL(l,ic));

eTLCA(ic)                        ..TotalLCA(ic)=e=OpTLCA(ic) + ConTLCA(ic);

eSubObj                          ..Zx=e=sum(ic $(VectorSObj(ic)eq Objcount),TotalLCA(ic));

eEpsilonTLCA(ic)                 ..TotalLCA(ic)=l=EpsilonLCA(ic);
=#


    # maximum power output of conventional generators
    # Calculated by adding (scaled) newly built and pre-existing capacities
    @constraint(model, [t in 1:data.n_timesteps], powerG[t,:,:] .<= 1000 .* pG .+ data.pexistingG )


    # equation removed. Already in variable definition. Old version of it additionally doesnt make a lot of sense (see variable bounds of pG)
    # ePMinG(t,b,g)      .. powerG(t,b,g) =g= 0; //PMinG(g)*pG(b,g); Pmin deactivated


    # total ammount of generated power during the year
    # Calculated by adding total power generation of conventional, renewable, hydro and run-of-river power generation.
    # TODO: shouldnt CSP power generation be included here as well?
    TotalGeneratedPower = model[:TotalGeneratedPower]
    @constraint(model, eGeneratedPower, TotalGeneratedPower == sum(powerG[t, b, g] for t in 1:data.n_timesteps, b in 1:data.n_buses, g in 1:data.n_conv_generators) + sum(powerR[t, b, r] for t in 1:data.n_timesteps, b in 1:data.n_buses, r in 1:data.n_ren_generators) + sum(powerH[t, h] for t in 1:data.n_timesteps, h in 1:data.n_hydro_generators) + sum(powerRoR[t, ror] for t in 1:data.n_timesteps, ror in 1:data.n_ror_generators) )


    # minimal ammount of generated conventional power during the year
    # The sum of all produced conventional power using fossil fuels must be smaller than the given factor of the total ammount of generated power.
    @constraint(model, eMinFossilGeneration, sum(powerG[t, b, g] for t in 1:data.n_timesteps, b in 1:data.n_buses, g in 1:data.n_conv_generators) >= data.minFossilGeneration * TotalGeneratedPower )


    # maximal ammount of generated conventional power during the year
    # The sum of all produced conventional power using fossil fuels must be smaller than the given factor of the total ammount of generated power.
    @constraint(model, eMaxFossilGeneration, sum(powerG[t, b, g] for t in 1:data.n_timesteps, b in 1:data.n_buses, g in 1:data.n_conv_generators) <= data.maxFossilGeneration * TotalGeneratedPower )


    # equation determining the ammount of houly coal power ramping
    # The difference of positive and negative coal ramping has to match the difference of the produced conventional power from one hour to the next.
    # Note: g=1 means the first conventional power source should be coal!
    @constraint(model, [t in 1:data.n_timesteps, b in 1:data.n_buses; t < data.n_timesteps], powerG[t + 1, b, 1] - powerG[t, b, 1] == rampsCoalHourlyPos[t, b] - rampsCoalHourlyNeg[t, b] )


    # equation determining the ammount of daily coal power ramping
    # The difference of positive and negative coal ramping has to match the difference of the produced conventional power from one day to the next (12h).
    # Note: g=1 means the first conventional power source should be coal!
    @constraint(model, [t in 1:data.n_timesteps, b in 1:data.n_buses; t < data.n_timesteps - 11], powerG[t + 12, b, 1] - powerG[t, b, 1] == rampsCoalDailyPos[t, b] - rampsCoalDailyNeg[t, b] )

#=
TODO: these bounds for the coal ramping.
BUT: are they even needed? since powerG is limited by 1000* pG + PexistingG
eRampsCoal1(t,b)                      ..rampsAuxCoal1(t,b) =l=PexistingG(b,'g1');
eRampsCoal2(t,b)                      ..rampsAuxCoal2(t,b) =l=PexistingG(b,'g1');
eRampsCoal3(t,b)                      ..rampsAuxCoal3(t,b) =l=PexistingG(b,'g1');
eRampsCoal4(t,b)                      ..rampsAuxCoal4(t,b) =l=PexistingG(b,'g1');
=#


    # upper limit for generated renewable power
    # renewable power generation is limited by the existing and newly built capacity scaled by the generation profile, which dictates if the sun shines or wind blows.
    @constraint(model, [t in 1:data.n_timesteps, b in 1:data.n_buses, r in 1:data.n_ren_generators], powerR[t, b, r] <= data.profilesR[t, b, r] * (1000 * pR[b, r] + data.pexistingR[b, r, i_current_year]) )


    # spilled renewable power
    # the ammount of spilled renewable power is equal to the difference of the maximal possible renewable power generation acording tho the generation profile and the generated renewable power.
    @constraint(model, [t in 1:data.n_timesteps, b in 1:data.n_buses], powerspilled[t, b] == sum(data.profilesR[t, b, r] * (1000 * pR[b, r] + data.pexistingR[b, r, i_current_year]) for r in 1:data.n_ren_generators) - sum(powerR[t, b, r] for r in 1:data.n_ren_generators) )


    # upper limit for spilled renewable power
    # the sum of spiled renewable power is limited by a faktor ∈[0,1] multiplied by the maximal possible renewable power generation.
    @constraint(model, eEnergySpilledMax, sum(powerspilled[t, b] for t in 1:data.n_timesteps, b in 1:data.n_buses) <= data.energyCurtailedMax * sum(data.profilesR[t, b, r] * (1000 * pR[b, r] + data.pexistingR[b, r, i_current_year]) for t in 1:data.n_timesteps, b in 1:data.n_buses, r in 1:data.n_ren_generators) )


    # building renewables are independent from their profile
    # the newly built capacity of a renewable energy r in a bus b has to be the same for all equal renewable energies r.
    # This is due to the fact that eg. solar or wind have multiple profiles per node, but one cannot built on one specifiv profile, but has to build uniformaly on all of them.
    @constraint(model, [r in 1:data.n_ren_generators, rr in 1:data.n_ren_generators, b in 1:data.n_buses; data.technologyR[r] == data.technologyR[rr] ], pR[b, r] == pR[b, rr] )


    # limit CSP (concentrated solar power) power production
    # the power produced by csp is limited by the generation profile (available sunshine) times the total installed capacity.
    # Note: CSP is implemented as conversion technology rather than renewable due to its possibility to store energy as heat.
    @constraint(model, [t in 1:data.n_timesteps, b in 1:data.n_buses, ct in 1:data.n_conversion_technologies; data.vectorCT_O[ct] == "sun"], powerCT[t, b, ct] <= data.ProfilesCSP[t, b] * (1000 * pCT[b, ct] + data.pexistingCT[b, ct, i_current_year]) )


    # CASCADING HYDROPOWER


    # change in stored water for hydro generators
    # change is calculated as difference dependent on all different in- and outflow sources.
    storedH = model[:storedH]
    vLossH = model[:vLossH]
    qturbined = model[:qturbined]
    qpumped = model[:qpumped]
    qdiverted = model[:qdiverted]
    qreserve = model[:qreserve]
    qfictitious = model[:qfictitious]
    qdivertedupstream = model[:qdivertedupstream]
    qturbinedupstream = model[:qturbinedupstream]
    qpumpeddownstream = model[:qpumpeddownstream]
    @constraint(model, [t in 1:data.n_timesteps, h in 1:data.n_hydro_generators; t < data.n_timesteps], storedH[t + 1, h] - storedH[t, h] == -vLossH[t, h] + data.dt * 3600 * (data.qInflowH[t, h] - qturbined[t, h] - qpumped[t, h] - qdiverted[t, h] - qreserve[t, h] + qfictitious[t, h] + qdivertedupstream[t, h] + qturbinedupstream[t, h] + qpumpeddownstream[t, h]) )


    # volume of water lost to evaporation or seepage
    # the losses are calculated using the loss factor adjusted to 1 hour times the ammount of stored water.
    @constraint(model, [t in 1:data.n_timesteps, h in 1:data.n_hydro_generators; t < data.n_timesteps], vLossH[t, h] == storedH[t, h] * data.lossesH[h] * data.dt / 24 )


    # water storage constraint for annual transition
    # the stores ammount at the end of the year should not be less than at the start.
    # Note: this avoids complete depletion of al reservoirs to reduce power generation cost.
    @constraint(model, [h in 1:data.n_hydro_generators], storedH[1, h] <= storedH[data.n_timesteps, h] )

#=
TODO: above constraint should replace these three:
TODO: therefore the corresponding variables vIniH and vFinH should be removed.
eVolumeIniFinH(h)              .. vFinH(h) =g= vIniH(h);
eVolumeIniH(tfirst,h)          .. storedH(tfirst,h) =e= vIniH(h);
eVolumeFinH(tlast,h)           .. storedH(tlast,h)  =e= vFinH(h);
=#


    # upper limit for the ammount of stored water in a reservoir
    # the parameter has to be adjusted from million m^3 to m^3
    @constraint(model, [t in 1:data.n_timesteps, h in 1:data.n_hydro_generators], storedH[t, h] <= data.vMaxH[h] * 1000000 )


    # lower limit for the ammount of stored water in a reservoir
    # the parameter has to be adjusted from million m^3 to m^3
    @constraint(model, [t in 1:data.n_timesteps, h in 1:data.n_hydro_generators], storedH[t, h] >= data.vMinH[h] * 1000000 )


    # upper limit for the power production from hydro generators
    # the generated power has to be less than the existing and newly built capacities combined.
    @constraint(model, [t in 1:data.n_timesteps, h in 1:data.n_hydro_generators], powerH[t, h] <= data.pexistingH[h, i_current_year] + 1000 * pH[h] )


    # lower limit for the power production from hydro generators
    # the generated power has to be greater than some given minimum.
    @constraint(model, [t in 1:data.n_timesteps, h in 1:data.n_hydro_generators], powerH[t, h] >= data.pMinH[h] )


    # upper limit for the power needed to pump excess water or refill reservoirs
    # the used power has to be less than the existing and newly built capacities combined.
    powerHpump = model[:powerHpump]
    @constraint(model, [t in 1:data.n_timesteps, h in 1:data.n_hydro_generators], powerHpump[t, h] <= data.pexistingH[h, i_current_year] + 1000 * pH[h] )


    # lower limit for the ammount of diverted water of a reservoir, often for ecological reasons
    # limit given by parameter for each hydro generator
    @constraint(model, [t in 1:data.n_timesteps, h in 1:data.n_hydro_generators], qdiverted[t, h] >= data.qDivertedMinH[h] )


    # ammount of water diverted upstream ending in reservoir
    # calculated by summing up the ammount of diverted water from each reservoir, where diverted water gets diverted to current reservoir.
    @constraint(model, [t in 1:data.n_timesteps, h in 1:data.n_hydro_generators], qdivertedupstream[t, h] == sum(qdiverted[t, other_h] for other_h in findall(==(data.h_hydro_power_generators_names[h]), data.divertedGoesTo)) )


    # ammount of water turbined upstream ending in reservoir
    # calculated by summing up the ammount of turbined water from each reservoir, where turbined water gets diverted to current reservoir.
    @constraint(model, [t in 1:data.n_timesteps, h in 1:data.n_hydro_generators], qturbinedupstream[t, h] == sum(qturbined[t, other_h] for other_h in findall(==(data.h_hydro_power_generators_names[h]), data.turbinedGoesTo)) )


    # ammount of water pumped up from downstream ending in reservoir
    # calculated by summing up the ammount of pumped water from each reservoir, where pumped water end up in current reservoir.
    @constraint(model, [t in 1:data.n_timesteps, h in 1:data.n_hydro_generators], qpumpeddownstream[t, h] == sum(qpumped[t, other_h] for other_h in findall(==(data.h_hydro_power_generators_names[h]), data.pumpedGoesTo)) )


    # ammount of power produced by turbine
    # calculated by scaling the ammount of turbined water with a hydro generator specific yield parameter.
    @constraint(model, [t in 1:data.n_timesteps, h in 1:data.n_hydro_generators], powerH[t, h] == data.kH[h] * qturbined[t, h] )


    # ammount of power needed by turbine to pump
    # calculated by scaling the ammount of pumped water with a reduced hydro generator specific yield parameter.
    @constraint(model, [t in 1:data.n_timesteps, h in 1:data.n_hydro_generators], powerHpump[t, h] == 0.9 * data.kH[h] * qpumped[t, h] )


    # upper limit for power produced by run-of-river power plants
    # calculated by scaling the installed capacity of RoR generators with their generation profile (modeling usable river flow).
    @constraint(model, [t in 1:data.n_timesteps, ror in 1:data.n_ror_generators], powerRoR[t, ror] <= data.profilesRoR[t, ror] * data.pMaxRoR[ror] )


    # upper limit for power produced by conversion technologies
    # calculated adding existing and newly built capacities.
    @constraint(model, [t in 1:data.n_timesteps, b in 1:data.n_buses, ct in 1:data.n_conversion_technologies], powerCT[t, b, ct] <= 1000 * pCT[b, ct] + data.pexistingCT[b, ct, i_current_year] )


    # the approach for powerCT: unit is MW if either VectorCT_O or VectorCT_D is electricity. If not, it is the entity VectorCT_D per unit time.
    # So, in the energy balance equation, we separate the CT that DON'T have VectorCT_O as electricity while charging, they DO NOT need the CF. While Discharging, all need the CF, whether the VectorCT_D is electricity or not!


    # total energy balance for all storage technologies
    # calculated by summing up the losses of stored energy, the sum of energy converted using electricity and the sum converted from other sources. Then, the sum of expended stored energy is subtracted.
    vLossST = model[:vLossST]
    @constraint(model, [t in 1:data.n_timesteps, b in 1:data.n_buses, st in 1:data.n_storage_technologies; t < data.n_timesteps], storedST[t + 1, b, st] - storedST[t, b, st] == -vLossST[t, b, st] + sum(data.conversionFactorCT[ct, i_current_year] * data.conversionEfficiencyCT[ct, i_current_year] * powerCT[t, b, ct] * data.dt for ct in 1:data.n_conversion_technologies if ((data.vectorCT_D[ct] == data.storageEntityST[st]) && (data.vectorCT_O[ct] == "e"))) + sum(data.conversionEfficiencyCT[ct, i_current_year] * powerCT[t, b, ct] * data.dt for ct in 1:data.n_conversion_technologies if ((data.vectorCT_D[ct] == data.storageEntityST[st]) && (data.vectorCT_O[ct] != "e"))) - sum(powerCT[t, b, ct] / (data.conversionFactorCT[ct, i_current_year] * data.conversionEfficiencyCT[ct, i_current_year]) * data.dt for ct in 1:data.n_conversion_technologies if (data.vectorCT_O[ct] == data.storageEntityST[st])) )


    # limit for conversion with origin entities not stored in any storage technology
    # destination products are not checked, because if it is an intermediary product (i.e. != "e") it must have another technology which is included here to turn it into something useful. Else it is a conversion path with a dead end and therefore can be ignored, since it only wastes power.
    # TODO
    @constraint(model, [t in 1:data.n_timesteps, b in 1:data.n_buses, ct in 1:data.n_conversion_technologies; !((data.vectorCT_O[ct] in data.storageEntityST) || (data.vectorCT_O[ct] in ["e", "sun"]))], sum(powerCT[t, b, ct_1] for ct_1 in 1:data.n_conversion_technologies if (data.vectorCT_O[ct_1] == data.vectorCT_O[ct]) ) == sum(powerCT[t, b, ct_2] for ct_2 in 1:data.n_conversion_technologies if ((ct != ct_2) && (data.vectorCT_D[ct_2] == data.vectorCT_O[ct]))) )


    # storage boundary condition
    # the ammount of stored energy in each bus should be the same at the begining and end of the year and for every storage technology.
    # This constraint is not valid for Carbon capture technologies (CO2).
    @constraint(model, [b in 1:data.n_buses, st in 1:data.n_storage_technologies; data.storageEntityST[st] != "CO2"], storedST[1, b, st] == storedST[data.n_timesteps, b, st] )


    # losses of stored energy
    # the loss is proportional to the currently stored ammount of energy
    @constraint(model, [t in 1:data.n_timesteps, b in 1:data.n_buses, st in 1:data.n_storage_technologies], vLossST[t, b, st] == storedST[t, b, st] * data.lossesST[st] /24 * data.dt )


    # upper limit for stored energy
    # the upper limit is given by the built storage capacity (scaled to MW) and existing capacity.
    # Carbon capture is excluded, it has its own constraint.
    @constraint(model, [t in 1:data.n_timesteps, b in 1:data.n_buses, st in 1:data.n_storage_technologies; data.storageEntityST[st] != "CO2"], storedST[t, b, st] <= 1000 * eST[b, st] + data.vExistingST[b, st, i_current_year] )


    # upper limit for carbon capture
    # the upper limit is given as 20% of only the newly built storage capacity (scaled to MW).
    @constraint(model, [t in 1:data.n_timesteps, b in 1:data.n_buses, st in 1:data.n_storage_technologies; data.storageEntityST[st] == "CO2"], storedST[t, b, st] <= 0.2 * 1000 * eST[b, st] )


    # lower limit for stored energy
    # the lower limit is given as factor of the total installed capacity.
    # Carbon capture storage is excluded, it has its own constraint.
    @constraint(model, [t in 1:data.n_timesteps, b in 1:data.n_buses, st in 1:data.n_storage_technologies; data.storageEntityST[st] != "CO2"], storedST[t, b, st] >= data.vMinST[st] * (1000 * eST[b, st] + data.vExistingST[b, st, i_current_year]) )


    # lower limit for carbon capture
    # the lower limit is given as factor of only the newly built storage capacity (scaled to MW).
    @constraint(model, [t in 1:data.n_timesteps, b in 1:data.n_buses, st in 1:data.n_storage_technologies; data.storageEntityST[st] == "CO2"], storedST[t, b, st] >= data.vMinST[st] * 1000 * eST[b, st] )


    # Energy2Power conversion ratios
    # there exists one Min & Max for each charging & discharging
    # Carbon capture has its own constraint

    # Energy2Power ratio maximum for charging systems
    # computed as TODO...
    @constraint(model, [b in 1:data.n_buses, st in 1:data.n_storage_technologies; data.storageEntityST[st] != "CO2"], 1000 * eST[b, st] + data.vExistingST[b, st, i_current_year] <= data.energy2PowerRatioMax[st] * sum( (1000 * pCT[b, ct]+ data.pexistingCT[b, ct, i_current_year]) * data.conversionFactorCT[ct, i_current_year] for ct in 1:data.n_conversion_technologies if (data.vectorCT_D[ct] == data.storageEntityST[st])) )


    # Energy2Power ratio maximum for discharging systems
    # computed as TODO...
    @constraint(model, [b in 1:data.n_buses, st in 1:data.n_storage_technologies; data.storageEntityST[st] != "CO2"], 1000 * eST[b, st] + data.vExistingST[b, st, i_current_year] <= data.energy2PowerRatioMax[st] * sum( (1000 * pCT[b, ct]+ data.pexistingCT[b, ct, i_current_year]) / data.conversionFactorCT[ct, i_current_year] for ct in 1:data.n_conversion_technologies if (data.vectorCT_O[ct] == data.storageEntityST[st])) )


    # Energy2Power ratio minimum for charging systems
    # computed as TODO...
    @constraint(model, [b in 1:data.n_buses, st in 1:data.n_storage_technologies; data.storageEntityST[st] != "CO2"], 1000 * eST[b, st] + data.vExistingST[b, st, i_current_year] >= data.energy2PowerRatioMin[st] * sum( (1000 * pCT[b, ct] + data.pexistingCT[b, ct, i_current_year]) * data.conversionFactorCT[ct, i_current_year] for ct in 1:data.n_conversion_technologies if (data.vectorCT_D[ct] == data.storageEntityST[st])) )


    # Energy2Power ratio minimum for discharging systems
    # computed as TODO...
    @constraint(model, [b in 1:data.n_buses, st in 1:data.n_storage_technologies; data.storageEntityST[st] != "CO2"], 1000 * eST[b, st] + data.vExistingST[b, st, i_current_year] >= data.energy2PowerRatioMin[st] * sum( (1000 * pCT[b, ct] + data.pexistingCT[b, ct, i_current_year]) / data.conversionFactorCT[ct, i_current_year] for ct in 1:data.n_conversion_technologies if (data.vectorCT_O[ct] == data.storageEntityST[st])) )


    # Energy2Power ratio minimum for carbon capture systems
    # computed as TODO...
    # Note: for carbon capture no minimum necessairy and charging only.
    @constraint(model, [b in 1:data.n_buses, st in 1:data.n_storage_technologies; data.storageEntityST[st] == "CO2"], 0.2 * 1000 * eST[b, st] >= data.energy2PowerRatioMin[st] * sum( (1000 * pCT[b, ct] + data.pexistingCT[b, ct, i_current_year]) * data.conversionFactorCT[ct, i_current_year] for ct in 1:data.n_conversion_technologies if (data.vectorCT_D[ct] == data.storageEntityST[st])) )


    # max number of discharge cycles from storage
    # computed as TODO...
    # cyclesST represents the max no. of cycles allowed for a ST in its lifetime. In the following, the LHS represents the no. of complete discharges (cycles) of ST in the simulation period.
    # the RHS represents the max allowed cycles in the simulation period (whatever fraction of year taken!)
    @constraint(model, [b in 1:data.n_buses, st in 1:data.n_storage_technologies; data.storageEntityST[st] != "CO2"], data.dt * sum( powerCT[t, b, ct] / data.conversionFactorCT[ct, i_current_year]  for t in 1:data.n_timesteps, ct in 1:data.n_conversion_technologies if (data.vectorCT_O[ct] == data.storageEntityST[st])) <= (1000 * eST[b, st] + data.vExistingST[b, st, i_current_year]) * data.cyclesST[st] / data.lifetimeST[st, i_current_year] * data.fractionOfYear )


    # Transmision constraints

    # upper limit for building transmission lines
    # TODO: this should already exist as variable bound of pL
    @constraint(model, [l in 1:data.n_lines], pL[l] <= (data.maxCapacityPotL[l] - data.capLExisting[l, i_current_year]) / 1000 )


    # upper limit for transmission line throughput (positive direction)
    # throughput is limited by the built and existing line capacity
    @constraint(model, [t in 1:data.n_timesteps, l in 1:data.n_lines], powerLpos[t, l] <= 1000 * pL[l] + data.capLExisting[l, i_current_year] )


    # upper limit for transmission line throughput (negative direction)
    # throughput is limited by the built and existing line capacity
    @constraint(model, [t in 1:data.n_timesteps, l in 1:data.n_lines], powerLneg[t, l] <= 1000 * pL[l] + data.capLExisting[l, i_current_year] )


    # power line losses of line l
    # the losses are equal to a loss factor of the total throughput in both directions
    powerLlosses = model[:powerLlosses]
    @constraint(model, [t in 1:data.n_timesteps, l in 1:data.n_lines], powerLlosses[t, l] == (powerLpos[t, l] + powerLneg[t, l]) * data.lossesL[l] )


    # power imports of bus b
    # the sum of transfered power ending up in bus b without half of the losses occuring on the lines.
    # this means losses are allocated equally in b_ori and b_des.
    powerBimp = model[:powerBimp]
    @constraint(model, [t in 1:data.n_timesteps, b in 1:data.n_buses], powerBimp[t, b] == sum( (powerLpos[t, l] - powerLneg[t, l] - powerLlosses[t, l] / 2) for l in 1:data.n_lines if (data.barD[l] == b)) )


    # power exports of bus b
    # the sum of transfered power leaving bus b without half of the losses occuring on the lines.
    # this means losses are allocated equally in b_ori and b_des.
    powerBexp = model[:powerBexp]
    @constraint(model, [t in 1:data.n_timesteps, b in 1:data.n_buses], powerBexp[t, b] == sum( (powerLpos[t, l] - powerLneg[t, l] + powerLlosses[t, l] / 2) for l in 1:data.n_lines if (data.barO[l] == b)) )


    # power systems

    # demand power balance
    # the demand has to equal the sum of produced, used and unserved power.
    @constraint(model, [t in 1:data.n_timesteps, b in 1:data.n_buses], data.demand[t, b, i_current_year] == powerunserved[t, b] + powerBimp[t, b] - powerBexp[t, b] + sum(powerG[t, b, g] for g in 1:data.n_conv_generators) + sum(powerR[t, b, r] for r in 1:data.n_ren_generators) + sum(powerH[t, h] - powerHpump[t, h] for h in 1:data.n_hydro_generators if (data.busH[h] == b)) + sum(powerRoR[t, ror] for ror in 1:data.n_ror_generators if (data.busRoR[ror] == b)) - sum(powerCT[t, b, ct] for ct in 1:data.n_conversion_technologies if (data.vectorCT_O[ct] == "e")) + sum(powerCT[t, b, ct] for ct in 1:data.n_conversion_technologies if (data.vectorCT_D[ct] == "e")) )


    return nothing
end



# TODO: rewrite docstring
# Constraint creation for one specific year
"""
    add_multi_service_constraints(model::JuMP.Model, data::ModelData, i_current_year::Int64)

TODO

# Arguments

"""
function add_multi_service_constraints(model::JuMP.Model, data::ModelData, i_current_year::Int64)

    # TODO: remove unneeded outputs
    @info "add_multi_service_constraints() called for " * string(i_current_year)

    # power reserves

    # system requirement for operating reserve
    # the reserve depends on the reserve for largest power plant, the demand dependent reserve and a reserve dependent on the maximal renewable power production.
    # Note: ReserveLargestUnit is >0 only if ReserveFast=0;
    reserveOperatingReq = model[:reserveOperatingReq]
    pR = model[:pR]
    @constraint(model, [t in 1:data.n_timesteps],  reserveOperatingReq[t] == data.reserveLargestUnit + data.reserveDemand * sum(data.demand[t, b, i_current_year] for b in 1:data.n_buses) + data.reserveRenewables * sum(data.profilesR[t, b, r] * (data.pexistingR[b, r, i_current_year] + 1000 * pR[b, r]) for b in 1:data.n_buses, r in 1:data.n_ren_generators) )


    # system requirement for frequency reserve
    # TODO: is this constraint really needed?
    reserveFrequencyReq = model[:reserveFrequencyReq]
    @constraint(model, [t in 1:data.n_timesteps],  reserveFrequencyReq[t] == data.reserveFast )


    # total provided operating reserve
    # the reserves of conversion technologies, conventional generators an hydro grnerators have to be greater than the required reserve.
    reserveOperatingCT = model[:reserveOperatingCT]
    reserveOperatingH = model[:reserveOperatingH]
    reserveOperatingG = model[:reserveOperatingG]
    @constraint(model, [t in 1:data.n_timesteps],  reserveOperatingReq[t] <= sum(reserveOperatingCT[t, b, ct] for b in 1:data.n_buses, ct in 1:data.n_conversion_technologies if (data.vectorCT_D[ct] == "e")) + sum(reserveOperatingH[t, h] for h in 1:data.n_hydro_generators if (data.vMaxH[h] > 0.0)) + sum(reserveOperatingG[t, b, g] for b in 1:data.n_buses, g in 1:data.n_conv_generators) )


    # total provided frequency reserve
    # the frequency reserves of conversion technologies, conventional generators an hydro grnerators have to be greater than the required reserve.
    # giving freq reserve only to Li-ion storage.
    reserveFrequencyCT = model[:reserveFrequencyCT]
    reserveFrequencyH = model[:reserveFrequencyH]
    reserveFrequencyG = model[:reserveFrequencyG]
    @constraint(model, [t in 1:data.n_timesteps],  reserveFrequencyReq[t] <= sum(reserveFrequencyCT[t, b, ct] for b in 1:data.n_buses, ct in 1:data.n_conversion_technologies if (data.vectorCT_O[ct] == "li-ions")) + sum(reserveFrequencyH[t, h] for h in 1:data.n_hydro_generators if (data.vMaxH[h] > 0.0)) + sum(reserveFrequencyG[t, b, g] for b in 1:data.n_buses, g in 1:data.n_conv_generators) )


    # maximal provived reserve by hydro generators
    # the sum of reserves and produced power are limited by the built and existing capacities.
    powerH = model[:powerH]
    pH = model[:pH]
    @constraint(model, [t in 1:data.n_timesteps, h in 1:data.n_hydro_generators; data.vMaxH[h] > 0.0], reserveFrequencyH[t, h] + reserveOperatingH[t, h] + powerH[t, h] <= 1000 * pH[h] + data.pexistingH[h, i_current_year] )


    # maximal provived reserve by conventional generators
    # the sum of reserves and produced power are limited by the built and existing capacities.
    powerG = model[:powerG]
    pG = model[:pG]
    @constraint(model, [t in 1:data.n_timesteps, b in 1:data.n_buses, g in 1:data.n_conv_generators], reserveFrequencyG[t, b, g] + reserveOperatingG[t, b, g] + powerG[t, b, g] <= 1000 * pG[b, g] + data.pexistingG[b, g, i_current_year] )


    # maximal provived reserve by conversion technologies
    # the sum of reserves and produced power are limited by the built and existing capacities.
    powerCT = model[:powerCT]
    pCT = model[:pCT]
    @constraint(model, [t in 1:data.n_timesteps, b in 1:data.n_buses, ct in 1:data.n_conversion_technologies; data.vectorCT_D[ct] == "e"], reserveFrequencyCT[t, b, ct] + reserveOperatingCT[t, b, ct] + powerCT[t, b, ct] <= 1000 * pCT[b, ct] + data.pexistingCT[b, ct, i_current_year] )


    # energy availability condition in ST corr to CT
    # stored energy has to be greater than the ammount of energy taken out in addition to the reserve.
    storedST = model[:storedST]
    @constraint(model, [t in 1:data.n_timesteps, b in 1:data.n_buses, st in 1:data.n_storage_technologies], storedST[t, b, st] >= data.dt * ( sum(powerCT[t, b, ct] / data.conversionFactorCT[ct, i_current_year] for ct in 1:data.n_conversion_technologies if (data.vectorCT_O[ct] == data.storageEntityST[st])) + sum((reserveFrequencyCT[t, b, ct] + reserveOperatingCT[t, b, ct]) / data.conversionFactorCT[ct, i_current_year] for ct in 1:data.n_conversion_technologies if ((data.vectorCT_O[ct] == data.storageEntityST[st]) && (data.vectorCT_D[ct] == "e"))) ) )


    # conversion from water to reserve (estimate)
    # the reserved water flow times the Water2Power yield has to be equal to the sum of operational and frequency reserves.
    qreserve = model[:qreserve]
    @constraint(model, [t in 1:data.n_timesteps, h in 1:data.n_hydro_generators], qreserve[t, h] * data.kH[h] == data.reserveOUsedRatio * reserveOperatingH[t, h] + data.reserveFUsedRatio * reserveFrequencyH[t, h] )


    # water availability condition for reserve
    # the stored energy in the water needs to be greater than the produced energy and reserves combined.
    storedH = model[:storedH]
    @constraint(model, [t in 1:data.n_timesteps, h in 1:data.n_hydro_generators; data.vMaxH[h] > 0.0], storedH[t, h] >= data.dt * (reserveOperatingH[t, h] + reserveFrequencyH[t, h] + powerH[t, h]) )


    # autonomy constraints
    # Note: autonomyST units are MWh electrical which don't always match with storedST units; but are better for consistency

    # energy to be stored at all times in ESS
    # the autonomy given by storage technologies and hydro reservoirs should be greater than the required autonomy.
    autonomyST = model[:autonomyST]
    autonomyH = model[:autonomyH]
    @constraint(model, [t in 1:data.n_timesteps], data.Autonomy <= sum(autonomyST[t, b, st] for b in 1:data.n_buses, st in 1:data.n_storage_technologies if (data.storageEntityST[st] != "heat"))
    + sum(autonomyH[t, h] for h in 1:data.n_hydro_generators if (data.vMaxH[h] > 0.0)) )


    # upper limit for autonomy given by stored energy
    # the autonomy given by storage technologies is less than the ammount of stored energy.
    @constraint(model, [t in 1:data.n_timesteps, b in 1:data.n_buses, st in 1:data.n_storage_technologies; data.storageEntityST[st] != "heat"], autonomyST[t, b, st] <= storedST[t, b, st] )


    # upper limit for autonomy depending on deliverable energy
    # autonomy offered by storage technologies must be less than the sum of discharging capacity times autonomy hours.
    @constraint(model, [t in 1:data.n_timesteps, b in 1:data.n_buses, st in 1:data.n_storage_technologies; data.storageEntityST[st] != "heat"], autonomyST[t, b, st] <= data.AutonomyHours *
    sum((1000 * pCT[b, ct] + data.pexistingCT[b, ct, i_current_year]) for ct in 1:data.n_conversion_technologies if ((data.vectorCT_O[ct] == data.storageEntityST[st]) && (data.vectorCT_D[ct] == "e"))) )


    # upper limit for autonomy offered by hydropower depending on storage
    # the energy held back for autonomy reasons has to be stored.
    @constraint(model, [t in 1:data.n_timesteps, h in 1:data.n_hydro_generators; data.vMaxH[h] > 0.0], autonomyH[t, h] <= storedH[t, h] )


    # upper limit for autonomy offered by hydropower depending on capacity
    # makes sure offered AutonomyH can be delivered
    @constraint(model, [t in 1:data.n_timesteps, h in 1:data.n_hydro_generators; data.vMaxH[h] > 0.0], autonomyH[t, h] <= data.AutonomyHours * (1000 * pH[h] + data.pexistingH[h, i_current_year]) )


    return nothing
end
