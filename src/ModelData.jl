
# TODO: nice docstring
"""
    ModelData

The `ModelData` data structure contains all parameters needed by `Leelo`.

# Fields



**`interest_rate`** is the interest rate at which money can be borrowed. It is a scalar and unitless.

...

**`costCapG[g, y]`** is the capital cost of the conventional power plant g's installation in year y. *2-dimensional: [g, y] in [k Dollar per installed MW]*

or (g, y) Capital cost of power plant g's installation in year y [k Dollar per installed MW]
costCapG::Array{Float64, 2} ?

"""
struct ModelData

    # General Variables

    # interest rate at which to borrow money [unitless]
    interest_rate::Float64
    # number of years covered
    n_years::Int64
    # all years covered
    years::Array{Int64, 1}
    # TODO: check if its accually Int:
    # duration of time step (hours)
    dt::Float64
    # amount of time steps
    n_timesteps::Int64
    # index for model to use
    modelType::String
    # index for current scenario
    scenario::String
    # TODO: remove this:
    # numerical value of current year
    curyear::Int64
    # total demand [MWh]; GAMS: TotalDemand=sum((t,b),Demand(t,b))*dt
    TotalDemand::Float64
    # average demand [MW]; GAMS: AverageDemand=TotalDemand/n_timesteps
    AverageDemand::Float64
    # required hours of autonomy [h]; GAMS: AutonomyHours= (AutonomyDays*24)
    AutonomyHours::Float64
    # average energy needed for autonomy requrements [MWh]; GAMS: Autonomy=AutonomyHours*AverageDemand
    Autonomy::Float64
    # fraction of a year which is simulated [unitless]; GAMS: fractionOfYear= dt*n_timesteps/8760
    fractionOfYear::Float64



    # Size of the model

    # number of zones to be modeled, reffered to as busses [unitless]
    n_buses::Int64
    # number of different conventional generators (i.e. fossil-fuel-based) [unitless]
    n_conv_generators::Int64
    # number of different hydro power plants [unitless]
    n_hydro_generators::Int64
    # number of different hydro power plants running off of rivers [unitless]
    n_ror_generators::Int64
    # number of energy conversion technologies [unitless]
    n_conversion_technologies::Int64
    # number of different renewable power generators [unitless]
    n_ren_generators::Int64
    # number of transmission lines connecting the zones (busses) [unitless]
    n_lines::Int64
    # number of different energy storage technologies [unitless]
    n_storage_technologies::Int64
    # number of impact categories [unitless]
    n_impact_categories::Int64



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

    # (g, y) Capital cost of power plant g's installation in year y [k Dollar per installed MW]
    costCapG::Array{Float64, 2}
    # TODO: should be k Dollar per produced MWh?
    # (g, y) Variable operational cost of running power plant g in year y [Dollar per produced MWh]
    costOperationVarG::Array{Float64, 2}
    # TODO: should be k Dollar per produced MWh
    # (g, y) Fix operational cost of running power plant g in year y [Dollar per installed MW]
    costOperationFixG::Array{Float64, 2}
    # (g) Cost of Reserves for gernerator g [Dollar per needed MWh]
    costReserveG::Array{Float64, 1}
    # (g, y) Lifetime of the generator g built in year y [years]
    lifetimeG::Array{Int64, 2}
    # (g, y) Annuity; fracton ∈[0,1] of loan to be paid back every year repay capital cost of generator g within its lifetime [unitless]
    annuityG::Array{Float64, 2}
    # (g) min bound: minimum capacity of to-be-installed conventional generator g [MW]
    pMinG::Array{Float64, 1}
    # (g) max bound: maximum capacity of to-be-installed conventional generator g [MW]
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
    # (b, g, y) busses b existing capacity of conventional generator g in year y [MW]
    pexistingG::Array{Float64, 3}
    # (b, g, y) capacities of conventional generator g in bus b phased out from previous benchmark year (y-1) to current year y [MW]
    pGpho::Array{Float64, 3}



    # Renewable generators

    # (r, y) Capital cost of renewable power plant installation r in year y [k Dollar per installed MW]
    costCapR::Array{Float64, 2}
    # (r, y) Variable operational cost of running power plant r in year y [k Dollar per produced MWh]
    costOperationVarR::Array{Float64, 2}
    # (r, y) Fix operational cost of running renewable power plant r in year y [k Dollar per installed MW]
    costOperationFixR::Array{Float64, 2}
    # (r, y) Lifetime of the renewable generator r built in year y [year]
    lifetimeR::Array{Int64, 2}
    # (r, y) Annuity; fracton ∈[0,1] of loan to be paid back every year repay capital cost within lifetime of renewable generator [unitless]
    annuityR::Array{Float64, 2}
    # (r) type of renewable generation ∈[Wind, SolarPV, RoR, Geothermal, Biomass, Biogas]
    technologyR::Array{String, 1}
    # (t,b,r) hourly (t) factor ∈[0,1] of generation profile of renewable generator r in bus b [unitless]
    profilesR::Array{Float64, 3}
    # (b, r) minimum capacity of renewable generators g to be installed in bus b [MW]
    minCapacityPotR::Array{Float64, 2}
    # (b, r) maximum capacity of renewable generators g to be installed in bus b [MW]
    maxCapacityPotR::Array{Float64, 2}
    # (b, r, y) existing power capacity of renewable generator r in bus b in year y [MW]
    pexistingR::Array{Float64, 3}
    # (b, r, y) capacities of renewable generator r in bus b phased out from previous benchmark year (y-1) to current year y [MW]
    pRpho::Array{Float64, 3}



    # Conversion technologies

    # TODO: should be Dollars instead of Euros
    # (ct, y) Capital cost of conversion technology installation ct in year y [k Euros per installed MW]
    costCapCT::Array{Float64, 2}
    # TODO: should be Dollars instead of Euros
    # (ct, y) Fix operational cost of conversion technology ct inyear y [k Euros per installed MW]
    costOperationFixCT::Array{Float64, 2}
    # TODO: GAMS Comment: operation cost of conversion per unit installed (k€\unit installed) => should be dependent on use as in adapted comment
    # TODO: should be Dollars instead of Euros
    # (ct, y) Variable operational cost of conversion technology ct in year y [k Euro per converted MWh]
    costOperationConvCT::Array{Float64, 2}
    # (ct, y) Lifetime of the conversion technology ct built in year y [years]
    lifetimeCT::Array{Int64, 2}
    # (ct, y) Annuity; fracton ∈[0,1] of loan to be paid back every year repay capital cost within lifetime of conversion technology ct [unitless]
    annuityCT::Array{Float64, 2}
    # TODO: capacity, Power or energy reserves?  GAMS comment: cost of reserves ($\MW)or ($\MWh)
    # (ct) cost of conversion technology ct's capacity reserves [Dollar per MW]
    costReserveCT::Array{Float64, 1}
    # (ct, y) energy conversion factor of conversion technology ct in year y (equivalence of converted energy form to input energy form) [unitless]
    conversionFactorCT::Array{Float64, 2}
    #TODO: what is this exactly? GAMS dos not have comment on it
    # (ct, y) the conversion efficiency of the conversion technology ct for the year y [unitless] #TODO: remove this comment: used to be called etaconv
    conversionEfficiencyCT::Array{Float64, 2}
    # (b, ct) minimum capacity of conversion technology ct to be installed in bus b [MW]
    minCapacityPotCT::Array{Float64, 2}
    # (b,ct) minimum capacity of conversion technology ct to be installed in bus b [MW]
    maxCapacityPotCT::Array{Float64, 2}
    # (b, ct, y) existing power capacity of conversion technology ct in bus b [MW]
    pexistingCT::Array{Float64, 3}
    # (b, ct, y) capacities of conversion technology ct in bus b phased out from previous benchmark year to current year [MW]
    pCTpho::Array{Float64, 3}
    # (ct) Identifier for energy entity taken by ct
    vectorCT_O::Array{String, 1}
    # (ct) Identifier for energy entity delivered by ct
    vectorCT_D::Array{String, 1}
    # (t, b) CSP (Concentrated Solar Power) hourly (t) factor ∈[0,1] of generation profile in bus b [unitless]
    ProfilesCSP::Array{Float64, 2}



    # Storage technologies
    # TODO: many definitions use MWh... which would be ok for capacity of storage... recheck to unify.

    # (st, y) Capital cost of storage technology st's installation in year y [k Dollar per installed MW]
    costCapST::Array{Float64, 2}
    # TODO: GAMS: fixed op cost of st per vol (€\MWh_ins); but shouldnt be singel EUros, EUROs nor INSTALLED MWh
    # (st, y) Variable operational cost of storage technology st for year y [k Dollar per stored MWh]
    # TODO: is stored the correct term above?
    costOperationVarST::Array{Float64, 2}
    # TODO: GAMS said: fixed op cost of st per vol (k€\MWh_ins); but it should neither be EUROs nor MWH!
    # (st, y) Fix operational cost of running storage technology st in year y [k Dollar per installed MW]
    costOperationFixST::Array{Float64, 2}
    # (st, y) Lifetime of the conversion technology st built in year y [years]
    lifetimeST::Array{Int64, 2}
    # (st, y) Annuity; fracton ∈[0,1] of loan to be paid back every year repay capital cost within lifetime of storage technology [unitless]
    annuityST::Array{Float64, 2}
    # TODO: GAMS: (% of GWh_ins); but why Giga here when everything else is in MWh?? aso is it really in % or just factor??
    # (st) min storage level of storage technology st [% of installed GWh]
    vMinST::Array{Float64, 1}
    # TODO: are above and below really in % or just a factor?
    # (st) energy leakage;losses of storage technology st over time [% per 24h]
    lossesST::Array{Float64, 1}
    # (b, st) minimum capacity of storage technology st to be installed in bus b [MW]
    minVolumePotST::Array{Float64, 2}
    # (b, st) maximum capacity of storage technology st to be installed in bus b [MW]
    maxVolumePotST::Array{Float64, 2}
    # TODO: reformulate text
    # (st) maximum ratio between Energy and Power capacity [unitless]
    energy2PowerRatioMax::Array{Float64, 1}
    # TODO: reformulate text
    # (st) min ratio between Energy and Power capacity [unitless]
    energy2PowerRatioMin::Array{Float64, 1}
    # (st) maximum charge & discharge cycles of storage technology st during its lifetime [unitless]
    cyclesST::Array{Int64, 1}
    # TODO: was called pexistingCT for all other generators/conversion-tech
    # (b, st, y) existing storage capacity of storage technology st in bus b for year y [MW]
    vExistingST::Array{Float64, 3}
    # (st) identifiers for energy entity stored in storage technology st
    storageEntityST::Array{String, 1}
    # (b, st, y) capacities of storage technology st in bus b phased out from previous benchmark year (y-1) to current year y [MW]
    eSTpho::Array{Float64, 3}



    # TODO: from here on down check units and comments!

    # Hydropower Generators (Cascades)

    # TODO: why Euros again?
    # (h) fixed operational costs of hydropower plant h [k€ per installed MW]
    costOperationFixH::Array{Float64, 1}
    # (h) Cost of Reserves of hydropower plants
    costReserveH::Array{Float64, 1}
    # (h) max power of h [MW]
    pMaxH::Array{Float64, 1}
    # (h) min power of h [MW]
    pMinH::Array{Float64, 1}
    # (h) max volume of reservoir h [million m^3]
    vMaxH::Array{Float64, 1}
    # (h) min volume of reservoir h [million m^3]
    vMinH::Array{Float64, 1}
    # (h) yield water to power [MW per m3/h]
    kH::Array{Float64, 1}
    # (h) bus to which h is connected
    # TODO: how can this info be stored best? number as index?? => check how it is done in GAMS.
    busH::Array{Int64, 1}
    # (h)  Investment cost of upgrading Hydropower(kEuros\MW)
    costCapUpgradeH::Array{Float64, 1}
    # (h, y) existing capacities of hydropower cascade h in year y [MW]
    pexistingH::Array{Float64, 2}
    # TODO: how can the following three references be modeled??
    # (h) what h is downstream of current hh (via turbines)
    turbinedGoesTo::Array{String, 1}
    # (h) what h is downstream of current hh (via divertion)
    divertedGoesTo::Array{String, 1}
    # (h) what h is downstream of current hh (via divertion)
    pumpedGoesTo::Array{String, 1}
    # (h) minimum spilled or ecological flow of h
    qDivertedMinH::Array{Float64, 1}
    # (t, h) inflows to h in time t
    qInflowH::Array{Float64, 2}
    # (h) evaporation or infiltration losses factor
    lossesH::Array{Float64, 1}



    # Run-of-River Hydropower

    # (ror) fixed operational costs (k€\MW_ins)
    costOperationFixRoR::Array{Float64, 1}
    # (ror)       max installed capacity of ror (MW)
    pMaxRoR::Array{Float64, 1}
    # (t, ror) ror profiles for each bus
    profilesRoR::Array{Float64, 2}
    # (ror)        bus of ror
    busRoR::Array{Int64, 1}



    # Transmission

    # (l)    maximum available line capacity to be installed in MW
    maxCapacityPotL::Array{Float64, 1}
    # (l)               (origin) bus from which line l starts
    barO::Array{Int64, 1}
    # (l)               (destination) bus to which lines l goes
    barD::Array{Int64, 1}
    # (l)            losses of line l (%\MW)
    lossesL::Array{Float64, 1}
    # (l, y) existing line l's capacity in the year y [MW]
    capLExisting::Array{Float64, 2}
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

    # (t, b, y) the systems electricity demand in bus b for time t in year y [GigaW]
    demand::Array{Float64, 3}
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
    # (b, y)         max demand in each zone throughout entire time period
    peakLoad::Array{Float64, 2}



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
    # (y) tax for GHG (euros per ton of CO2)
    carbonTax::Array{Float64, 1}
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
    # (ct, y)  GHG emissions per unit operation of ct (kg.CO2 per MWh)
    GHGOperationCT::Array{Float64, 2}
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


    function ModelData(;interest_rate::Float64 = 0.0,
                        n_years::Int64 = 0,
                        years::Array{Int64, 1} = [0],
                        dt::Float64 = 0.0,
                        n_timesteps::Int64 = 0,
                        modelType::String = "0.0",
                        scenario::String = "0.0",
                        curyear::Int64 = 0,
                        g_conventional_generator_names::Array{String, 1} = ["0.0"],
                        r_renewable_generator_names::Array{String, 1} = ["0.0"],
                        ct_conversion_technologies_names::Array{String, 1} = ["0.0"],
                        st_storage_technologies_names::Array{String, 1} = ["0.0"],
                        b_busses_names::Array{String, 1} = ["0.0"],
                        l_transmission_lines_names::Array{String, 1} = ["0.0"],
                        t_hourly_timesteps_names::Array{String, 1} = ["0.0"],
                        h_hydro_power_generators_names::Array{String, 1} = ["0.0"],
                        ror_run_of_river_generators_names::Array{String, 1} = ["0.0"],
                        ic_impact_categories_names::Array{String, 1} = ["0.0"],
                        costCapG::Array{Float64, 2} = zeros(Float64, (1, 1)),
                        costOperationVarG::Array{Float64, 2} = zeros(Float64, (1, 1)),
                        costOperationFixG::Array{Float64, 2} = zeros(Float64, (1, 1)),
                        costReserveG::Array{Float64, 1} = [0.0],
                        lifetimeG::Array{Int64, 2} = zeros(Int64, (1, 1)),
                        annuityG::Array{Float64, 2} = [0.0 0.0; 0.0 0.0],
                        pMinG::Array{Float64, 1} = [0.0],
                        pMaxG::Array{Float64, 1} = [0.0],
                        minFossilGeneration::Float64 = 0.0,
                        maxFossilGeneration::Float64 = 0.0,
                        costRampsCoal_hourly::Float64 = 0.0,
                        costRampsCoal_daily::Float64 = 0.0,
                        costWTCoal::Float64 = 0.0,
                        pexistingG::Array{Float64, 3} = zeros(Float64, (1, 1, 1)),
                        pGpho::Array{Float64, 3} = zeros(Float64, (1, 1, 1)),
                        costCapR::Array{Float64, 2} = zeros(Float64, (1, 1)),
                        costOperationVarR::Array{Float64, 2} = zeros(Float64, (1, 1)),
                        costOperationFixR::Array{Float64, 2} = zeros(Float64, (1, 1)),
                        lifetimeR::Array{Int64, 2} = zeros(Int64, (1, 1)),
                        annuityR::Array{Float64, 2} = [0.0 0.0; 0.0 0.0],
                        technologyR::Array{String, 1} = ["0.0"],
                        profilesR::Array{Float64, 3} = zeros(Float64, (1,1,1)),
                        minCapacityPotR::Array{Float64, 2} = [0.0 0.0; 0.0 0.0],
                        maxCapacityPotR::Array{Float64, 2} = [0.0 0.0; 0.0 0.0],
                        pexistingR::Array{Float64, 3} = zeros(Float64, (1, 1, 1)),
                        pRpho::Array{Float64, 3} = zeros(Float64, (1, 1, 1)),
                        costCapCT::Array{Float64, 2} = zeros(Float64, (1, 1)),
                        costOperationFixCT::Array{Float64, 2} = zeros(Float64, (1, 1)),
                        costOperationConvCT::Array{Float64, 2} = zeros(Float64, (1, 1)),
                        lifetimeCT::Array{Int64, 2} = zeros(Int64, (1, 1)),
                        annuityCT::Array{Float64, 2} = [0.0 0.0; 0.0 0.0],
                        costReserveCT::Array{Float64, 1} = [0.0],
                        conversionFactorCT::Array{Float64, 2} = zeros(Float64, (1, 1)),
                        conversionEfficiencyCT::Array{Float64, 2} = zeros(Float64, (1, 1)),
                        minCapacityPotCT::Array{Float64, 2} = [0.0 0.0; 0.0 0.0],
                        maxCapacityPotCT::Array{Float64, 2} = [0.0 0.0; 0.0 0.0],
                        pexistingCT::Array{Float64, 3} = zeros(Float64, (1, 1, 1)),
                        pCTpho::Array{Float64, 3} = zeros(Float64, (1, 1, 1)),
                        vectorCT_O::Array{String, 1} = ["0.0"],
                        vectorCT_D::Array{String, 1} = ["0.0"],
                        ProfilesCSP::Array{Float64, 2} = [0.0 0.0; 0.0 0.0],
                        costCapST::Array{Float64, 2} = zeros(Float64, (1, 1)),
                        costOperationVarST::Array{Float64, 2} = zeros(Float64, (1, 1)),
                        costOperationFixST::Array{Float64, 2} = zeros(Float64, (1, 1)),
                        lifetimeST::Array{Int64, 2} = zeros(Int64, (1, 1)),
                        annuityST::Array{Float64, 2} = [0.0 0.0; 0.0 0.0],
                        vMinST::Array{Float64, 1} = [0.0],
                        lossesST::Array{Float64, 1} = [0.0],
                        minVolumePotST::Array{Float64, 2} = [0.0 0.0; 0.0 0.0],
                        maxVolumePotST::Array{Float64, 2} = [0.0 0.0; 0.0 0.0],
                        energy2PowerRatioMax::Array{Float64, 1} = [0.0],
                        energy2PowerRatioMin::Array{Float64, 1} = [0.0],
                        cyclesST::Array{Int64, 1} = [0.0],
                        vExistingST::Array{Float64, 3} = zeros(Int64, (1, 1, 1)),
                        storageEntityST::Array{String, 1} = ["0.0"],
                        eSTpho::Array{Float64, 3} = zeros(Float64, (1, 1, 1)),
                        costOperationFixH::Array{Float64, 1} = [0.0],
                        costReserveH::Array{Float64, 1} = [0.0],
                        pMaxH::Array{Float64, 1} = [0.0],
                        pMinH::Array{Float64, 1} = [0.0],
                        vMaxH::Array{Float64, 1} = [0.0],
                        vMinH::Array{Float64, 1} = [0.0],
                        kH::Array{Float64, 1} = [0.0],
                        busH::Array{Int64, 1} = [0],
                        costCapUpgradeH::Array{Float64, 1} = [0.0],
                        pexistingH::Array{Float64, 2} = zeros(Float64, (1, 1)),
                        turbinedGoesTo::Array{String, 1} = ["0.0"],
                        divertedGoesTo::Array{String, 1} = ["0.0"],
                        pumpedGoesTo::Array{String, 1} = ["0.0"],
                        qDivertedMinH::Array{Float64, 1} = [0.0],
                        qInflowH::Array{Float64, 2} = [0.0 0.0; 0.0 0.0],
                        lossesH::Array{Float64, 1} = [0.0],
                        costOperationFixRoR::Array{Float64, 1} = [0.0],
                        pMaxRoR::Array{Float64, 1} = [0.0],
                        profilesRoR::Array{Float64, 2} = [0.0 0.0; 0.0 0.0],
                        busRoR::Array{Int64, 1} = [0],
                        maxCapacityPotL::Array{Float64, 1} = [0.0],
                        barO::Array{Int64, 1} = ["0.0"],
                        barD::Array{Int64, 1} = ["0.0"],
                        lossesL::Array{Float64, 1} = [0.0],
                        capLExisting::Array{Float64, 2} = zeros(Float64, (1, 1)),
                        costCapL::Array{Float64, 1} = [0.0],
                        costOperationFixL::Array{Float64, 1} = [0.0],
                        costOperationVarL::Array{Float64, 1} = [0.0],
                        lifetimeL::Array{Int64, 1} = [0],
                        annuityL::Array{Float64, 1} = [0.0],
                        demand::Array{Float64, 3} = zeros(Float64, (1, 1, 1)),
                        autonomyDays::Float64 = 0.0,
                        costAutonomy::Float64 = 0.0,
                        energyCurtailedMax::Float64 = 0.0,
                        reserveDemand::Float64 = 0.0,
                        reserveRenewables::Float64 = 0.0,
                        reserveLargestUnit::Float64 = 0.0,
                        reserveFast::Float64 = 0.0,
                        reserveFUsedRatio::Float64 = 0.0,
                        reserveOUsedRatio::Float64 = 0.0,
                        peakLoad::Array{Float64, 2} = [0.0 0.0; 0.0 0.0],
                        costUnserved::Float64 = 0.0,
                        costSpilled::Float64 = 0.0,
                        costFictitiousFlows::Float64 = 0.0,
                        runningCosts::Float64 = 0.0,
                        epsilonTransmission::Float64 = 0.0,
                        epsilonGHG::Float64 = 0.0,
                        carbonTax::Array{Float64, 1} = [0.0],
                        GHGupstreamR::Array{Float64, 1} = [0.0],
                        GHGdownstreamR::Array{Float64, 1} = [0.0],
                        GHGOperationR::Array{Float64, 1} = [0.0],
                        GHGOperationRoR::Array{Float64, 1} = [0.0],
                        GHGOperationH::Array{Float64, 1} = [0.0],
                        GHGOperationG::Array{Float64, 1} = [0.0],
                        GHGOperationCT::Array{Float64, 2} = zeros(Float64, (1, 1)),
                        GHGupstreamCT::Array{Float64, 1} = [0.0],
                        GHGdownstreamCT::Array{Float64, 1} = [0.0],
                        GHGupstreamST::Array{Float64, 1} = [0.0],
                        GHGdownstreamST::Array{Float64, 1} = [0.0],
                        GHGOperationST::Array{Float64, 1} = [0.0],
                        LCAopR::Array{Float64, 2} = [0.0 0.0; 0.0 0.0],
                        LCAconR::Array{Float64, 2} = [0.0 0.0; 0.0 0.0],
                        LCAopCT::Array{Float64, 2} = [0.0 0.0; 0.0 0.0],
                        LCAconCT::Array{Float64, 2} = [0.0 0.0; 0.0 0.0],
                        LCAopST::Array{Float64, 2} = [0.0 0.0; 0.0 0.0],
                        LCAconST::Array{Float64, 2} = [0.0 0.0; 0.0 0.0],
                        LCAopG::Array{Float64, 2} = [0.0 0.0; 0.0 0.0],
                        LCAconG::Array{Float64, 2} = [0.0 0.0; 0.0 0.0],
                        LCAopH::Array{Float64, 1} = [0.0],
                        LCAconH::Array{Float64, 1} = [0.0],
                        LCAopRoR::Array{Float64, 1} = [0.0],
                        LCAopL::Array{Float64, 1} = [0.0],
                        LCAconL::Array{Float64, 2} = [0.0 0.0; 0.0 0.0],
                        EpsilonLCA::Array{Float64, 1} = [0.0],
                        VectorSObj::Array{Float64, 1} = [0.0],
                        Objcount::String = "0.0"
                        )


        tot_dem = sum(demand) * dt # TODO: this needs to be adapted to the current year
        av_dem = tot_dem / n_timesteps
        aut_h = autonomyDays * 24


        n_buses = length(b_busses_names)
        n_conv_generators = length(g_conventional_generator_names)
        n_hydro_generators = length(h_hydro_power_generators_names)
        n_ror_generators = length(ror_run_of_river_generators_names)
        n_conversion_technologies = length(ct_conversion_technologies_names)
        n_ren_generators = length(r_renewable_generator_names)
        n_lines = length(l_transmission_lines_names)
        n_storage_technologies = length(st_storage_technologies_names)
        n_impact_categories = length(ic_impact_categories_names)


        return new( interest_rate,
                    n_years,
                    years,
                    dt,
                    n_timesteps,
                    modelType,
                    scenario,
                    curyear,
                    tot_dem,
                    av_dem,
                    aut_h,
                    aut_h * av_dem,
                    dt * n_timesteps / 8760, length(b_busses_names), length(g_conventional_generator_names), length(h_hydro_power_generators_names), length(ror_run_of_river_generators_names), length(ct_conversion_technologies_names), length(r_renewable_generator_names), length(l_transmission_lines_names), length(st_storage_technologies_names), length(ic_impact_categories_names),
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
                    pGpho,
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
                    conversionEfficiencyCT,
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



"""
    Base.show(io::IO, data::ModelData)

This overloads `Base.show`. The `REPL` returns the output of `show` as a string. Thereby this function adds custom printing to the `ModelData` struct.
It provides a short overview of the covered years, nodes and number of different technologies.

# Arguments

**`io`** is the output stream to which the model summary is written.

**`data` is the data structure containing all the parameters of the model to be printed and is of the type `ModelData`.

"""
function Base.show(io::IO, data::ModelData)

    # provide a short overview over the model
    print(io,
    "Leelo.ModelData:\nModel covering the years:" * join( " " .* string.(data.years)) * " with " * string(data.n_timesteps) * " timesteps each\n" *
    "Model contains\n    " *
    string(data.n_buses) * " nodes\n    " *
    string(data.n_conv_generators) * " conventional generators\n    " *
    string(data.n_ren_generators) * " renewable generators\n    " *
    string(data.n_hydro_generators) * " hydro generators\n    " *
    string(data.n_ror_generators) * " run-of-river generators\n    " *
    string(data.n_conversion_technologies) * " conversion technologies\n    " *
    string(data.n_storage_technologies) * " storage technologies\n    " *
    string(data.n_lines) * " power lines")
end
