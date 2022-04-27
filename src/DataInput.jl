

# TODO: write better, more detailed DocString
"""
Read all input files and write all Data a new data structure.
"""
function read_model_data()::ModelData

    # path to folder with input files
    folder = "data/TestLocation/input_data/"

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

    @info "did read conv gen data"

    # filename of file containing parameters of renewable generators
    ren_generator_parameter_file = folder * "renewable_generators.xlsx"

    # create DataFrame containing data of renewable generators
    ren_generator_data = DataFrame(XLSX.readtable(ren_generator_parameter_file, "Tabelle1", infer_eltypes = true)...)
    #CSV.read(ren_generator_parameter_file, DataFrame; delim = ',', header = 3, types = Dict(:generator_name=>String, :tech=>String))

    @info "did read ren gen data"

    # filename of file containing parameters of conversion technologies
    converter_parameter_file = folder * "conversion_technologies.xlsx"

    # create DataFrame containing data of conversion technologies
    converter_data = DataFrame(XLSX.readtable(converter_parameter_file, "Tabelle1", infer_eltypes = true)...)
    #CSV.read(converter_parameter_file, DataFrame; delim = ',', header = 4, types = Dict(:converter_name=>String, :CT=>String, :input=>String, :output=>String))

    @info "did read converter data"

    # filename of file containing parameters of storage technologies
    storage_parameter_file = folder * "storage_technologies.xlsx"

    # create DataFrame containing data of conversion technologies
    storage_data = DataFrame(XLSX.readtable(storage_parameter_file, "Tabelle1", infer_eltypes = true)...)
    #CSV.read(storage_parameter_file, DataFrame; delim = ',', header = 3, types = Dict(:Storage_Technology=>String, :VectorST=>String, :Units_of_installed_capacity=>String))

    @info "did read storage data"

    # filename of file containing parameters of transmission lines
    transmission_parameter_file = folder * "transmission_lines.xlsx"

    # create DataFrame containing data of transmission lines
    transmission_data = DataFrame(XLSX.readtable(transmission_parameter_file, "Tabelle1", infer_eltypes = true)...)
    #CSV.read(transmission_parameter_file, DataFrame; delim = ',', header = 2, types = Dict(:line_name=>String, :BarO=>String, :BarD=>String))

    @info "did read transm data"

    # filename of file containing electricity demand profiles
    demand_profile_file = folder * "demand_profiles.xlsx"

    # create DataFrame containing demand profiles data
    demand_profile_data = DataFrame(XLSX.readtable(demand_profile_file, "Tabelle1", infer_eltypes = true)...)
    #CSV.read(demand_profile_file, DataFrame; delim = ',', header = 1, types = Dict(:timestep_name=>String))

    @info "did read demand data"

    # filename of file containing data of hydropower cascades
    hydro_cascades_file = folder * "hydro_cascades.xlsx"

    # create DataFrame containing data of hydropower cascades
    hydro_cascades_data = DataFrame(XLSX.readtable(hydro_cascades_file, "Tabelle1", infer_eltypes = true)...)
    #CSV.read(hydro_cascades_file, DataFrame; delim = ',', header = 1, types = Dict(:BusH=>String, :Code=>String, :hydro_name=>String, :Type=>String, :TurbinedGoesTo=>String, :EcoflowGoesTo=>String, :PumpedGoesTo=>String))

    @info "did read hydro data"

    # filename of file containing data of run of river generators
    hydro_ROR_file = folder * "hydro_run_of_river.xlsx"

    # create DataFrame containing data of run of river generators
    hydro_ROR_data = DataFrame(XLSX.readtable(hydro_ROR_file, "Tabelle1", infer_eltypes = true)...)
    #CSV.read(hydro_ROR_file, DataFrame; delim = ',', header = 1, types = Dict(:ror_name=>String, :BusRoR=>String))

    @info "did read ROR data"


    #= TODO: red in the following data:
    renewable_profiles.xlsx
    preexisting_capacities.xlsx
    hydro_run_of_river_profiles.xlsx
    scenario_settings.xlsx (so far empty)
    =#

    #= TODO: adapt this to new XLSX inputs...
    @show ren_generator_data
    n_buses = 4
    m_pexistingR = zeros(Float64, nrow(ren_generator_data), n_buses)
    @show typeof(m_pexistingR)
    @show m_pexistingR
    for i in 1:n_buses
        m_pexistingR[:,i] = ren_generator_data[!, Symbol("pexistingRb$(i)")]
    end
    @show m_pexistingR

    n_buses = 4 # TODO: change it to get read from inputs
    my_pexistingG = zeros(Float64, nrow(conv_generator_data), n_buses)
    @show typeof(my_pexistingG)
    @show my_pexistingG
    for i in 1:n_buses
        my_pexistingG[:,i] = conv_generator_data[!, Symbol("pexistingGb$(i)")]
    end
    @show my_pexistingG
    =#


    @info "Showing: Data Frames:"

    @show describe(scenario_setting_data)
    @show describe(conv_generator_data)
    @show describe(ren_generator_data)
    @show describe(converter_data)
    @show describe(storage_data)
    @show describe(transmission_data)
    @show describe(demand_profile_data)
    @show describe(hydro_cascades_data)
    @show describe(hydro_ROR_data)

    # read neccessairy indexes to assemble matrices
    n_buses = scenario_setting_data[1, :n_buses]

    n_years = scenario_setting_data[1, :n_years]
    starting_year = scenario_setting_data[1, :starting_year]
    year_timestep = scenario_setting_data[1, :year_timestep]
    years = collect(starting_year:year_timestep:(starting_year + nyears * year_timestep))

    n_conv_generators = nrow(conv_generator_data)

    my_costCapG[:,i] = Matrix{Float64}(conv_generator_data[!,Symbol.("costCapGy".*string.(years))])



    # TODO: keep replacing placeholder-zeros with real values

    model_data = ModelData(interest_rate =  scenario_setting_data[1, :interest_rate],
                        dt = Float64(scenario_setting_data[1, :timestep_length]),
                        nt =  scenario_setting_data[1, :n_timesteps],
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
                        costCapG = Matrix{Float64}(conv_generator_data[!,Symbol.("costCapGy".*string.(years))]),




                        costOperationVarG = conv_generator_data[!, :CostOperationVarG],
                        costOperationFixG = conv_generator_data[!, :CostOperationFixG],
                        costReserveG = conv_generator_data[!, :CostReserveG],
                        lifetimeG = conv_generator_data[!, :Lifetime],
                        annuityG = conv_generator_data[!, :AnnuityG],
                        pMinG = conv_generator_data[!, :PMinG],
                        pMaxG = conv_generator_data[!, :PMaxG],
                        minFossilGeneration = 0.0, # TODO
                        maxFossilGeneration = 0.0, # TODO
                        costRampsCoal_hourly = 0.0, # TODO
                        costRampsCoal_daily = 0.0, # TODO
                        costWTCoal = 0.0, # TODO
                        pexistingG = my_pexistingG,
                        costCapR = ren_generator_data[!, :CostCapR],
                        costOperationVarR = ren_generator_data[!, :CostOperationVarR],
                        costOperationFixR = ren_generator_data[!, :CostOperationFixR],
                        lifetimeR = ren_generator_data[!, :Lifetime],
                        annuityR = ren_generator_data[!, :AnnuityR],
                        technologyR = ren_generator_data[!, :tech],
                        profilesR= zeros(Float64, (1,1,1)), # TODO
                        minCapacityPotR = [0.0 0.0; 0.0 0.0],
                        maxCapacityPotR = [0.0 0.0; 0.0 0.0],
                        pexistingR = [0.0 0.0; 0.0 0.0],
                        pRpho = [0.0 0.0; 0.0 0.0],
                        costCapCT = [0.0],
                        costOperationFixCT = [0.0],
                        costOperationConvCT = [0.0],
                        lifetimeCT = [0],
                        annuityCT = [0.0],
                        costReserveCT = [0.0],
                        conversionFactorCT = [0.0],
                        etaconv = [0.0],
                        minCapacityPotCT = [0.0 0.0; 0.0 0.0],
                        maxCapacityPotCT = [0.0 0.0; 0.0 0.0],
                        pexistingCT = [0.0 0.0; 0.0 0.0],
                        pCTpho = [0.0 0.0; 0.0 0.0],
                        vectorCT_O = ["0"],
                        vectorCT_D = ["0"],
                        ProfilesCSP = [0.0 0.0; 0.0 0.0],
                        costCapST = [0.0],
                        costOperationVarST = [0.0],
                        costOperationFixST = [0.0],
                        lifetimeST = [0],
                        annuityST = [0.0],
                        vMinST = [0.0],
                        lossesST = [0.0],
                        minVolumePotST = [0.0],
                        maxVolumePotST = [0.0],
                        energy2PowerRatioMax = [0.0],
                        energy2PowerRatioMin = [0.0],
                        cyclesST = [0.0],
                        vExistingST = [0.0],
                        storageEntityST = ["0"],
                        eSTpho = [0.0],
                        costOperationFixH = [0.0],
                        costReserveH = 0.0,
                        pMaxH = [0.0],
                        pMinH = [0.0],
                        vMaxH = [0.0],
                        vMinH = [0.0],
                        kH = [0.0],
                        busH = ["0"],
                        costCapUpgradeH = [0.0],
                        pexistingH = [0.0],
                        turbinedGoesTo = ["0"],
                        divertedGoesTo = ["0"],
                        pumpedGoesTo = ["0"],
                        qDivertedMinH = [0.0],
                        qInflowH = [0.0 0.0; 0.0 0.0],
                        lossesH = [0.0],
                        costOperationFixRoR = [0.0],
                        pMaxRoR = [0.0],
                        profilesRoR = [0.0 0.0; 0.0 0.0],
                        busRoR = ["0"],
                        maxCapacityPotL = [0.0],
                        barO = ["0"],
                        barD = ["0"],
                        lossesL = [0.0],
                        capLExisting = [0.0],
                        costCapL = [0.0],
                        costOperationFixL = [0.0],
                        costOperationVarL = [0.0],
                        lifetimeL = [0],
                        annuityL = [0.0],
                        demand = [0.0 0.0; 0.0 0.0],
                        autonomyDays = 0.0,
                        costAutonomy = 0.0,
                        energyCurtailedMax = 0.0,
                        reserveDemand = 0.0,
                        reserveRenewables = 0.0,
                        reserveLargestUnit = 0.0,
                        reserveFast = 0.0,
                        reserveFUsedRatio = 0.0,
                        reserveOUsedRatio = 0.0,
                        peakLoad = [0.0],
                        costUnserved = 0.0,
                        costSpilled = 0.0,
                        costFictitiousFlows = 0.0,
                        runningCosts = 0.0,
                        epsilonTransmission = 0.0,
                        epsilonGHG = 0.0,
                        carbonTax = 0.0,
                        GHGupstreamR = [0.0],
                        GHGdownstreamR = [0.0],
                        GHGOperationR = [0.0],
                        GHGOperationRoR = [0.0],
                        GHGOperationH = [0.0],
                        GHGOperationG = [0.0],
                        GHGOperationCT = [0.0],
                        GHGupstreamCT = [0.0],
                        GHGdownstreamCT = [0.0],
                        GHGupstreamST = [0.0],
                        GHGdownstreamST = [0.0],
                        GHGOperationST = [0.0],
                        LCAopR = [0.0 0.0; 0.0 0.0],
                        LCAconR = [0.0 0.0; 0.0 0.0],
                        LCAopCT = [0.0 0.0; 0.0 0.0],
                        LCAconCT = [0.0 0.0; 0.0 0.0],
                        LCAopST = [0.0 0.0; 0.0 0.0],
                        LCAconST = [0.0 0.0; 0.0 0.0],
                        LCAopG = [0.0 0.0; 0.0 0.0],
                        LCAconG = [0.0 0.0; 0.0 0.0],
                        LCAopH = [0.0],
                        LCAconH = [0.0],
                        LCAopRoR = [0.0],
                        LCAopL = [0.0],
                        LCAconL = [0.0 0.0; 0.0 0.0],
                        EpsilonLCA = [0.0],
                        VectorSObj = [0.0],
                        Objcount = "0"
                        )

    return model_data

end
