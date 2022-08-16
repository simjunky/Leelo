# TODO: rewrite docstring
# write model variables to file
"""
TODO
"""
function write_variables(model::JuMP.Model, year::Int64; scenario_folder::String = "data/TestScenario/output_data", file_name::String = "model_variables.h5")

    # TODO: remove unneeded outputs
    @info "writing model variables to file"

    # TODO: maybe make sure that the created file actually has the .h5 or .hdf5 ending?

    # TODO: write important data information to the HDF5 file: what variable, unit, what dimensions are what...

    # open the HDF5 file in create & write mode
    file = h5open(scenario_folder * "/" * file_name, "cw")

    # all variables of the model are in a group named after the modeled year.
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
