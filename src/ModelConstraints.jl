
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


    # yearly investment into conventional power plants
    # Calculated multiplying the interest dependent annuity factor with the capital cost of conventional generators times the newly built capacity (scaled to MW)
    @constraint(model, eInvestmentCostG, ICg == sum((data.annuityG[g] * costCapG[g, i_current_year] * 1000 * pG[b, g]) for b in 1:data.n_buses, g in 1:data.n_conv_generators) )


    # yearly investment into energy storage and conversion technologies
    # Calculated as the sum of each investment cost. Those are in turn calculated by multiplying the interest dependent annuity factor with the capital cost of installation per MW times the newly built capacity (scaled to MW)
    @constraint(model, eInvestmentCostS, ICs == sum((data.annuityST[st] * costCapST[st, i_current_year] * 1000 * eST[b, st]) for b in 1:data.n_buses, st in 1:data.n_storage_technologies) + sum((data.annuityCT[ct] * costCapCT[ct, i_current_year] * 1000 * pCT[b, ct]) for b in 1:data.n_buses, st in 1:data.n_conversion_technologies) )


    # yearly investment into transmission lines
    # Calculated by multiplying the interest dependent annuity factor with the capital cost per installed MW times the newly built capacity (scaled to MW)
    @constraint(model, eInvestmentCostL, ICl == sum((data.annuityL[l] * costCapL[l] * 1000 * pL[l]) for l in 1:data.n_lines) )


    # yearly investment into transmission lines
    # Calculated by multiplying the interest dependent annuity factor with the capital cost per installed MW times the newly built capacity (scaled to MW)
    @constraint(model, eInvestmentCostH, ICh == sum((data.costCapUpgradeH[h] * 1000 * pH[h]) for h in 1:data.n_hydro_generators) )


    # The following equation has not been implemented. GAMS code was:
    # eInvestmentCostO     .. ICo =e= 0;


    # yearly investment into transmission lines
    # Calculated by multiplying the interest dependent annuity factor with the capital cost per installed MW times the newly built capacity (scaled to MW)
    @constraint(model, eInvestmentCostT, ICt == data.fractionOfYear * 1000 * (ICr + ICg + ICs + ICl + ICh) )


    # yearly greenhouse gas emissions of renewable power generation
    # Calculated by adding emissions resulting from power plant operation (dependent on produced power), from upstream and downstream emissions depending on installed capacity
    @constraint(model, eGHGr, GHGr == sum((powerR[t, b, r] * data.GHGOperationR[r] * data.dt) for t in 1: data.n_timesteps, b in 1:data.n_buses, r in 1:data.n_ren_generators) + sum((1000 * pR[b, r] * data.GHGupstreamR[r] * data.dt) for b in 1:data.n_buses, r in 1:data.n_ren_generators) + sum((pRpho[b, r] * data.GHGdownstreamR[r] * data.dt) for b in 1:data.n_buses, r in 1:data.n_ren_generators) )


    # yearly greenhouse gas emissions of conversion technologies
    # Calculated by adding emissions resulting from conversion technology operation (dependent on converted power), from upstream and downstream emissions depending on installed capacity
    @constraint(model, eGHGct, GHGct == sum((powerCT[t, b, ct] * data.GHGOperationCT[ct] * data.dt) for t in 1: data.n_timesteps, b in 1:data.n_buses, ct in 1:data.n_conversion_technologies) + sum((1000 * pCT[b, ct] * data.GHGupstreamCT[ct] * data.dt) for b in 1:data.n_buses, ct in 1:data.n_conversion_technologies) + sum((pCTpho[b, ct] * data.GHGdownstreamCT[ct] * data.dt) for b in 1:data.n_buses, ct in 1:data.n_conversion_technologies) )


    # TODO: why is here no *dt in each sum as in the other GHG calculations?
    # yearly greenhouse gas emissions of storage technologies
    # Calculated by adding emissions resulting from storage operation (dependent on stored power), from upstream and downstream emissions depending on installed capacity
    @constraint(model, eGHGst, GHGst == sum((storedST[t, b, st] * data.GHGOperationST[st]) for t in 1: data.n_timesteps, b in 1:data.n_buses, st in 1:data.n_storage_technologies) + sum((1000 * eST[b, st] * data.GHGupstreamST[st]) for b in 1:data.n_buses, st in 1:data.n_storage_technologies) + sum((eSTpho[b, st] * data.GHGdownstreamST[st]) for b in 1:data.n_buses, st in 1:data.n_storage_technologies) )


    # other yearly greenhouse gas emissions including Hyropower, run-of-river power and conventional power generation
    # Calculated by adding emissions resulting from generator operation (dependent on generated power)
    @constraint(model, eGHGothers, GHGo == sum((powerROR[t, ror] * data.GHGOperationROR[ror] * data.dt) for t in 1: data.n_timesteps, ror in 1:data.n_ror_generators) + sum((powerH[t, h] * data.GHGOperationH[h] * data.dt) for t in 1:data.n_timesteps, h in 1:data.n_hydro_generators) + sum((powerG[t, b, g] * data.GHGOperationG[g] * data.dt) for t in 1:data.n_timesteps, b in 1:data.n_buses, g in 1:data.n_conv_generators) )


    # sum yearly operational greenhouse gas emissions
    # Calculated by adding oparational emissions resulting from all sources
    @constraint(model, eGHGoperation, GHGoperation == GHGo + sum((powerR[t, b, r] * data.GHGOperationR[r] * data.dt) for t in 1: data.n_timesteps, b in 1:data.n_buses, r in 1:data.n_ren_generators) + sum((powerCT[t, b, ct] * data.GHGOperationCT[ct] * data.dt) for t in 1: data.n_timesteps, b in 1:data.n_buses, ct in 1:data.n_conversion_technologies) + sum((storedST[t, b, st] * data.GHGOperationST[st]) for t in 1: data.n_timesteps, b in 1:data.n_buses, st in 1:data.n_storage_technologies) )


    # sum yearly operational greenhouse gas emissions
    # Calculated by adding oparational emissions resulting from all sources
    @constraint(model, eTotalGHG, TGHG == GHGr + GHGst + GHGct + GHGo)


    # yearly carbon taxes related to greenhouse gas emissions
    # Calculated by multiplying the operational GHG emissions with the carbon tax per Kg of CO2
    @constraint(model, eCostsGHG, costGHG == GHGoperation * data.carbonTax / 1000)


    # yearly total costs of the system
    # Calculated by adding total investment and operational costs and carbon tax
    @constraint(model, eTotalCost, TotalCost == ICt + OCt + costGHG)

    # The following equation has not been implemented. GAMS code was:
    # eObjectiveFunction:single objective function (costs)
    # eObjectiveFunction     .. Z =e= TCosts;


#=
TODO: those LCA equations...
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
    @constraint(model, [t in 1:n_timesteps], powerG[t,:,:] .<= 1000 .* pG .+ pexistingG )


    #equation removed. Already in variable definition. Old version of it additionally doesnt make a lot of sense (see variable bounds of pG)
    # ePMinG(t,b,g)      .. powerG(t,b,g) =g= 0; //PMinG(g)*pG(b,g); Pmin deactivated


    # total ammount of generated power during the year
    # Calculated by adding total power generation of conventional, renewable, hydro and run-of-river power generation.
    @constraint(model, eGeneratedPower, TotalGeneratedPower == sum(powerG[t, b, g] for t in 1:data.n_timesteps, b in 1:data.n_buses, g in 1:data.n_conv_generators) + sum(powerR[t, b, r] for t in 1:data.n_timesteps, b in 1:data.n_buses, r in 1:data.n_ren_generators) + sum(powerH[t, h] for t in 1:data.n_timesteps, h in 1:data.n_hydro_generators) + sum(powerROR[t, ror] for t in 1:data.n_timesteps, ror in 1:data.n_ror_generators) )




eMinFossilGeneration           .. sum((t,b,g),powerG(t,b,g)) =g= MinFossilGeneration*TotalGeneratedPower;



eMaxFossilGeneration           .. sum((t,b,g),powerG(t,b,g)) =l= MaxFossilGeneration*TotalGeneratedPower;   //to not limit this, we can set it to 1
//Coal ramp costs: penalty on deviation from healthy plant factor(0.8)

#=

*Generators and renewables

//ePV2WindRatioMax               defines the ratio between wind and pv capacities
//ePV2WindRatioMin               defines the ratio between wind and pv capacities
ePowerR                        renewable generation
eEnergySpilled                 spilled energy as difference to available profile
eEnergySpilledMax              maximum allowed curtailed energy
eEqualInstallpR                makes sure all profiles of given technology are used equally in a given node

ePMaxG                         maximum power output
ePMinG                         minimum output power
eMinFossilGeneration           minimum generation (% energy) from fossils
eMaxFossilGeneration           maximum generation (% energy) from fossils

eGeneratedPower                total generated power (auxiliary counter)
eCSP                           heat generated by heliostat of CSP (MWthermal)
*Cascading hydropower
eVolumeH                       energy balance of s
eVolumeIniFinH                 final volume equals start volume
eVolLossH                      losses of stored energy

eVolumeIniH                    start volume
eVolumeFinH                    final volume

eVolMaxH                       max stored energy
eVolMinH                       min stored energy
ePMaxH                         max power output hydro
ePMinH                         min power output hydro
ePPumpMaxH                     max pumping capacity

eQDivertedMinH                 minimum diverted Q e.g. for ecological uses
eQDivertedUpstream             identifies diverted flows from upstream reservoirs
eQTurbinedUpstream             identifies turbined flows from upstream reservoirs
eQPumpedDownstream



eYieldWater2Power              conversion from water to power
eYieldWater2PowerPumped        conversion from water to power when pumping
eYieldWater2Reserve            conversion from water to reserve (estimate)

//eRampsAuxH                    sum ramps for penalty
//eRampsHup
//eRampsHdown
*RoR Hydropower
ePMaxRoR                       power generated by RoR

*Storage
ePConvMaxCT                    maximum conversion power of ct

eEnergy2PowerRatioMaxST1         maximum ratio between energy and converter
eEnergy2PowerRatioMinST1         minimum ratio between energy and converter
eEnergy2PowerRatioMaxST2         maximum ratio between energy and converter
eEnergy2PowerRatioMinST2         minimum ratio between energy and converter
eEnergy2PowerRatioMinCCS         minimum ratio between energy and converter of CCS

eVolumeSTall                   energy balance of all st
eVolumeIniFinS                 final volume equals start volume
eVolLossS                      losses of stored energy
eVolumeIniS                    start volume
eVolumeFinS                    final volume

eVolMaxST                       max stored energy
eVolMinST                       min stored energy
eVolMaxCCS                      max stored energy for CCS
eVolMinCCS                      min stored energy for CCS
//eRampsAuxS                     sum ramps for penalty
//eRampsAuxS_b                   sum ramps for penalty H2 only
//eVMaxSPotential                 maximum energy potential (e.g. reservoirs)
//ePMaxSPotential                 maximum power potential (e.g. heads of hydropower)
eCyclesST                      max no. of discharge cycles from storage
*Transmission
ePMaxL
eTMaxExp                       max. transmitted power
eTMaxImp                       max. transmitted power

eLineLosses                    losses of line l given the flow
eImportsB                      resulting power imports to bus b inc losses
eExportsB                      resulting power export to bus b inc losses


*Coal ramping
//epenaltyCoalplant             penalty factor for coal plants ramp up
eRampsAuxcoal_a                  sum hourly ramps for penalty for coal power
eRampsAuxcoal_b                  sum daily(12 hr) ramps for penalty for coal power
eRampsCoal1                     auxiliary equation for coal ramping1
eRampsCoal2                     auxiliary equation for coal ramping2
eRampsCoal3                     auxiliary equation for coal ramping3
eRampsCoal4                     auxiliary equation for coal ramping4
*System services
eEnergyBalanceB                energy balance at b


eReserveOperatingReq           system requirement for operating reserve
eReserveFrequencyReq           system requirement for frequency reserve

eReserveOperating              total provided operating reserve
eReserveFrequency              total provided frequency reserve

eReserveMaxH                   max provived reserve by H
//eReserveMaxS                   max provived reserve by ST
eReserveMaxCT                  max provived reserve by discharging to electricity CT
eReserveMaxG                   max provived reserve by G

eReserveMaxHEnergy             aux eq for water availability check in H
// eReserveMaxSTEnergy            aux eq for energy availability check in ST
eReserveMaxSEnergy            aux eq for energy availability check in ST corr to CT

eAutonomyBalance               energy to be stored at all times in ESS
eAutonomySAux1                 makes sure offered AutonomyST is below stored energy
eAutonomySAux2                 makes sure offered AutonomyST can be delivered
eAutonomyHAux1                 makes sure offered AutonomyH is above stored energy
eAutonomyHAux2                 makes sure offered AutonomyH can be delivered

*multiobjective equations

eOpTLCA                        total operation LCA
eConTLCA                       total construction LCA
eTLCA                          total LCA
eSubObj                        particular LCA impact to be minimized for pay-off table
eEpsilonTLCA                   upper bound for LCA impacts (epsilons)
;

=#


    return nothing
end
