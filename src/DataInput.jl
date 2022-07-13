

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

    # create DataFrame containing data of run of river generators
    existing_capacity_data = DataFrame(XLSX.readtable(existing_capacity_file, "Tabelle1", infer_eltypes = true)...)



    #= TODO: read in the following data:
    renewable_profiles.xlsx
    hydro_run_of_river_profiles.xlsx
    =#



    @info "Showing Data Frames:"
    #@show describe(scenario_setting_data)
    #@show describe(conv_generator_data)
    #@show describe(ren_generator_data)
    #@show describe(converter_data)
    @show describe(storage_data)
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

    my_pexistingG = zeros(Float64, (n_buses, n_conv_generators, n_years))
    my_pexistingR = zeros(Float64, (n_buses, n_ren_generators, n_years))
    my_pexistingCT = zeros(Float64, (n_buses, n_conversion_technologies, n_years))
    my_VexistingST = zeros(Float64, (n_buses, n_storage_technologies, n_years))
    my_demand = zeros(Float64, (scenario_setting_data[1, :n_timesteps], n_buses, n_years))

    for i in 1:n_buses
        my_pexistingG[i,:,:] = Array{Float64, 2}(existing_capacity_data[ (existing_capacity_data.bus_name .== "b" * string(i)) .& (existing_capacity_data.variable_name .== "PexistingG"), Symbol.("y" .* string.(years)) ])

        my_pexistingR[i,:,:] = Array{Float64, 2}(existing_capacity_data[ (existing_capacity_data.bus_name .== "b" * string(i)) .& (existing_capacity_data.variable_name .== "PexistingR"), Symbol.("y" .* string.(years)) ])

        my_pexistingCT[i,:,:] = Array{Float64, 2}(existing_capacity_data[ (existing_capacity_data.bus_name .== "b" * string(i)) .& (existing_capacity_data.variable_name .== "PexistingCT"), Symbol.("y" .* string.(years)) ])

        my_VexistingST[i,:,:] = Array{Float64, 2}(existing_capacity_data[ (existing_capacity_data.bus_name .== "b" * string(i)) .& (existing_capacity_data.variable_name .== "VexistingST"), Symbol.("y" .* string.(years)) ])

        my_demand[:, i, :] = Array{Float64, 2}(demand_profile_data[!, Symbol.("ElectricityDemandb" * string(i) * "y" .* string.(years)) ])

    end

    @show my_pexistingG # TODO: remove


    # TODO: keep replacing placeholder-zeros with real values

    model_data = ModelData(interest_rate =  scenario_setting_data[1, :interest_rate],
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
                        lifetimeG = Matrix{Int64}(conv_generator_data[!,Symbol.("LifetimeGy".*string.(years))]),
                        annuityG = [0.0], #TODO: remove  conv_generator_data[!, :AnnuityG],
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
                        lifetimeR = Matrix{Int64}(ren_generator_data[!,Symbol.("LifetimeRy".*string.(years))]),
                        annuityR = [0.0], #TODO: remove and fill otherwise #old: ren_generator_data[!, :AnnuityR],
                        technologyR = ren_generator_data[!, :Tech],
                        profilesR = zeros(Float64, (1,1,1)), # TODO
                        minCapacityPotR = [0.0 0.0; 0.0 0.0], # TODO
                        maxCapacityPotR = [0.0 0.0; 0.0 0.0],  # TODO
                        pexistingR = my_pexistingR,
                        pRpho = [0.0 0.0; 0.0 0.0], # TODO, or has it been excluded?
                        costCapCT = Matrix{Float64}(converter_data[!, Symbol.("CostCapCTy" .* string.(years))]),
                        costOperationFixCT = Matrix{Float64}(converter_data[!, Symbol.("CostOperationFixCTy" .* string.(years))]),
                        costOperationConvCT = Matrix{Float64}(converter_data[!, Symbol.("CostOperationConvCTy" .* string.(years))]),
                        lifetimeCT = Matrix{Int64}(converter_data[!, Symbol.("LifetimeCTy" .* string.(years))]),
                        annuityCT = [0.0], #TODO replace/remove
                        costReserveCT = converter_data[!, :CostReserveCT],
                        conversionFactorCT = Matrix{Float64}(converter_data[!, Symbol.("ConversionFactorCTy" .* string.(years))]),
                        conversionEfficiencyCT = Matrix{Float64}(converter_data[!, Symbol.("ConversionEfficiencyCTy" .* string.(years))]),
                        minCapacityPotCT = [0.0 0.0; 0.0 0.0], # TODO
                        maxCapacityPotCT = [0.0 0.0; 0.0 0.0], # TODO
                        pexistingCT = my_pexistingCT,
                        pCTpho = [0.0 0.0; 0.0 0.0],  # TODO
                        vectorCT_O = converter_data[!, :inputCT],
                        vectorCT_D = converter_data[!, :outputCT],
                        ProfilesCSP = [0.0 0.0; 0.0 0.0], # TODO
                        costCapST = Matrix{Float64}(storage_data[!, Symbol.("CostCapSTy" .* string.(years))]),
                        costOperationVarST = Matrix{Float64}(storage_data[!, Symbol.("CostOperationVarSTy" .* string.(years))]),
                        costOperationFixST = Matrix{Float64}(storage_data[!, Symbol.("CostOperationFixSTy" .* string.(years))]),
                        lifetimeST = Matrix{Int64}(storage_data[!, Symbol.("LifetimeSTy" .* string.(years))]),
                        annuityST = [0.0], # TODO: replace/remove
                        vMinST = storage_data[!, :VMinST],
                        lossesST = storage_data[!, :LossesST],
                        minVolumePotST = [0.0], # TODO
                        maxVolumePotST = [0.0], # TODO
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
                        kH = [0.0], # TODO (is this EtaH ?)
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
                        lifetimeL = transmission_data[!, :LifetimeL],
                        annuityL = [0.0], # TODO: calculate from lifetime
                        demand = my_demand,
                        autonomyDays = Float64(scenario_setting_data[1, :AutonomyDays]),
                        costAutonomy = scenario_setting_data[1, :CostAutonomy],
                        energyCurtailedMax = scenario_setting_data[1, :EnergyCurtailedMax],
                        reserveDemand = 0.0, # TODO
                        reserveRenewables = 0.0, # TODO
                        reserveLargestUnit = 0.0, # TODO
                        reserveFast = 0.0, # TODO
                        reserveFUsedRatio = scenario_setting_data[1, :ReserveFUsedRatio],
                        reserveOUsedRatio = scenario_setting_data[1, :ReserveOUsedRatio],
                        peakLoad = [0.0], # TODO
                        costUnserved = 0.0, # TODO
                        costSpilled = 0.0, # TODO
                        costFictitiousFlows = 0.0, # TODO
                        runningCosts = 0.0, # TODO
                        epsilonTransmission = 0.0, # TODO
                        epsilonGHG = 0.0, # TODO
                        carbonTax = 0.0, # TODO
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
