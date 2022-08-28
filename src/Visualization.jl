
"""
    create_plots(; scenario_dir::String = "data/TestScenario", file_name::String = "model_results.h5")

This function creates plots of the simulation results by calling all individual plot functions. All plots are saved as `PDF` into the `plots` sub-directory. This function sets the general theme of the individual plots.

# Arguments

**`scenario_dir`** is a `String` containing the relative path to the chosen scenarios directory. The `HDF5` file must be inside a `output_data` sub-directory.

**`file_name`** is a `String` containing the name of `HDF5` file. It defaults to `model_results.h5`.

"""
function create_plots(; scenario_dir::String = "data/TestScenario", file_name::String = "model_results.h5")

    # TODO: remove unneeded outputs
    @info "create_plots() called"

    # open file containing variable values in read-only mode
    file_location = scenario_dir * "/output_data/" * file_name
    file = h5open(file_location, "r")

    # create directory to save plot files in, if it doesnt exist
    target_dir = scenario_dir * "/plots"
    if(!isdir(target_dir))
        mkdir(target_dir)
    end

    # set color theme and palette for the plots
    Plots.theme(:default, palette = [:darkorange1, :deepskyblue, :lawngreen, :red2, :cyan, :magenta2])

    # call plotting sub-functions.
    plot_total_cost(file, target_dir)
    plot_power_production(file, target_dir)
    plot_built_capacities(file, target_dir)

    # TODO: add more functions and plots:
    # Storage by type (Ex+new capa)
    # same for the other ones... G, R, CT
    #


    # close file to free objects and release file to other programms.
    close(file)

    return nothing
end




"""
    plot_total_cost(file::HDF5.File, target_dir::String)

This function creates a plot of the systems total cost over the years and saves it into a `.PDF` file. Additionally the total investment, oparating and carbon tax costs are plotted as well.

# Arguments

**`file`** is the `HDF5`-file containing the results of the simulation.

**`target_dir`** is the directory in which to save the plot to.

"""
function plot_total_cost(file::HDF5.File, target_dir::String)

    # TODO: remove unneeded output:
    @info "plotted total cost"

    # TODO: operational costs seem to make up almost the entire costs... making the plot unreadable...therefore maybe only plot total costs...and make contributions as percentage?

    # file destinations to save plots to
    plot_file_name = "total_cost_yearly.pdf"

    # read data from file
    x = read(file["parameters"], "years")
    n_years = length(x)
    y = zeros(Float64, (n_years, 4))
    for i in 1:n_years
        y[i, 1] = read(file["model" * string(x[i])], "TotalCost")
        y[i, 2] = read(file["model" * string(x[i])], "ICt")
        y[i, 3] = read(file["model" * string(x[i])], "OCt")
        y[i, 4] = read(file["model" * string(x[i])], "CostGHG")
    end

    # create the plot
    plot = Plots.plot(x, (y./1000000), title = "Total cost of the system for each year", xlabel = "year [a]", ylabel = "cost [mil. Dollars]", label = ["Total Cost" "Investment Cost" "Operational Cost" "CarbonTax"], legend = :outertopright, markershape = [:diamond :x :circle :rect])

    # write the stored plot to a .pdf-file
    Plots.savefig(plot, target_dir * "/" * plot_file_name)

    return nothing
end




"""
    plot_power_production(file::HDF5.File, target_dir::String)

This function creates a stacked bar plot of the produced power by each power source and saves it into a `.PDF` file.

# Arguments

**`file`** is the `HDF5`-file containing the results of the simulation.

**`target_dir`** is the directory in which to save the plot to.

"""
function plot_power_production(file::HDF5.File, target_dir::String)

    # TODO: remove unneeded output:
    @info "plotted power production"

    # TODO: split the mayor groups up into their respective constituents but keep them together => show only csp from conversion, rest is mainly storage

    # file destinations to save plots to
    plot_file_name = "power_production_yearly.pdf"

    # read data from file
    x = read(file["parameters"], "years")
    n_years = length(x)
    g = zeros(Float64, (n_years))
    r = zeros(Float64, (n_years))
    h = zeros(Float64, (n_years))
    ror = zeros(Float64, (n_years))
    ct = zeros(Float64, (n_years))
    for i in 1:n_years
        g[i] = sum(read(file["model" * string(x[i])], "powerG"))
        r[i] = sum(read(file["model" * string(x[i])], "powerR"))
        h[i] = sum(read(file["model" * string(x[i])], "powerH"))
        ror[i] = sum(read(file["model" * string(x[i])], "powerRoR"))
        ct[i] = sum(read(file["model" * string(x[i])], "powerCT"))
    end

    # create the plot
    plot = StatsPlots.groupedbar([g r h ror ct], bar_position = :stack, title = "Power production by source", xlabel = "year [a]", ylabel = "power [MW]", label = ["conventional" "renewable" "hydro" "river" "conversion"])

    # write the stored plot to a .pdf-file
    Plots.savefig(plot, target_dir * "/" * plot_file_name)

    return nothing
end




"""
    plot_built_capacities(file::HDF5.File, target_dir::String)

This function creates a stacked bar plot of the newly built capacities of each power source and saves it into a `.PDF` file.

# Arguments

**`file`** is the `HDF5`-file containing the results of the simulation.

**`target_dir`** is the directory in which to save the plot to.

"""
function plot_built_capacities(file::HDF5.File, target_dir::String)

    # TODO: remove unneeded output:
    @info "plotted built capacities"

    # TODO: again storage and conversion seem to take the biggest share... maybe make extra plot for them in detail...and leave them out of this one.

    # file destinations to save plots to
    plot_file_name = "built_capacities_yearly.pdf"

    # read data from file
    x = read(file["parameters"], "years")
    n_years = length(x)
    g = zeros(Float64, (n_years))
    r = zeros(Float64, (n_years))
    h = zeros(Float64, (n_years))
    st = zeros(Float64, (n_years))
    ct = zeros(Float64, (n_years))
    for i in 1:n_years
        g[i] = sum(read(file["model" * string(x[i])], "pG"))
        r[i] = sum(read(file["model" * string(x[i])], "pR"))
        h[i] = sum(read(file["model" * string(x[i])], "pH"))
        st[i] = sum(read(file["model" * string(x[i])], "eST"))
        ct[i] = sum(read(file["model" * string(x[i])], "pCT"))
    end

    # create the plot
    plot = StatsPlots.groupedbar([g r h st ct], bar_position = :stack, title = "Newly built capacities by source", xlabel = "year [a]", ylabel = "capacity [GW]", label = ["conventional" "renewable" "hydro" "storage" "conversion"])

    # write the stored plot to a .pdf-file
    Plots.savefig(plot, target_dir * "/" * plot_file_name)

    return nothing
end
