
"""
    write_variables(model::JuMP.Model, data::ModelData, i_current_year::Int64; scenario_dir::String = "data/TestScenario", file_name::String = "model_variables.h5")

This function writes the values of the models variables into a `HDF5` file, after they have been set by the optimization.

# Keywords

**`model`** is the `JuMP` model containing all constraints and variables of the current year. For this function to be called, the `optimize!()` function has to already been called, such that the model variables have values accessible by the `value()` function.

**`data`** is the data structure containing all the parameters of the model and of the type `ModelData`.

**`i_current_year`** is the index of the current year in `data.years`.

**`scenario_dir`** is a `String` containing the relative path to the chosen scenarios directory. The written output file will be inside a `output_data` sub-directory.

**`file_name`** is the name of the created file. It defaults to `model_variables.h5`.

"""
function write_variables(model::JuMP.Model, data::ModelData, i_current_year::Int64; scenario_dir::String = "data/TestScenario", file_name::String = "model_variables.h5")

    # TODO: remove unneeded outputs
    @info "writing model variables to file"

    # TODO: maybe make sure that the created file actually has the .h5 or .hdf5 ending?

    # TODO: write important data information to the HDF5 file: what variable, unit, what dimensions are what...

    # create the output directory to save the HDF5 file in, if it doesn't exist
    output_dir = scenario_dir * "/output_data"
    if(!isdir(output_dir))
        mkdir(output_dir)
    end

    # open the HDF5 file
    # if the current year is the first one, delete existing content, else append in create & write mode
    file = h5open(output_dir * "/" * file_name, (i_current_year == 1 ? "w" : "cw"))

    # all variables of the model are in a group named after the modeled year.
    year = data.years[i_current_year]
    create_group(file, "model" * string(year))
    group = file["model" * string(year)]

    # copy the dictionary of the model which contains symbols of all variables and constraints
    cdict = copy(object_dictionary(model))

    # filter out the constraints by only keeping the variables, which are either scalar variables or vectors of variables.
    # this mutates the dictionary, which is why a copy has been made earlier.
    filter!(p -> ((typeof(p[2]) == VariableRef) || (eltype(p[2]) == VariableRef)), cdict)

    # iterate through all symbols of the variables of the model to write them all to the file
    for s in keys(cdict)

        # write each variable into a separate dataset of the HDF5 file
        # each variables dataset is named after its symbol, which is unique.
        write(group, string(s), value.(model[s]))

    end

    # close file to free objects and release file to other programms.
    close(file)

    return nothing
end
