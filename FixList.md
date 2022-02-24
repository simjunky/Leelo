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

## Open questions

Questions related to the understanding.

1. What is the storage technologies `Energy2PowerRatio` for? and what energy is compared to what power? stored Energy or overall energy that has been stored? Wha is it important?
