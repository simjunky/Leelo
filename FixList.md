# Things to Fix

Ongoing list of... well... things to fix and some other open questions.

## Apparent Problems stemming from old LEELO

Problems or inconsistencies found in old, `GAMS`-implemented LEELO version. Problems ported to new code and therefore possible errors still existent!

>**:warning: TODO:** Inform Jannik and work these through!

1. Excel File: `Inputs!I46:I48` the penalties are declared as given in Euros, whereas all other monetary values are denoted in Dollars. Location in Code: struct of `ModelData`.
2. Excel File: `InputsL!I6:I11` references cell I4 to calculate transmission losses. I4 is empty ⇒ all losses are zero??
3. According to GAMS comments `CostOperationVar`,`CostOperationFix` for `G` are in $ but for `R` they are in k$?? Apparently the both are in k$ since in the equations there are always `*1000`.
4. According to GAMS comments `CostCapCT` and friends are in k€ instead of Dollars.
5. According to GAMS comments `CostOperationConvCT` depends on installed capacity, but should be dependent on ammount ov converted energy. Seems to be calculated correctly in eq `OCs`.
6. GAMS comments unsure if `CostReserveCT` is reserve of capacity, power or energy (MW or MWh)
7. Gams does not specify what `etaconv(ct)` is, or what unit its in.
8. `CostOperation[...]ST` again has the problem of € in GAMS comment, but should be in k$
9. Conversion technologies mix around in between being installed in MWh or MW... which one is it?
10. Why is the `CostOperationFixL` in Excels `InputsL` a) in k-Euro/MW and b) rounded to full euros (ok, its just the view, not the Data.)? Or other point on this Excel-Sheet: Why is so much calculated within Excel? and not by the programm, which would reduce the number of inputs and thereby comlexity for the user.
11. Is Excels `InputsH`'s `Pmin(Data)` even used (seems as not) and what is the difference to `PMinH`?
12. Why do "Equivalent ROR" exist (speedup?)? Why is Excels `InputsROR` -> `PMaxROR` rounded to 100's MW and not the regular sum taken?
13. Why is there a need for an auxiliary ROR generator? (same with the dummy H)

## Open questions

Questions related to the understanding.

1. What is the storage technologies `Energy2PowerRatio` for? and what energy is compared to what power? stored Energy or overall energy that has been stored? Wha is it important?
2. What do all 4 coal ramping "auxiliary variables" `rampsAuxCoal1...4` even do? What are they for?... NVM they store values of produces coal power to determine hourly (1&2) and 12h/daily (3&4) coal ramping and associated costs.

## Big To-Do's

Some bigger To-Do's to keep in mind and not hide within the code.

1. Recheck all Data Input Types if Excel did not round them off (as with the demand profiles)!
2. Revise all inputs to check if they are neccessairy. (And cannot be calculated off of some other inputs already given; e.g. Annuity, CostCapL, CostOperation...L, etc.) (Also: clean input files afterward)
3. rename programm variables to make them more verbose and not as obscure as currently.
4. Recheck all variable bounds to maybe shrink searchspace
