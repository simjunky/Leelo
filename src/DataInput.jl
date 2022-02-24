

# TODO: write better, more detailed DocString
"""
Read all input files and write all Data a new data structure.
"""
function read_model_data()::ModelData

    # path to folder with input files
    folder = "data/TestLocation/input_data/"

    # filename of file containing parameters of conventional generators
    conv_generator_parameter_file = folder * "conventional_generators.csv"

    conv_generator_data = CSV.read(conv_generator_parameter_file, DataFrame; delim=',', header=3, select=[:generator_name, :CostCapG, :CostOperationVarG, :Tech])

    @show conv_generator_data
    @show conv_generator_data[!, :generator_name]
    @show typeof(conv_generator_data[!, :generator_name])


    ren_generator_parameter_file = folder * "renewable_generators.csv"

    ren_generator_data = CSV.read(ren_generator_parameter_file, DataFrame; delim=',', header=3)

    @show ren_generator_data
    n_buses = 4
    m_pexistingR = zeros(Float64, nrow(ren_generator_data), n_buses)
    @show typeof(m_pexistingR)
    @show m_pexistingR
    for i in 1:n_buses
        m_pexistingR[:,i] = ren_generator_data[!, Symbol("pexistingRb$(i)")]
    end
    @show m_pexistingR

    ren_generator_profile_file = folder * "renewable_generators_profiles.csv"

    # TODO: keep replacing placeholder-zeros with real values
    model_data = ModelData(interest_rate = 0.0,
                        dt = 0.0,
                        nt = 0,
                        modelType = "0",
                        scenario = "0",
                        curyear = 0,
                        g_conventional_generator_names = ["0"],
                        r_renewable_generator_names = ["0"],
                        ct_conversion_technologies_names = ["0"],
                        st_storage_technologies_names = ["0"],
                        b_busses_names = ["0"],
                        l_transmission_lines_names = ["0"],
                        t_hourly_timesteps_names = ["0"],
                        h_hydro_power_generators_names = ["0"],
                        ror_run_of_river_generators_names = ["0"],
                        ic_impact_categories_names = ["0"],
                        costCapG = [0.0],
                        costOperationVarG = [0.0],
                        costOperationFixG = [0.0],
                        costReserveG = [0.0],
                        lifetimeG = [0],
                        annuityG = [0.0],
                        pMinG = [0.0],
                        pMaxG = [0.0],
                        minFossilGeneration = 0.0,
                        maxFossilGeneration = 0.0,
                        costRampsCoal_hourly = 0.0,
                        costRampsCoal_daily = 0.0,
                        costWTCoal = 0.0,
                        pexistingG = [0.0 0.0; 0.0 0.0],
                        costCapR = [0.0],
                        costOperationVarR = [0.0],
                        costOperationFixR = [0.0],
                        lifetimeR = [0],
                        annuityR = [0.0],
                        technologyR = ["0"],
                        profilesR= zeros(Float64, (1,1,1)),
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
