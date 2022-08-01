

# TODO: write better, more detailed DocString
"""
Read all input files and write all Data a new data structure.
"""
function read_model_data()::ModelData

    # path to folder with input files
    folder = "data/TestLocation/input_data/" # TODO: change into function argument

    @info "enter read_model_data()"

    # filename of file containing scenario setting parameters
    scenario_parameter_file = folder * "scenario_settings.xlsx"

    # create DataFrame containing data of conventional generators
    scenario_setting_data = DataFrame(XLSX.readtable(scenario_parameter_file, "Tabelle1", infer_eltypes = true)...)


    # filename of file containing parameters of conventional generators
    conv_generator_parameter_file = folder * "conventional_generators.xlsx"

    # create DataFrame containing data of conventional generators
    conv_generator_data = DataFrame(XLSX.readtable(conv_generator_parameter_file, "Tabelle1", infer_eltypes = true)...)
    #CSV.read(conv_generator_parameter_file, DataFrame; delim = ',', header = 3, types = Dict(:generator_name=>String, :Tech=>String))


    # filename of file containing parameters of renewable generators
    ren_generator_parameter_file = folder * "renewable_generators.xlsx"

    # create DataFrame containing data of renewable generators
    ren_generator_data = DataFrame(XLSX.readtable(ren_generator_parameter_file, "Tabelle1", infer_eltypes = true)...)
    #CSV.read(ren_generator_parameter_file, DataFrame; delim = ',', header = 3, types = Dict(:generator_name=>String, :tech=>String))


    # filename of file containing parameters of conversion technologies
    converter_parameter_file = folder * "conversion_technologies.xlsx"

    # create DataFrame containing data of conversion technologies
    converter_data = DataFrame(XLSX.readtable(converter_parameter_file, "Tabelle1", infer_eltypes = true)...)
    #CSV.read(converter_parameter_file, DataFrame; delim = ',', header = 4, types = Dict(:converter_name=>String, :CT=>String, :input=>String, :output=>String))


    # filename of file containing parameters of storage technologies
    storage_parameter_file = folder * "storage_technologies.xlsx"

    # create DataFrame containing data of conversion technologies
    storage_data = DataFrame(XLSX.readtable(storage_parameter_file, "Tabelle1", infer_eltypes = true)...)
    #CSV.read(storage_parameter_file, DataFrame; delim = ',', header = 3, types = Dict(:Storage_Technology=>String, :VectorST=>String, :Units_of_installed_capacity=>String))


    # filename of file containing parameters of transmission lines
    transmission_parameter_file = folder * "transmission_lines.xlsx"

    # create DataFrame containing data of transmission lines
    transmission_data = DataFrame(XLSX.readtable(transmission_parameter_file, "Tabelle1", infer_eltypes = true)...)
    #CSV.read(transmission_parameter_file, DataFrame; delim = ',', header = 2, types = Dict(:line_name=>String, :BarO=>String, :BarD=>String))


    # filename of file containing electricity demand profiles
    demand_profile_file = folder * "demand_profiles.xlsx"

    # create DataFrame containing demand profiles data
    demand_profile_data = DataFrame(XLSX.readtable(demand_profile_file, "Tabelle1", infer_eltypes = true)...)
    #CSV.read(demand_profile_file, DataFrame; delim = ',', header = 1, types = Dict(:timestep_name=>String))


    # filename of file containing data of hydropower cascades
    hydro_cascades_file = folder * "hydro_cascades.xlsx"

    # create DataFrame containing data of hydropower cascades
    hydro_cascades_data = DataFrame(XLSX.readtable(hydro_cascades_file, "Tabelle1", infer_eltypes = true)...)
    #CSV.read(hydro_cascades_file, DataFrame; delim = ',', header = 1, types = Dict(:BusH=>String, :Code=>String, :hydro_name=>String, :Type=>String, :TurbinedGoesTo=>String, :EcoflowGoesTo=>String, :PumpedGoesTo=>String))


    # filename of file containing data of run of river generators
    hydro_ROR_file = folder * "hydro_run_of_river.xlsx"

    # create DataFrame containing data of run of river generators
    hydro_ROR_data = DataFrame(XLSX.readtable(hydro_ROR_file, "Tabelle1", infer_eltypes = true)...)
    #CSV.read(hydro_ROR_file, DataFrame; delim = ',', header = 1, types = Dict(:ror_name=>String, :BusRoR=>String))

    # filename of file containing data of preexisting capacities
    existing_capacity_file = folder * "preexisting_capacities.xlsx"

    # create DataFrame containing data of existing capacities
    existing_capacity_data = DataFrame(XLSX.readtable(existing_capacity_file, "Tabelle1", infer_eltypes = true)...)

    # filename of file containing data of renewable generator profiles
    renewable_profiles_file = folder * "renewable_profiles.xlsx"

    # create DataFrame containing data of renewable power generator profiles
    renewable_profiles_data = DataFrame(XLSX.readtable(renewable_profiles_file, "Tabelle1", infer_eltypes = true)...)

    # filename of file containing data of csp profiles
    csp_profiles_file = folder * "CSP_profiles.xlsx"

    # create DataFrame containing data of csp profiles
    csp_profiles_data = DataFrame(XLSX.readtable(csp_profiles_file, "Tabelle1", infer_eltypes = true)...)



    #= TODO: read in the following data:
    hydro_run_of_river_profiles.xlsx
    =#



    @info "Showing Data Frames:"
    #@show describe(scenario_setting_data)
    #@show describe(conv_generator_data)
    #@show describe(ren_generator_data)
    #@show describe(converter_data)
    #@show describe(storage_data)
    #@show describe(transmission_data)
    #@show describe(demand_profile_data)
    #@show describe(hydro_cascades_data)
    #@show describe(hydro_ROR_data)
    #@show describe(existing_capacity_data)


    # read neccessairy indexes to assemble matrices
    n_years = scenario_setting_data[1, :n_years]
    starting_year = scenario_setting_data[1, :starting_year]
    year_timestep = scenario_setting_data[1, :year_timestep]
    years = collect(starting_year:year_timestep:(starting_year + (n_years - 1) * year_timestep))

    n_buses = scenario_setting_data[1, :n_buses]
    n_conv_generators = nrow(conv_generator_data)
    n_ren_generators = nrow(ren_generator_data)
    n_conversion_technologies = nrow(converter_data)
    n_storage_technologies = nrow(storage_data)



    my_interest_rate = scenario_setting_data[1, :interest_rate]
    my_lifetimeG = Matrix{Int64}(conv_generator_data[!, Symbol.("LifetimeGy" .* string.(years))])
    my_lifetimeR = Matrix{Int64}(ren_generator_data[!, Symbol.("LifetimeRy" .* string.(years))])
    my_lifetimeCT = Matrix{Int64}(converter_data[!, Symbol.("LifetimeCTy" .* string.(years))])
    my_lifetimeST = Matrix{Int64}(storage_data[!, Symbol.("LifetimeSTy" .* string.(years))])
    my_lifetimeL = transmission_data[!, :LifetimeL]
    my_pexistingG = zeros(Float64, (n_buses, n_conv_generators, n_years))
    my_pexistingR = zeros(Float64, (n_buses, n_ren_generators, n_years))
    my_pexistingCT = zeros(Float64, (n_buses, n_conversion_technologies, n_years))
    my_VexistingST = zeros(Float64, (n_buses, n_storage_technologies, n_years))
    my_demand = zeros(Float64, (scenario_setting_data[1, :n_timesteps], n_buses, n_years))
    my_profilesR = zeros(Float64, ((scenario_setting_data[1, :n_timesteps], n_buses, n_ren_generators)))

    for i in 1:n_buses
        my_pexistingG[i,:,:] = Array{Float64, 2}(existing_capacity_data[ (existing_capacity_data.bus_name .== "b" * string(i)) .& (existing_capacity_data.variable_name .== "PexistingG"), Symbol.("y" .* string.(years)) ])

        my_pexistingR[i,:,:] = Array{Float64, 2}(existing_capacity_data[ (existing_capacity_data.bus_name .== "b" * string(i)) .& (existing_capacity_data.variable_name .== "PexistingR"), Symbol.("y" .* string.(years)) ])

        my_pexistingCT[i,:,:] = Array{Float64, 2}(existing_capacity_data[ (existing_capacity_data.bus_name .== "b" * string(i)) .& (existing_capacity_data.variable_name .== "PexistingCT"), Symbol.("y" .* string.(years)) ])

        my_VexistingST[i,:,:] = Array{Float64, 2}(existing_capacity_data[ (existing_capacity_data.bus_name .== "b" * string(i)) .& (existing_capacity_data.variable_name .== "VexistingST"), Symbol.("y" .* string.(years)) ])

        my_demand[:, i, :] = Array{Float64, 2}(demand_profile_data[!, Symbol.("ElectricityDemandb" * string(i) * "y" .* string.(years)) ])

        my_profilesR[:, i, :] = Array{Float64, 2}(renewable_profiles_data[!, Symbol.("profilesRb" * string(i) * "r" .* string.(collect(1:n_ren_generators)) ) ])

    end

    #@show my_pexistingG # TODO: remove


    # TODO: keep replacing placeholder-zeros with real values

    model_data = ModelData(interest_rate =  my_interest_rate,
                        n_years = scenario_setting_data[1, :n_years],
                        years = collect(range(scenario_setting_data[1, :starting_year], length = scenario_setting_data[1, :n_years], step = scenario_setting_data[1, :year_timestep])),
                        dt = Float64(scenario_setting_data[1, :timestep_length]),
                        n_timesteps =  scenario_setting_data[1, :n_timesteps],
                        modelType =  scenario_setting_data[1, :model_type],
                        scenario = scenario_setting_data[1, :scenario_type],
                        curyear =  scenario_setting_data[1, :starting_year],
                        g_conventional_generator_names = conv_generator_data[!, :generator_name],
                        r_renewable_generator_names = ren_generator_data[!, :generator_name],
                        ct_conversion_technologies_names = converter_data[!, :technology_name],
                        st_storage_technologies_names = storage_data[!, :storage_technology],
                        b_busses_names = "b".*string.(collect(1:scenario_setting_data[1, :n_buses])),
                        l_transmission_lines_names = transmission_data[!, :line_name],
                        t_hourly_timesteps_names = "t".*string.(collect(1:scenario_setting_data[1, :n_timesteps])),
                        h_hydro_power_generators_names = hydro_cascades_data[!, :generator_name],
                        ror_run_of_river_generators_names = hydro_ROR_data[!, :ror_name],
                        ic_impact_categories_names = ["0"], # TODO
                        costCapG = Matrix{Float64}(conv_generator_data[!,Symbol.("CostCapGy".*string.(years))]),
                        costOperationVarG = Matrix{Float64}(conv_generator_data[!,Symbol.("CostOperationVarGy".*string.(years))]),
                        costOperationFixG = Matrix{Float64}(conv_generator_data[!,Symbol.("CostOperationFixGy".*string.(years))]),
                        costReserveG = [0.0], #TODO: remove since its excluded (also remove everywhere else then) conv_generator_data[!, :CostReserveG],
                        lifetimeG = my_lifetimeG,
                        annuityG = ((1 + my_interest_rate).^my_lifetimeG .* my_interest_rate)./((1 + my_interest_rate).^my_lifetimeG .- 1),
                        pMinG = conv_generator_data[!, :PMinG],
                        pMaxG = conv_generator_data[!, :PMaxG],
                        minFossilGeneration = scenario_setting_data[1, :MinFossilShare],
                        maxFossilGeneration = scenario_setting_data[1, :MaxFossilShare],
                        costRampsCoal_hourly = scenario_setting_data[1, :CoalRampingHourly],
                        costRampsCoal_daily = scenario_setting_data[1, :CoalRampingDaily],
                        costWTCoal =scenario_setting_data[1, :CoalRampingWearTear],
                        pexistingG = my_pexistingG,
                        costCapR = Matrix{Float64}(ren_generator_data[!,Symbol.("CostCapRy".*string.(years))]),
                        costOperationVarR = Matrix{Float64}(ren_generator_data[!,Symbol.("CostOperationVarRy".*string.(years))]),
                        costOperationFixR = Matrix{Float64}(ren_generator_data[!,Symbol.("CostOperationFixRy".*string.(years))]),
                        lifetimeR = my_lifetimeR,
                        annuityR = ((1 + my_interest_rate).^my_lifetimeR .* my_interest_rate)./((1 + my_interest_rate).^my_lifetimeR .- 1),
                        technologyR = ren_generator_data[!, :Tech],
                        profilesR = my_profilesR,
                        minCapacityPotR = copy(transpose(Matrix{Float64}(ren_generator_data[!, Symbol.("minCapacityPotRb" .* string.( collect(1:n_buses) ))]))),
                        maxCapacityPotR = copy(transpose(Matrix{Float64}(ren_generator_data[!, Symbol.("maxCapacityPotRb" .* string.( collect(1:n_buses) ))]))),
                        pexistingR = my_pexistingR,
                        pRpho = [0.0 0.0; 0.0 0.0], # TODO, or has it been excluded?
                        costCapCT = Matrix{Float64}(converter_data[!, Symbol.("CostCapCTy" .* string.(years))]),
                        costOperationFixCT = Matrix{Float64}(converter_data[!, Symbol.("CostOperationFixCTy" .* string.(years))]),
                        costOperationConvCT = Matrix{Float64}(converter_data[!, Symbol.("CostOperationConvCTy" .* string.(years))]),
                        lifetimeCT = my_lifetimeCT,
                        annuityCT = ((1 + my_interest_rate).^my_lifetimeCT .* my_interest_rate)./((1 + my_interest_rate).^my_lifetimeCT .- 1),
                        costReserveCT = converter_data[!, :CostReserveCT],
                        conversionFactorCT = Matrix{Float64}(converter_data[!, Symbol.("ConversionFactorCTy" .* string.(years))]),
                        conversionEfficiencyCT = Matrix{Float64}(converter_data[!, Symbol.("ConversionEfficiencyCTy" .* string.(years))]),
                        minCapacityPotCT = copy(transpose(Matrix{Float64}(converter_data[!, Symbol.("minCapacityPotCTb" .* string.(collect(1:n_buses)))]))),
                        maxCapacityPotCT = copy(transpose(Matrix{Float64}(converter_data[!, Symbol.("maxCapacityPotCTb" .* string.(collect(1:n_buses)))]))),
                        pexistingCT = my_pexistingCT,
                        pCTpho = [0.0 0.0; 0.0 0.0],  # TODO
                        vectorCT_O = converter_data[!, :inputCT],
                        vectorCT_D = converter_data[!, :outputCT],
                        ProfilesCSP = Matrix{Float64}(csp_profiles_data[!, Symbol.("profilesCSPb" .* string.(collect(1:n_buses)) )]),
                        costCapST = Matrix{Float64}(storage_data[!, Symbol.("CostCapSTy" .* string.(years))]),
                        costOperationVarST = Matrix{Float64}(storage_data[!, Symbol.("CostOperationVarSTy" .* string.(years))]),
                        costOperationFixST = Matrix{Float64}(storage_data[!, Symbol.("CostOperationFixSTy" .* string.(years))]),
                        lifetimeST = my_lifetimeST,
                        annuityST = ((1 + my_interest_rate).^my_lifetimeST .* my_interest_rate)./((1 + my_interest_rate).^my_lifetimeST .- 1),
                        vMinST = storage_data[!, :VMinST],
                        lossesST = storage_data[!, :LossesST],
                        minVolumePotST = copy(transpose(Matrix{Float64}(storage_data[!, Symbol.("minVolumePotSTb" .* string.(collect(1:n_buses)))]))),
                        maxVolumePotST = copy(transpose(Matrix{Float64}(storage_data[!, Symbol.("maxVolumePotSTb" .* string.(collect(1:n_buses)))]))),
                        energy2PowerRatioMax = storage_data[!, :Energy2PowerRatioMax],
                        energy2PowerRatioMin = storage_data[!, :Energy2PowerRatioMin],
                        cyclesST = storage_data[!, :CyclesST],
                        vExistingST = my_VexistingST,
                        storageEntityST = storage_data[!, :storage_entity],
                        eSTpho = [0.0], # TODO
                        costOperationFixH = hydro_cascades_data[!, :CostOperationFixH],
                        costReserveH = hydro_cascades_data[!, :CostReserveH],
                        pMaxH = hydro_cascades_data[!, :PMaxH],
                        pMinH = hydro_cascades_data[!, :PMinH],
                        vMaxH = hydro_cascades_data[!, :VMaxH],
                        vMinH = hydro_cascades_data[!, :VMinH],
                        kH = hydro_cascades_data[!, :kappaYieldH],
                        busH = hydro_cascades_data[!, :BusH],
                        costCapUpgradeH = hydro_cascades_data[!, :CostCapUpgradeH],
                        pexistingH = Matrix{Float64}(hydro_cascades_data[!, Symbol.("PexistingHy" .* string.(years))]),
                        turbinedGoesTo = hydro_cascades_data[!, :TurbinedGoesTo],
                        divertedGoesTo = hydro_cascades_data[!, :DivertedGoesTo],
                        pumpedGoesTo = hydro_cascades_data[!, :PumpedGoesTo],
                        qDivertedMinH = hydro_cascades_data[!, :QDivertedMinH],
                        qInflowH = [0.0 0.0; 0.0 0.0], # TODO
                        lossesH = hydro_cascades_data[!, :LossesH],
                        costOperationFixRoR = hydro_ROR_data[!, :CostOperationFixRoR],
                        pMaxRoR = hydro_ROR_data[!, :PMaxRoR],
                        profilesRoR = [0.0 0.0; 0.0 0.0], # TODO
                        busRoR = hydro_ROR_data[!, :BusRoR],
                        maxCapacityPotL = transmission_data[!, :MaxCapacityPotL],
                        barO = transmission_data[!, :BarOrigin],
                        barD = transmission_data[!, :BarDestination],
                        lossesL = (transmission_data[!, :Length] ./1000 .* transmission_data[!, :LossesLines] .+ transmission_data[!, :LossesConverters]), # TODO: this was still multiplied by zero in Madhuros Version... so for testing maybe do the same and the remove
                        capLExisting = Matrix{Float64}(transmission_data[!, Symbol.("CapLExistingy" .* string.(years))]),
                        costCapL = (transmission_data[!, :Length] .* transmission_data[!, :CapExLines] .+ transmission_data[!, :CapExConverters]),
                        costOperationFixL = (transmission_data[!, :Length] .* transmission_data[!, :OpExFixLines] .+ transmission_data[!, :OpExFixConverters]),
                        costOperationVarL = (transmission_data[!, :Length] .* transmission_data[!, :OpExVarLines] .+ transmission_data[!, :OpExVarConverters]),
                        lifetimeL = my_lifetimeL,
                        annuityL = ((1 + my_interest_rate).^my_lifetimeL .* my_interest_rate)./((1 + my_interest_rate).^my_lifetimeL .- 1),
                        demand = my_demand,
                        autonomyDays = Float64(scenario_setting_data[1, :AutonomyDays]),
                        costAutonomy = scenario_setting_data[1, :CostAutonomy],
                        energyCurtailedMax = scenario_setting_data[1, :EnergyCurtailedMax],
                        reserveDemand = Float64(scenario_setting_data[1, :ReserveDemand]),
                        reserveRenewables = Float64(scenario_setting_data[1, :ReserveRenewables]),
                        reserveLargestUnit = Float64(scenario_setting_data[1, :ReserveLargestUnit]),
                        reserveFast = Float64(scenario_setting_data[1, :ReserveFast]),
                        reserveFUsedRatio = Float64(scenario_setting_data[1, :ReserveFUsedRatio]),
                        reserveOUsedRatio = Float64(scenario_setting_data[1, :ReserveOUsedRatio]),
                        peakLoad = collect(maximum(my_demand[:, b, y]) for b in 1:n_buses, y in 1:n_years),
                        costUnserved = Float64(scenario_setting_data[1, :CostUnserved]),
                        costSpilled = Float64(scenario_setting_data[1, :CostSpilled]),
                        costFictitiousFlows = Float64(scenario_setting_data[1, :CostFictitiousFlow]),
                        runningCosts = Float64(scenario_setting_data[1, :RunningCosts]),
                        epsilonTransmission = Float64(scenario_setting_data[1, :EpsilonTransmission]),
                        epsilonGHG = Float64(scenario_setting_data[1, :EpsilonGHG]),
                        carbonTax = vec(Matrix{Float64}(scenario_setting_data[!, Symbol.("CarbonTaxy" .* string.(years))])),
                        GHGupstreamR = ren_generator_data[!, :GHGupstreamR],
                        GHGdownstreamR = ren_generator_data[!, :GHGdownstreamR],
                        GHGOperationR = ren_generator_data[!, :GHGOperationR],
                        GHGOperationRoR = hydro_ROR_data[!, :GHGOperationRoR],
                        GHGOperationH = hydro_cascades_data[!, :GHGOperationH],
                        GHGOperationG = conv_generator_data[!, :GHGOperationG],
                        GHGOperationCT = Matrix{Float64}(converter_data[!, Symbol.("GHGOperationCTy" .* string.(years))]),
                        GHGupstreamCT = converter_data[!, :GHGupstreamCT],
                        GHGdownstreamCT = converter_data[!, :GHGdownstreamCT],
                        GHGupstreamST = storage_data[!, :GHGupstreamST],
                        GHGdownstreamST = storage_data[!, :GHGdownstreamST],
                        GHGOperationST = storage_data[!, :GHGOperationST],
                        LCAopR = [0.0 0.0; 0.0 0.0], # TODO
                        LCAconR = [0.0 0.0; 0.0 0.0], # TODO
                        LCAopCT = [0.0 0.0; 0.0 0.0], # TODO
                        LCAconCT = [0.0 0.0; 0.0 0.0], # TODO
                        LCAopST = [0.0 0.0; 0.0 0.0], # TODO
                        LCAconST = [0.0 0.0; 0.0 0.0], # TODO
                        LCAopG = [0.0 0.0; 0.0 0.0], # TODO
                        LCAconG = [0.0 0.0; 0.0 0.0], # TODO
                        LCAopH = [0.0], # TODO
                        LCAconH = [0.0], # TODO
                        LCAopRoR = [0.0], # TODO
                        LCAopL = [0.0], # TODO
                        LCAconL = [0.0 0.0; 0.0 0.0], # TODO
                        EpsilonLCA = [0.0], # TODO
                        VectorSObj = [0.0], # TODO
                        Objcount = "0" # TODO
                        )

    return model_data

end
