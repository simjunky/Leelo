# TODO: rewrite docstring
# Variable creation
"""
docstring of this function

    ... right now just all variables independent of actual config...
"""
function add_model_variables(model::JuMP.Model, config::AbstrConfiguration, data::ModelData, i_current_year::Int64)

    # TODO: remove line when finished
    @info "add_model_variables() called"



    # TODO: find out units for all variables
    # TODO: create boundaries for most variables (e.g. many are >0)

    # POWER GENERATION

    # (t,b,g) power generated by conventional generator g during timestep t in bus b
    @variable(model, powerG[1:data.n_timesteps, 1:data.n_buses, 1:data.n_conv_generators] >= 0)

    # (t,h) power delivered by hydro power generator h during timestep t
    @variable(model, powerH[1:data.n_timesteps, 1:data.n_hydro_generators] >= 0)

    # WARNING: changed from powerPpump
    # (t,h) power consumed by hydro power plant h for pumping during timestep t
    @variable(model, powerHpump[1:data.n_timesteps, 1:data.n_hydro_generators] >= 0)

    # (t,ror) power delivered by river hydro power ror during timestep t
    @variable(model, powerRoR[1:data.n_timesteps, 1:data.n_ror_generators] >= 0)

    # (t,b,ct) power delivered or consumed by conversion technology ct in bus b during timestep t [MW (thermal)]
    @variable(model, powerCT[1:data.n_timesteps, 1:data.n_buses, 1:data.n_conversion_technologies] >= 0)

    # (t,b,r) power produced from renewables generator r in bus b during timestep t (equal to available profile)
    @variable(model, powerR[1:data.n_timesteps, 1:data.n_buses, 1:data.n_ren_generators] >= 0)

    # (t,b) power unserved in bus b during timestep t
    @variable(model, powerunserved[1:data.n_timesteps, 1:data.n_buses] >= 0)

    # (t,b) power spilled at bus b during timestep t
    @variable(model, powerspilled[1:data.n_timesteps, 1:data.n_buses] >= 0)

    # TODO: is this really needed? (only imported from GAMS)
    # total generated power (aux counter)
    @variable(model, TotalGeneratedPower)



    # POWER FLOWS

    # TODO: why are the following two variables not positive anymore?
    # (t,b) power imported to bus b
    @variable(model, powerBimp[1:data.n_timesteps, 1:data.n_buses])

    # (t,b) power exported from bus b
    @variable(model, powerBexp[1:data.n_timesteps, 1:data.n_buses])

    # (t,l) power flow on line l (positive ie from a to b)
    @variable(model, powerLpos[1:data.n_timesteps, 1:data.n_lines] >= 0)

    # (t,l) power flow on line l (negative ie from b to a)
    @variable(model, powerLneg[1:data.n_timesteps, 1:data.n_lines] >= 0)

    # (t,l) power losses on line l
    @variable(model, powerLlosses[1:data.n_timesteps, 1:data.n_lines] >= 0)



    # SERVICES

    #(t,b,st) autonomy offered by storage technology st
    @variable(model, autonomyST[1:data.n_timesteps, 1:data.n_buses, 1:data.n_storage_technologies] >= 0)

    #(t,h) autonomy offered by hydro power h's reserves
    @variable(model, autonomyH[1:data.n_timesteps, 1:data.n_hydro_generators] >= 0)

    # TODO: the Fuck does that even mean?
    #(t) required system reserves (operating) -considers demand\renewables\largest unit
    @variable(model, reserveOperatingReq[1:data.n_timesteps] >= 0)

    # TODO: the fuck does this even mean?
    #(t) required system reserves (frequency) -usually largest unit (if not included in Operating)
    @variable(model, reserveFrequencyReq[1:data.n_timesteps] >= 0)

    # (t,b,ct) offered frequency reserve by conversion tech ct in bus b during timestep t (not all tech's participate)
    @variable(model, reserveFrequencyCT[1:data.n_timesteps, 1:data.n_buses, 1:data.n_conversion_technologies] >= 0)

    # (t,h) offered frequency reserve by hydroreservoirs h during timestep t
    @variable(model, reserveFrequencyH[1:data.n_timesteps, 1:data.n_hydro_generators] >= 0)

    # (t,b,g) offered frequency reserve by conventional generator g in bus b during timestep t
    @variable(model, reserveFrequencyG[1:data.n_timesteps, 1:data.n_buses, 1:data.n_conv_generators] >= 0)

    # (t,b,ct) offered operating reserve by discharging conversion technology ct in bus b during timestep t (only conversions to electricity)
    @variable(model, reserveOperatingCT[1:data.n_timesteps, 1:data.n_buses, 1:data.n_conversion_technologies] >= 0)

    # (t,h) offered operating reserve by hydroreservoir h during timestep t
    @variable(model, reserveOperatingH[1:data.n_timesteps, 1:data.n_hydro_generators] >= 0)

    # (t,b,g) offered operating reserve by conventional generator g in bus b during timestep t
    @variable(model, reserveOperatingG[1:data.n_timesteps, 1:data.n_buses, 1:data.n_conv_generators] >= 0)



    # STORAGE

    # (t,b,st) energy stored by storage technology st in bus b during timestep t
    @variable(model, storedST[1:data.n_timesteps, 1:data.n_buses, 1:data.n_storage_technologies] >= 0)

    # TODO: is this really needed?
    # (b,st) initial energy storage of storage technology st in bus b during t=1
    @variable(model, vIniST[1:data.n_buses, 1:data.n_storage_technologies] >= 0)

    # TODO: is this really needed?
    # (b,st) final energy storage of storage technology st in bus b during t=end
    @variable(model, vFinST[1:data.n_buses, 1:data.n_storage_technologies] >= 0)

    # (t,b,st) energy losses of storage technology st in bus b during timestep t
    @variable(model, vLossST[1:data.n_timesteps, 1:data.n_buses, 1:data.n_storage_technologies] >= 0)



    # COAL RAMPING

    # (t,b) variables for coal ramping [MW]
    # These variables are used to calculate the absolute ammount of both hourly and daily coal ramping that is taking place to penalise it. Therefore ther is one variable for negative and one for positive ramping.
    @variable(model, rampsCoalHourlyPos[1:data.n_timesteps, 1:data.n_buses] >= 0)
    @variable(model, rampsCoalHourlyNeg[1:data.n_timesteps, 1:data.n_buses] >= 0)
    @variable(model, rampsCoalDailyPos[1:data.n_timesteps, 1:data.n_buses] >= 0)
    @variable(model, rampsCoalDailyNeg[1:data.n_timesteps, 1:data.n_buses] >= 0)



    # CASCADING HYDROPOWER

    # (t,h) flow to turbines of hydropower generator h during timestep t
    @variable(model, qturbined[1:data.n_timesteps, 1:data.n_hydro_generators] >= 0)

    # (t,h) flow of hydropower plant h to it's divertion during timestep t (non turbined flow e.g. eco flow for downstream uses)
    @variable(model, qdiverted[1:data.n_timesteps, 1:data.n_hydro_generators] >= 0)

    # (t,h) flow used in reserve provision of hydropower plant h during timestep t
    @variable(model, qreserve[1:data.n_timesteps, 1:data.n_hydro_generators] >= 0)

    # TODO: is this still needed?
    # (t,h) fictitious flow of hydropower plant h during timestep t for convergence and debug purposes
    @variable(model, qfictitious[1:data.n_timesteps, 1:data.n_hydro_generators] >= 0)

    # (t,h) pumped flow by hydropower plant h during timestep t
    @variable(model, qpumped[1:data.n_timesteps, 1:data.n_hydro_generators] >= 0)

    # (t,h) diverted flow of hydropower plant h during timestep t from upstream reservoirs
    @variable(model, qdivertedupstream[1:data.n_timesteps, 1:data.n_hydro_generators] >= 0)

    # (t,h) turbined flow from upstream reservoirs of hydropower plant h during timestep t
    @variable(model, qturbinedupstream[1:data.n_timesteps, 1:data.n_hydro_generators] >= 0)

    # (t,h) pumped flow from upstream reservoirs of hydropower plant h during timestep t
    @variable(model, qpumpeddownstream[1:data.n_timesteps, 1:data.n_hydro_generators] >= 0)

    # (t,h) energy storage by hydropower plant h during timestep t
    @variable(model, storedH[1:data.n_timesteps, 1:data.n_hydro_generators] >= 0)

    # TODO: are variables for initial and final values really needed?
    # (h) energy storage by hydropower plant h during timestep t=1
    @variable(model, vIniH[1:data.n_hydro_generators] >= 0)

    # TODO: are variables for initial and final values really needed?
    # (h) energy storage by by hydropower plant h during timestep t=end
    @variable(model, vFinH[1:data.n_hydro_generators] >= 0)

    # (t,h) energy losses by hydropower plant h during timestep t
    @variable(model, vLossH[1:data.n_timesteps, 1:data.n_hydro_generators] >= 0)



    # INVESTMENT

    # (b,r) built renewables in bus b in [GW]
    @variable(model, pR[1:data.n_buses, 1:data.n_ren_generators])
    # lower bound given by positivity condition and  minimal capacity adjusted from MW to GW
    set_lower_bound.(pR, max.(data.minCapacityPotR / 1000, 0.0))
    # upper bound given by not yet existing capacity (max - existing) adjusted from MW to GW
    set_upper_bound.(pR, (data.maxCapacityPotR - data.pexistingR[:, :, i_current_year]) / 1000)

    # (b,g) built generators in bus b in [GW]
    @variable(model, pG[1:data.n_buses, 1:data.n_conv_generators])
    # lower boundary: lower bound of a generator g given by pMinG[g] for every bus b adjusted from MW to GW
    set_lower_bound.(pG, repeat(transpose(max.(data.pMinG / 1000, 0.0)), data.n_buses, 1))
    # upper boundary: upper bound of a generator g given by pMaxG[g] for every bus b adjusted from MW to GW
    set_upper_bound.(pG, repeat(transpose(data.pMaxG / 1000), data.n_buses, 1))

    # (l) built capacity of transmission line l in [GW]
    @variable(model, pL[1:data.n_lines] >= 0)
    # TODO: this is addressed in the constraints routines. The reason is the dependency of capLExisting on the current year.
    # upper bound given by not yet realized capacity expansion (max - existing) adjusted from MW to GW
    #set_upper_bound.(pL, (data.maxCapacityPotL - data.capLExisting) / 1000)

    # (b,ct) built storage converters ct in bus b in [GW]
    @variable(model, pCT[1:data.n_buses, 1:data.n_conversion_technologies])
    # lower bound given by positivity condition and  minimal capacity adjusted from MW to GW
    set_lower_bound.(pCT, max.(data.minCapacityPotCT / 1000, 0.0))
    # upper bound given by not yet existing capacity (max - existing) adjusted from MW to GW
    set_upper_bound.(pCT, (data.maxCapacityPotCT - data.pexistingCT[:, :, i_current_year]) / 1000)

    # (b,st) built storage energy capacity st in bus b in [GW]
    @variable(model, eST[1:data.n_buses, 1:data.n_storage_technologies])
    # lower bound given by positivity condition and  minimal volume adjusted from MW to GW
    set_lower_bound.(eST, max.(data.minVolumePotST / 1000, 0.0))
    # upper bound given by not yet existing volume (max - existing) adjusted from MW to GW
    # TODO: check if the upper bound here is ok since vExistingST depends on curret year...
    set_upper_bound.(eST, (data.maxVolumePotST - data.vExistingST[:, :, i_current_year]) / 1000)

    # (h) new(added) capacity of hydropower plant h in [GW]
    @variable(model, pH[1:data.n_hydro_generators] >= 0)
    # upper bound given by not yet realized capacity expansion (max - existing) adjusted from MW to GW
    set_upper_bound.(pH, (data.pMaxH - data.pexistingH[:, i_current_year]) / 1000)



    # PARTS OF OBJECTIVE FUNCTION

    # TODO: check if Z is even needed
    # total objective function
    @variable(model, Z)

    # operational cost renewables (variable)
    @variable(model, OCr)

    # operational cost generators (variable)
    @variable(model, OCg)

    # operational cost storage
    @variable(model, OCs)

    # operational cost lines
    @variable(model, OCl)

    # operational cost others
    @variable(model, OCo)

    # operational costs fixed storage
    @variable(model, OCfs)

    # operational costs fixed others
    @variable(model, OCfo)

    # operational cost total
    @variable(model, OCt)

    # investment cost renewables
    @variable(model, ICr)

    # investment cost generators
    @variable(model, ICg)

    # investment cost storage
    @variable(model, ICs)

    # investment cost lines
    @variable(model, ICl)

    # investment cost others
    @variable(model, ICo)

    # investment cost total
    @variable(model, ICt)

    # investment cost added hydropower(turbines)
    @variable(model, ICh)

    # GHG from renewables (kg per MWh or tons per GWh)
    @variable(model, GHGr)

    # GHG from generators ror and hydropower
    @variable(model, GHGo)

    # GHG from storage tech
    @variable(model, GHGst)

    # GHG from conversion tech
    @variable(model, GHGct)

    # Total GHG of operation (taxable)(kg of CO2)
    @variable(model, GHGoperation)

    # total Greenhouse gases (kg of CO2)
    @variable(model, TGHG)

    # tax incurred from GHG emissions (euros)
    @variable(model, CostGHG)

    # total costs
    @variable(model, TCosts >= 0)

    # total transmission
    @variable(model, TTransmission >= 0)



    # MULTIOBJECTIVE WITH LCA

    # (ic) total operation LCA from all capacities
    @variable(model, OpTLCA[1:data.n_impact_categories])

    # (ic) total constrcution LCA from all new capacitites
    @variable(model, ConTLCA[1:data.n_impact_categories])

    # (ic) total LCA from operation and capacities
    @variable(model, TotalLCA[1:data.n_impact_categories])

    # current subobjective (needed for pay-off table calculation)
    @variable(model, Zx)

    return nothing
end
