
# TODO: nice docstring
"""
Blabla Docstring of ModelData struct...
"""
struct ModelData

    # General Variables

    # interest rate at which to borrow money [unitless]
    interest_rate::Float64
    # TODO: check if its accually Int:
    # duration of time step (hours)
    dt::Float64
    # amount of time steps
    nt::Int64
    # index for model to use
    modelType::String
    # index for current scenario
    scenario::String
    # numerical value of current year
    curyear::Int64
    # total demand [MWh]; GAMS: TotalDemand=sum((t,b),Demand(t,b))*dt
    TotalDemand::Float64
    # average demand [MW]; GAMS: AverageDemand=TotalDemand/nt
    AverageDemand::Float64
    # required hours of autonomy [h]; GAMS: AutonomyHours= (AutonomyDays*24)
    AutonomyHours::Float64
    # Average energy needed for autonomy requrements [MWh]; GAMS: Autonomy=AutonomyHours*AverageDemand
    Autonomy::Float64
    # fraction of a year which is simulated [unitless]; GAMS: FractionOfYear= dt*nt/8760
    FractionOfYear::Float64



    # Sets

    # Set containing conventional power plants names
    g_conventional_generator_names::Array{String, 1}
    # Set containing renewable power plants names
    r_renewable_generator_names::Array{String, 1}
    # Set containing conversion technologies names
    ct_conversion_technologies_names::Array{String, 1}
    # Set containing storage technologies names
    st_storage_technologies_names::Array{String, 1}
    # Set containing bus names
    b_busses_names::Array{String, 1}
    # Set containing transmission line names
    l_transmission_lines_names::Array{String, 1}
    # Set containing hourly timestep names
    t_hourly_timesteps_names::Array{String, 1}
    # Set containing conversion technologies names
    h_hydro_power_generators_names::Array{String, 1}
    # Set containing conversion technologies names
    ror_run_of_river_generators_names::Array{String, 1}
    # Set containing conversion technologies names
    ic_impact_categories_names::Array{String, 1}



    # Conventional generators

    # Capital cost of power plant installation [k Dollar per installed MW]
    costCapG::Array{Float64, 1}
    # TODO: should be k Dollar per produced MWh
    # Variable operational cost of running power plant [Dollar per produced MWh]
    costOperationVarG::Array{Float64, 1}
    # TODO: should be k Dollar per produced MWh
    # Fix operational cost of running power plant [Dollar per installed MW]
    costOperationFixG::Array{Float64, 1}
    # Cost of Reserves [Dollar per needed MWh]
    costReserveG::Array{Float64, 1}
    # Lifetime of the generator [year]
    lifetimeG::Array{Int64, 1}
    # Annuity; fracton ∈[0,1] of loan to be paid back every year repay capital cost within lifetime of generator [unitless]
    annuityG::Array{Float64, 1}
    # min bound: minimum capacity of to-be-installed conventional generation [MW]
    pMinG::Array{Float64, 1}
    # max bound: maximum capacity of to-be-installed conventional generation [MW]
    pMaxG::Array{Float64, 1}
    # fraction ∈[0,1] of minimal energy production coming from fossil generation [unitless]
    minFossilGeneration::Float64
    # fraction ∈[0,1] of maximal energy production coming from fossil generation [unitless]
    maxFossilGeneration::Float64
    # TODO: Remove euro/check if Excel was wrong
    # penalty for hourly ramping of coal [Euro per MW]
    costRampsCoal_hourly::Float64
    # TODO: Remove euro/check if Excel was wrong
    # penalty for daily ramping of coal [Euro per MW]
    costRampsCoal_daily::Float64
    # TODO: Remove euro/check if Excel was wrong
    # costs of wear and tear in coal power plants due to ramping [Euro per MW]
    costWTCoal::Float64
    # (b,g) busses b existing capacity of conventional generator g [MW]
    pexistingG::Array{Float64, 2}
    #pexistingG(b,g)       existing capacity of g (MW)



    # Renewable generators

    # (r) Capital cost of renewable power plant installation [k Dollar per installed MW]
    costCapR::Array{Float64, 1}
    # (r) Variable operational cost of running power plant [k Dollar per produced MWh]
    costOperationVarR::Array{Float64, 1}
    # (r) Fix operational cost of running renewable power plant [k Dollar per installed MW]
    costOperationFixR::Array{Float64, 1}
    # (r) Lifetime of the renewable generator [year]
    lifetimeR::Array{Int64, 1}
    # (r) Annuity; fracton ∈[0,1] of loan to be paid back every year repay capital cost within lifetime of renewable generator [unitless]
    annuityR::Array{Float64, 1}
    # (r) type of renewable generation ∈[Wind, SolarPV, RoR, Geothermal, Biomass, Biogas]
    technologyR::Array{String, 1}
    # (t,b,r) hourly (t) factor ∈[0,1] of generation profile of renewable generator r in bus b [unitless]
    profilesR::Array{Float64, 3}
    # (b,r) minimum capacity of renewable generators g to be installed in bus b [MW]
    minCapacityPotR::Array{Float64, 2}
    # (b,r) maximum capacity of renewable generators g to be installed in bus b [MW]
    maxCapacityPotR::Array{Float64, 2}
    # (b,r) existing power capacity of renewable generator r in bus b [MW]
    pexistingR::Array{Float64, 2}
    # (b,r) capacities of renewable generator g in bus b phased out from previous benchmark year to current year [MW]
    pRpho::Array{Float64, 2}



    # Conversion technologies

    # TODO: should be Dollars instead of Euros
    # (ct) Capital cost of conversion technology installation [k Euros per installed MW]
    costCapCT::Array{Float64, 1}
    # TODO: should be Dollars instead of Euros
    # (ct) Fix operational cost of conversion technology [k Euros per installed MW]
    costOperationFixCT::Array{Float64, 1}
    # TODO: GAMS Comment: operation cost of conversion per unit installed (k€\unit installed) => should be dependent on use as in adapted comment
    # TODO: should be Dollars instead of Euros
    # (ct) Variable operational cost of conversion technology [k Euro per converted MWh]
    costOperationConvCT::Array{Float64, 1}
    # (ct) Lifetime of the conversion technology [year]
    lifetimeCT::Array{Int64, 1}
    # (ct) Annuity; fracton ∈[0,1] of loan to be paid back every year repay capital cost within lifetime of conversion technology [unitless]
    annuityCT::Array{Float64, 1}
    # TODO: capacity, Power or energy reserves?  GAMS comment: cost of reserves ($\MW)or ($\MWh)
    # (ct) cost of conversion technology capacity reserves [Dollar per MW]
    costReserveCT::Array{Float64, 1}
    # (ct) energy conversion factor of conversion technology ct (equivalence of converted energy form to input energy form) [unitless]
    conversionFactorCT::Array{Float64, 1}
    #TODO: what is this exactly? GAMS dos not have comment on it
    # (ct) ??
    etaconv::Array{Float64, 1}
    # (b,ct) minimum capacity of conversion technology ct to be installed in bus b [MW]
    minCapacityPotCT::Array{Float64, 2}
    # (b,ct) minimum capacity of conversion technology ct to be installed in bus b [MW]
    maxCapacityPotCT::Array{Float64, 2}
    # (b,ct) existing power capacity of conversion technology ct in bus b [MW]
    pexistingCT::Array{Float64, 2}
    # (b,ct) capacities of conversion technology ct in bus b phased out from previous benchmark year to current year [MW]
    pCTpho::Array{Float64, 2}
    # (ct) Identifier for energy entity taken by ct
    vectorCT_O::Array{String, 1}
    # (ct) Identifier for energy entity delivered by ct
    vectorCT_D::Array{String, 1}
    # (t,b) CSP (Concentrated Solar Power) hourly (t) factor ∈[0,1] of generation profile in bus b [unitless]
    ProfilesCSP::Array{Float64, 2}



    # Storage technologies
    # TODO: many definitions use MWh... which would be ok for capacity of storage... recheck to unify.

    # (st) Capital cost of storage technology installation [k Dollar per installed MW]
    costCapST::Array{Float64, 1}
    # TODO: GAMS: fixed op cost of st per vol (€\MWh_ins); but shouldnt be singel EUros, EUROs nor INSTALLED MWh
    # (st) Variable operational cost of storage technology [k Dollar per stored MWh]
    # TODO: is stored the correct term above?
    costOperationVarST::Array{Float64, 1}
    # TODO: GAMS said: fixed op cost of st per vol (k€\MWh_ins); but it should neither be EUROs nor MWH!
    # (st) Fix operational cost of running storage technology [k Dollar per installed MW]
    costOperationFixST::Array{Float64, 1}
    # (st) Lifetime of the conversion technology [year]
    lifetimeST::Array{Int64, 1}
    # (st) Annuity; fracton ∈[0,1] of loan to be paid back every year repay capital cost within lifetime of storage technology [unitless]
    annuityST::Array{Float64, 1}
    # TODO: GAMS: (% of GWh_ins); but why Giga here when everything else is in MWh?? aso is it really in % or just factor??
    # (st) min storage level of storage technology st [% of installed GWh]
    vMinST::Array{Float64, 1}
    # TODO: are above and below really in % or just a factor?
    # (st) energy leakage;losses of storage technology st over time [% per 24h]
    lossesST::Array{Float64, 1}
    # (b,st) minimum capacity of storage technology st to be installed in bus b [MW]
    minVolumePotST::Array{Float64, 1}
    # (b,st) maximum capacity of storage technology st to be installed in bus b [MW]
    maxVolumePotST::Array{Float64, 1}
    # TODO: reformulate text
    # (st) maximum ratio between Energy and Power capacity [unitless]
    energy2PowerRatioMax::Array{Float64, 1}
    # TODO: reformulate text
    # (st) min ratio between Energy and Power capacity [unitless]
    energy2PowerRatioMin::Array{Float64, 1}
    # (st) maximum charge & discharge cycles of storage technology st during its lifetime [unitless]
    cyclesST::Array{Float64, 1}
    # TODO: was called pexistingCT for all other generators/conversion-tech
    # (b,st) existing storage capacity of storage technology st in bus b [MW]
    vExistingST::Array{Float64, 1}
    # (st) identifiers for energy entity stored in storage technology st
    storageEntityST::Array{String, 1}
    # (b,st) capacities of storage technology st in bus b phased out from previous benchmark year to current year [MW]
    eSTpho::Array{Float64, 1}



    # TODO: from here on down check units and comments!

    # Hydropower Generators (Cascades)

    # TODO: why Euros again?
    # (h) fixed operational costs of hydropower plant h [k€ per installed MW]
    costOperationFixH::Array{Float64, 1}
    # Cost of Reserves of hydropower plants
    costReserveH::Float64
    # (h) max power of h [MW]
    pMaxH::Array{Float64, 1}
    # (h)        min power of h [MW]
    pMinH::Array{Float64, 1}
    # (h)        max volume of reservoir [m^3]
    vMaxH::Array{Float64, 1}
    # (h)        min volume of reservoir [m^3]
    vMinH::Array{Float64, 1}
    # (h)           yield water to power (m3\s to MW)
    kH::Array{Float64, 1}
    # (h) bus to which h is connected
    # TODO: how can this info be stored best? number as index?? => check how it is done in GAMS.
    busH::Array{String, 1}
    # (h)  Investment cost of upgrading Hydropower(kEuros\MW)
    costCapUpgradeH::Array{Float64, 1}
    # (h)             existing capacities of h(MW)
    pexistingH::Array{Float64, 1}
    # TODO: how can the following three references be modeled??
    # (h) what h is downstream of current hh (via turbines)
    turbinedGoesTo::Array{String, 1}
    # (h) what h is downstream of current hh (via divertion)
    divertedGoesTo::Array{String, 1}
    # (h) what h is downstream of current hh (via divertion)
    pumpedGoesTo::Array{String, 1}
    # (h)  minimum spilled or ecological flow of h
    qDivertedMinH::Array{Float64, 1}
    # (t,h)     inflows to h in time t
    qInflowH::Array{Float64, 2}
    # (h)        evaporation or infiltration losses factor
    lossesH::Array{Float64, 1}



    # Run-of-River Hydropower

    # (ror) fixed operational costs (k€\MW_ins)
    costOperationFixRoR::Array{Float64, 1}
    # (ror)       max installed capacity of ror (MW)
    pMaxRoR::Array{Float64, 1}
    # (t,ror) ror profile profil
    profilesRoR::Array{Float64, 2}
    # (ror)        bus of ror
    busRoR::Array{String, 1}



    # Transmission

    # (l)    maximum available line capacity to be installed
    maxCapacityPotL::Array{Float64, 1}
    # (l)               (origen) bus from which line l starts
    barO::Array{String, 1}
    # (l)               (destination) bus to which lines l goes
    barD::Array{String, 1}
    # (l)            losses of line l (%\MW)
    lossesL::Array{Float64, 1}
    # (l)          existing line capacity
    capLExisting::Array{Float64, 1}
    # (l)           capital cost of line l (k€\MW)
    costCapL::Array{Float64, 1}
    # (l)  fixed operating costs of line l (k€\MW)
    costOperationFixL::Array{Float64, 1}
    # (l)  variable operating costs of line l (€\MW)
    costOperationVarL::Array{Float64, 1}
    # (l) Lifetime of the transmission line [years]
    lifetimeL::Array{Int64, 1}
    # (l)           annuity of line l
    annuityL::Array{Float64, 1}



    # System Services

    # (t,b)     demand in bus b
    demand::Array{Float64, 2}
    # days of energy autonomy (d)
    autonomyDays::Float64
    # benefit for leaving Energy reserves (negative cost) per MWh or inst capacity
    costAutonomy::Float64
    # maximum energy allowed to be curtailed in fraction of power
    energyCurtailedMax::Float64
    # reserve for energy load
    reserveDemand::Float64
    # reserve for renewable generation
    reserveRenewables::Float64
    # TODO: wtf do both following do and why are there two?
    # reserve for largest power plant
    reserveLargestUnit::Float64
    # reserve for largest power plant (if not included above)
    reserveFast::Float64
    # ratio between offered and used freq reserve (impact on volume balance)
    reserveFUsedRatio::Float64
    # ratio between offered and used operational reserve (impact on volume balance)
    reserveOUsedRatio::Float64
    # (b)         max demand in each zone throughout entire time period
    peakLoad::Array{Float64, 1}



    # Objective function

    # penalty of unserved energy
    costUnserved::Float64
    # penalty of spilled energy
    costSpilled::Float64
    # penalty for fictitious flows
    costFictitiousFlows::Float64
    # annual installment of built capacitites
    runningCosts::Float64
    # weight of the transmission part of the objective function
    epsilonTransmission::Float64
    # limit on GHG
    epsilonGHG::Float64
    # tax for GHG (euros per ton of CO2)
    carbonTax::Float64
    # (r)     GHG emissions factor during construction of r(kg.CO2 per MWh)
    GHGupstreamR::Array{Float64, 1}
    # (r)     GHG emissions factor during demolition of r (kg.CO2 per MWh)
    GHGdownstreamR::Array{Float64, 1}
    # (r)     GHG emissions factor per unit power generated by r(kg.CO2 per MWh)
    GHGOperationR::Array{Float64, 1}
    # (ror)     GHG emissions per unit power generated by ror(kg.CO2 per MWh)
    GHGOperationRoR::Array{Float64, 1}
    # (h)     GHG emissions per unit power generated by h(kg.CO2 per MWh)
    GHGOperationH::Array{Float64, 1}
    # so far zero, since we do not build any ror, h or g
    #GHGupstreamH(h)           GHG emissions per installed capacity of h(kg.CO2 per MWh)
    #GHGupstreamRoR(ror)       GHG emissions per unit power generated by ror(kg.CO2 per MWh)
    #GHGupstreamG(g)           GHG emissions per installed capacity of g (kg.CO2 per MWh)
    #GHGdownstreamG(g)     GHG emissions for demolition g(kg.CO2 per MWh) : we don't have data for this
    # (g)      GHG emissions per unit power generated by g(kg.CO2 per MWh)
    GHGOperationG::Array{Float64, 1}
    # (ct)  GHG emissions per unit operation of ct (kg.CO2 per MWh)
    GHGOperationCT::Array{Float64, 1}
    # (ct)  GHG emissions in construction of CT (kg.CO2 per MWh)
    GHGupstreamCT::Array{Float64, 1}
    # (ct)  GHG emissions in demolition of CT (kg.CO2 per MWh)
    GHGdownstreamCT::Array{Float64, 1}
    # (st)    GHG emissions in construction of ST (kg.CO2 per MWh)
    GHGupstreamST::Array{Float64, 1}
    # (st)  GHG emissions in demolition of ST (kg.CO2 per MWh)
    GHGdownstreamST::Array{Float64, 1}
    # (st)   GHG emissions per unit operation by st (kg.CO2 per MWh)
    GHGOperationST::Array{Float64, 1}



    # LCA: LifeCicle Assessment

    # (r,ic)          operation LCA impacts for renewables (per MWh)
    LCAopR::Array{Float64, 2}
    # (r,ic)         construction LCa impacts for renewables(per MW)
    LCAconR::Array{Float64, 2}
    # (ct,ic)        operation LCA impacts for conversion techs(per MWh)
    LCAopCT::Array{Float64, 2}
    # (ct,ic)       construction LCA impacts for conversion techs(per MW)
    LCAconCT::Array{Float64, 2}
    # (st,ic)        operation LCA impacts for storage techs (per MWh)
    LCAopST::Array{Float64, 2}
    # (st,ic)       construction LCA impacts for storage techs (per MWh)
    LCAconST::Array{Float64, 2}
    # (g,ic)          operation LCA impacts for conventional gen techs(per MWh)
    LCAopG::Array{Float64, 2}
    # (g,ic)         construction LCA impacts for conventional gen techs (per MW)
    LCAconG::Array{Float64, 2}
    # (ic)            operation LCA impacts for Hydropower cascades (per MWh)
    LCAopH::Array{Float64, 1}
    # (ic)           construction LCA impacts for Hydropower cascades(per MW)
    LCAconH::Array{Float64, 1}
    # (ic)          operation LCA impacts for Run-of-River plants(per MWh)
    LCAopRoR::Array{Float64, 1}
    # (ic)            operation LCA impacts for transmission (per MWh)
    LCAopL::Array{Float64, 1}
    # (l,ic)         construction LCA impacts for transmission (per MW)
    LCAconL::Array{Float64, 2}
    # (ic)        upper bound epsilons for all LCA impact categories
    EpsilonLCA::Array{Float64, 1}
    # (ic)        vector of ranking of subobjectives from IC's
    VectorSObj::Array{Float64, 1}
    #  count of objective: 0= mainobj other subobjectives
    Objcount::String


    function ModelData(;interest_rate::Float64 = 0,
                        dt::Float64 = 0,
                        nt::Int64 = 0,
                        modelType::String = "0",
                        scenario::String = "0",
                        curyear::Int64 = 0,
                        g_conventional_generator_names::Array{String, 1} = ["0"],
                        r_renewable_generator_names::Array{String, 1} = ["0"],
                        ct_conversion_technologies_names::Array{String, 1} = ["0"],
                        st_storage_technologies_names::Array{String, 1} = ["0"],
                        b_busses_names::Array{String, 1} = ["0"],
                        l_transmission_lines_names::Array{String, 1} = ["0"],
                        t_hourly_timesteps_names::Array{String, 1} = ["0"],
                        h_hydro_power_generators_names::Array{String, 1} = ["0"],
                        ror_run_of_river_generators_names::Array{String, 1} = ["0"],
                        ic_impact_categories_names::Array{String, 1} = ["0"],
                        costCapG::Array{Float64, 1} = [0],
                        costOperationVarG::Array{Float64, 1} = [0],
                        costOperationFixG::Array{Float64, 1} = [0],
                        costReserveG::Array{Float64, 1} = [0],
                        lifetimeG::Array{Int64, 1} = [0],
                        annuityG::Array{Float64, 1} = [0],
                        pMinG::Array{Float64, 1} = [0],
                        pMaxG::Array{Float64, 1} = [0],
                        minFossilGeneration::Float64 = 0,
                        maxFossilGeneration::Float64 = 0,
                        costRampsCoal_hourly::Float64 = 0,
                        costRampsCoal_daily::Float64 = 0,
                        costWTCoal::Float64 = 0,
                        pexistingG::Array{Float64, 2} = [0 0; 0 0],
                        costCapR::Array{Float64, 1} = [0],
                        costOperationVarR::Array{Float64, 1} = [0],
                        costOperationFixR::Array{Float64, 1} = [0],
                        lifetimeR::Array{Int64, 1} = [0],
                        annuityR::Array{Float64, 1} = [0],
                        technologyR::Array{String, 1} = ["0"],
                        profilesR::Array{Float64, 3} = zeros(Float64, (1,1,1)),
                        minCapacityPotR::Array{Float64, 2} = [0 0; 0 0],
                        maxCapacityPotR::Array{Float64, 2} = [0 0; 0 0],
                        pexistingR::Array{Float64, 2} = [0 0; 0 0],
                        pRpho::Array{Float64, 2} = [0 0; 0 0],
                        costCapCT::Array{Float64, 1} = [0],
                        costOperationFixCT::Array{Float64, 1} = [0],
                        costOperationConvCT::Array{Float64, 1} = [0],
                        lifetimeCT::Array{Int64, 1} = [0],
                        annuityCT::Array{Float64, 1} = [0],
                        costReserveCT::Array{Float64, 1} = [0],
                        conversionFactorCT::Array{Float64, 1} = [0],
                        etaconv::Array{Float64, 1} = [0],
                        minCapacityPotCT::Array{Float64, 2} = [0 0; 0 0],
                        maxCapacityPotCT::Array{Float64, 2} = [0 0; 0 0],
                        pexistingCT::Array{Float64, 2} = [0 0; 0 0],
                        pCTpho::Array{Float64, 2} = [0 0; 0 0],
                        vectorCT_O::Array{String, 1} = ["0"],
                        vectorCT_D::Array{String, 1} = ["0"],
                        ProfilesCSP::Array{Float64, 2} = [0 0; 0 0],
                        costCapST::Array{Float64, 1} = [0],
                        costOperationVarST::Array{Float64, 1} = [0],
                        costOperationFixST::Array{Float64, 1} = [0],
                        lifetimeST::Array{Int64, 1} = [0],
                        annuityST::Array{Float64, 1} = [0],
                        vMinST::Array{Float64, 1} = [0],
                        lossesST::Array{Float64, 1} = [0],
                        minVolumePotST::Array{Float64, 1} = [0],
                        maxVolumePotST::Array{Float64, 1} = [0],
                        energy2PowerRatioMax::Array{Float64, 1} = [0],
                        energy2PowerRatioMin::Array{Float64, 1} = [0],
                        cyclesST::Array{Float64, 1} = [0],
                        vExistingST::Array{Float64, 1} = [0],
                        storageEntityST::Array{String, 1} = ["0"],
                        eSTpho::Array{Float64, 1} = [0],
                        costOperationFixH::Array{Float64, 1} = [0],
                        costReserveH::Float64 = 0,
                        pMaxH::Array{Float64, 1} = [0],
                        pMinH::Array{Float64, 1} = [0],
                        vMaxH::Array{Float64, 1} = [0],
                        vMinH::Array{Float64, 1} = [0],
                        kH::Array{Float64, 1} = [0],
                        busH::Array{String, 1} = ["0"],
                        costCapUpgradeH::Array{Float64, 1} = [0],
                        pexistingH::Array{Float64, 1} = [0],
                        turbinedGoesTo::Array{String, 1} = ["0"],
                        divertedGoesTo::Array{String, 1} = ["0"],
                        pumpedGoesTo::Array{String, 1} = ["0"],
                        qDivertedMinH::Array{Float64, 1} = [0],
                        qInflowH::Array{Float64, 2} = [0 0; 0 0],
                        lossesH::Array{Float64, 1} = [0],
                        costOperationFixRoR::Array{Float64, 1} = [0],
                        pMaxRoR::Array{Float64, 1} = [0],
                        profilesRoR::Array{Float64, 2} = [0 0; 0 0],
                        busRoR::Array{String, 1} = ["0"],
                        maxCapacityPotL::Array{Float64, 1} = [0],
                        barO::Array{String, 1} = ["0"],
                        barD::Array{String, 1} = ["0"],
                        lossesL::Array{Float64, 1} = [0],
                        capLExisting::Array{Float64, 1} = [0],
                        costCapL::Array{Float64, 1} = [0],
                        costOperationFixL::Array{Float64, 1} = [0],
                        costOperationVarL::Array{Float64, 1} = [0],
                        lifetimeL::Array{Int64, 1} = [0],
                        annuityL::Array{Float64, 1} = [0],
                        demand::Array{Float64, 2} = [0 0; 0 0],
                        autonomyDays::Float64 = 0,
                        costAutonomy::Float64 = 0,
                        energyCurtailedMax::Float64 = 0,
                        reserveDemand::Float64 = 0,
                        reserveRenewables::Float64 = 0,
                        reserveLargestUnit::Float64 = 0,
                        reserveFast::Float64 = 0,
                        reserveFUsedRatio::Float64 = 0,
                        reserveOUsedRatio::Float64 = 0,
                        peakLoad::Array{Float64, 1} = [0],
                        costUnserved::Float64 = 0,
                        costSpilled::Float64 = 0,
                        costFictitiousFlows::Float64 = 0,
                        runningCosts::Float64 = 0,
                        epsilonTransmission::Float64 = 0,
                        epsilonGHG::Float64 = 0,
                        carbonTax::Float64 = 0,
                        GHGupstreamR::Array{Float64, 1} = [0],
                        GHGdownstreamR::Array{Float64, 1} = [0],
                        GHGOperationR::Array{Float64, 1} = [0],
                        GHGOperationRoR::Array{Float64, 1} = [0],
                        GHGOperationH::Array{Float64, 1} = [0],
                        GHGOperationG::Array{Float64, 1} = [0],
                        GHGOperationCT::Array{Float64, 1} = [0],
                        GHGupstreamCT::Array{Float64, 1} = [0],
                        GHGdownstreamCT::Array{Float64, 1} = [0],
                        GHGupstreamST::Array{Float64, 1} = [0],
                        GHGdownstreamST::Array{Float64, 1} = [0],
                        GHGOperationST::Array{Float64, 1} = [0],
                        LCAopR::Array{Float64, 2} = [0 0; 0 0],
                        LCAconR::Array{Float64, 2} = [0 0; 0 0],
                        LCAopCT::Array{Float64, 2} = [0 0; 0 0],
                        LCAconCT::Array{Float64, 2} = [0 0; 0 0],
                        LCAopST::Array{Float64, 2} = [0 0; 0 0],
                        LCAconST::Array{Float64, 2} = [0 0; 0 0],
                        LCAopG::Array{Float64, 2} = [0 0; 0 0],
                        LCAconG::Array{Float64, 2} = [0 0; 0 0],
                        LCAopH::Array{Float64, 1} = [0],
                        LCAconH::Array{Float64, 1} = [0],
                        LCAopRoR::Array{Float64, 1} = [0],
                        LCAopL::Array{Float64, 1} = [0],
                        LCAconL::Array{Float64, 2} = [0 0; 0 0],
                        EpsilonLCA::Array{Float64, 1} = [0],
                        VectorSObj::Array{Float64, 1} = [0],
                        Objcount::String = "0"
                        )

        tot_dem = sum(demand) * dt
        av_dem = tot_dem / nt
        aut_h = autonomyDays * 24

        return new( interest_rate,
                    dt,
                    nt,
                    modelType,
                    scenario,
                    curyear,
                    tot_dem,
                    av_dem,
                    aut_h,
                    aut_h * av_dem,
                    dt * nt / 8760,
                    g_conventional_generator_names,
                    r_renewable_generator_names,
                    ct_conversion_technologies_names,
                    st_storage_technologies_names,
                    b_busses_names,
                    l_transmission_lines_names,
                    t_hourly_timesteps_names,
                    h_hydro_power_generators_names,
                    ror_run_of_river_generators_names,
                    ic_impact_categories_names,
                    costCapG,
                    costOperationVarG,
                    costOperationFixG,
                    costReserveG,
                    lifetimeG,
                    annuityG,
                    pMinG,
                    pMaxG,
                    minFossilGeneration,
                    maxFossilGeneration,
                    costRampsCoal_hourly,
                    costRampsCoal_daily,
                    costWTCoal,
                    pexistingG,
                    costCapR,
                    costOperationVarR,
                    costOperationFixR,
                    lifetimeR,
                    annuityR,
                    technologyR,
                    profilesR,
                    minCapacityPotR,
                    maxCapacityPotR,
                    pexistingR,
                    pRpho,
                    costCapCT,
                    costOperationFixCT,
                    costOperationConvCT,
                    lifetimeCT,
                    annuityCT,
                    costReserveCT,
                    conversionFactorCT,
                    etaconv,
                    minCapacityPotCT,
                    maxCapacityPotCT,
                    pexistingCT,
                    pCTpho,
                    vectorCT_O,
                    vectorCT_D,
                    ProfilesCSP,
                    costCapST,
                    costOperationVarST,
                    costOperationFixST,
                    lifetimeST,
                    annuityST,
                    vMinST,
                    lossesST,
                    minVolumePotST,
                    maxVolumePotST,
                    energy2PowerRatioMax,
                    energy2PowerRatioMin,
                    cyclesST,
                    vExistingST,
                    storageEntityST,
                    eSTpho,
                    costOperationFixH,
                    costReserveH,
                    pMaxH,
                    pMinH,
                    vMaxH,
                    vMinH,
                    kH,
                    busH,
                    costCapUpgradeH,
                    pexistingH,
                    turbinedGoesTo,
                    divertedGoesTo,
                    pumpedGoesTo,
                    qDivertedMinH,
                    qInflowH,
                    lossesH,
                    costOperationFixRoR,
                    pMaxRoR,
                    profilesRoR,
                    busRoR,
                    maxCapacityPotL,
                    barO,
                    barD,
                    lossesL,
                    capLExisting,
                    costCapL,
                    costOperationFixL,
                    costOperationVarL,
                    lifetimeL,
                    annuityL,
                    demand,
                    autonomyDays,
                    costAutonomy,
                    energyCurtailedMax,
                    reserveDemand,
                    reserveRenewables,
                    reserveLargestUnit,
                    reserveFast,
                    reserveFUsedRatio,
                    reserveOUsedRatio,
                    peakLoad,
                    costUnserved,
                    costSpilled,
                    costFictitiousFlows,
                    runningCosts,
                    epsilonTransmission,
                    epsilonGHG,
                    carbonTax,
                    GHGupstreamR,
                    GHGdownstreamR,
                    GHGOperationR,
                    GHGOperationRoR,
                    GHGOperationH,
                    GHGOperationG,
                    GHGOperationCT,
                    GHGupstreamCT,
                    GHGdownstreamCT,
                    GHGupstreamST,
                    GHGdownstreamST,
                    GHGOperationST,
                    LCAopR,
                    LCAconR,
                    LCAopCT,
                    LCAconCT,
                    LCAopST,
                    LCAconST,
                    LCAopG,
                    LCAconG,
                    LCAopH,
                    LCAconH,
                    LCAopRoR,
                    LCAopL,
                    LCAconL,
                    EpsilonLCA,
                    VectorSObj,
                    Objcount)
    end

end



# add custom printing to our struct:
function Base.show(io::IO, data::ModelData)
    # TODO: either remove this function or fill it with usefull output!
    println(io, "Model Data consisting of: Do something with params??")
end
