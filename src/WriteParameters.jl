
"""
    function write_parameters(data::ModelData; scenario_dir::String = "data/TestScenario", file_name::String = "model_results.h5")

This function writes selected model parameters into a `HDF5` file. Currently only existing capacities are saved. This function should only be called after the simulation of every benchmark year has terminated, such that all parameters are up to date.

# Keywords

**`data`** is the data structure containing all the parameters of the model and is of the type `ModelData`.

**`scenario_dir`** is a `String` containing the relative path to the chosen scenarios directory. The written output file will be inside a `output_data` sub-directory.

**`file_name`** is the name of the created file. It defaults to `model_results.h5`.

"""
function write_parameters(data::ModelData; scenario_dir::String = "data/TestScenario", file_name::String = "model_results.h5")

    # TODO: remove unneeded outputs:
    @info "writing model parameters to file"

    # create the output directory to save the HDF5 file in, if it doesn't exist yet
    output_dir = scenario_dir * "/output_data"
    if(!isdir(output_dir))
        mkdir(output_dir)
    end

    # open the HDF5 file in create & write mode, suhc that no data is deleted.
    file = h5open(output_dir * "/" * file_name, "cw")

    # create a group to store the parameters in.
    create_group(file, "parameters")
    group = file["parameters"]

    # iterate through all fields of the data structure
    for field in fieldnames(typeof(data))

        # write each parameter into a separate dataset into the parameter group of the HDF5 file
        # each dataset is named after the parameter, which is unique since it is also its field name.
        write(group, string(field), getfield(data, field))
    end

    # close file to free objects and release file to other programms.
    close(file)

    return nothing
end
