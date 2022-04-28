
# TODO: rewrite docstring
# Constraint creation
"""
This is currently the function called to add constraints to the model
"""
function add_model_constraints(model::JuMP.Model, config::AbstrConfiguration, data::ModelData)

    # TODO: remove unneeded outputs
    @info "add_model_constraints() called"

    #@constraint(model, constraint_name, 6x + 8y >= 100)

    #TODO:
    i_current_year #index of current year
    n_timesteps
    n_buses
    n_ren_generators
    n_conv_generators
    n_storage_technologies
    n_lines

    # Constraints on the Objective function.

    # the yearly operational cost of renewable power generation
    # Calculated by multiplying the operational expenses of a renewable generator by its produced power within a timestep times the duration of the timestep.
    @constraint(model, eOperationCostR, OCr == sum((data.CostOperationVarR[r, i_current_year] * powerR[t, b, r] * data.dt) for t in 1:n_timesteps, b in 1:n_buses, r in 1:n_ren_generators))


    # the yearly operational cost of conventional power generators
    # Calculated by multiplying the operational expenses of a conventional generator by its produced power within a timestep times the duration of the timestep.
    @constraint(model, eOperationCostR, OCg == sum((data.CostOperationVarG[g, i_current_year] * powerG[t, b, g] * data.dt) for t in 1:n_timesteps, b in 1:n_buses, g in 1:n_conv_generators))


    # the yearly operational cost of energy storage
    # It is the sum of the operational cost of storage technologies and of conversion technologies.
    # The operational cost of conversion technologies is calculated by multiplying the operational expenses of a convention technology by its produced power within a timestep times the duration of the timestep.
    # The operational cost of storage technologies is calculated by multiplying the operational expenses of a storage technology by its stored and released power within a timestep times the duration of the timestep.
    @constraint(model, eOperationCostS, OCs == sum((data.CostOperationConvCT[ct, i_current_year] * powerCT[t, b, ct] * data.dt) for t in 1:n_timesteps, b in 1:n_buses, ct in 1:n_conversion_technologies) + sum((data.CostOperationVarST[st, i_current_year] * storedST[t, b, st] * data.dt) for t in 1:n_timesteps, b in 1:n_buses, st in 1:n_storage_technologies))


    # the yearly operational cost of power lines
    # Calculated by multiplying the operational expenses of a power line by its transported power in both directions within a timestep times the duration of the timestep.
    @constraint(model, eOperationCostL, OCl == sum((data.CostOperationVarL[l] * (powerLpos[t, l] + powerLneg[t, l]) * data.dt) for t in 1:n_timesteps, l in 1:n_lines))

#=
    # other yearly operational costs
    # Calculated by multiplying the operational expenses of a power line by its transported power in both directions within a timestep times the duration of the timestep.
    @constraint(model, eOperationCostO, OCo == sum((data.CostOperationVarL[l] * (powerLpos[t, l] + powerLneg[t, l]) * data.dt) for t in 1:n_timesteps, l in 1:n_lines))

.. OCo =e= sum((t,b),CostUnserved*powerunserved(t,b)*dt) +  sum((t,b),CostSpilled*powerspilled(t,b)*dt) + sum((t,h),CostFictitiousFlows*qfictitious(t,h)) + sum((t,b),CostRampsCoal_hourly*(rampsAuxCoal1(t,b)+rampsAuxCoal2(t,b))) +  sum((t,b),CostRampsCoal_daily*(rampsAuxCoal3(t,b)+rampsAuxCoal4(t,b))) +  sum((t,b),CostWTCoal*(rampsAuxCoal1(t,b)+rampsAuxCoal2(t,b)+ rampsAuxCoal3(t,b)+rampsAuxCoal4(t,b)))

=#


#=
eOperationCostT                operational cost total
eOperationCostFixedO           fixed operational costs of all generation\renewable techs
eOperationCostFixedS           fixed operational costs of storage

eInvestmentCostR               investment cost renewables
eInvestmentCostG               investment cost generators
eInvestmentCostS               investment cost storage
eInvestmentCostL               investment cost lines
eInvestmentCostH               investment cost hydropower
eInvestmentCostO               investment cost others
eInvestmentCostT               investment cost total


eGHGr                            GHG from renewables
eGHGct                           GHG from ct
eGHGst                           GHG from storage Tech
eGHGothers                       GHG from ror hydropower and generators
eGHGoperation                    Total taxable GHG (operation only)
eTotalGHG                      sum of emissions GHG
//eEpsilonHydropeaking           epsilon contrained objective function for hydropeaking
eCostGHG                       cost of GHG (tax incurred)
eTotalCost                     sum of all costs
//*MOO
//eTotalHydropeaking             sum of ramps of hydropower cascades as proxy to hydropeaking
//eTotalTransmission             sum of new installed transmission lines
//eTotalPMatter                  sum of emissions Particulate Matter
//eEpsilonTransmission           epsilon contrained objective function for transmission

//eEpsilonPMatter                epsilon contrained objective function for particulate matter
//eEpsilonGHG                    epsilon contrained objective function for greenhouse gases

eObjectiveFunction             single objective function (costs)
=#

    return nothing
end
