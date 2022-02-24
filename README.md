# Leelo
Energy expansion planning including Distributed Systems using Linear Optimization

## Short introduction to the model

Used to do energy expansion planning. Model data for chile. Now tries to incorporate DS.

## How the code works

Central `Julia` code builds mathematical model, gets input data from CSV or Excel files, and hands it to CPLEX for solving. Then writes results to some other CSV or Excel files and plots the main results.

## How to use

### Setup

> Since it now is its own package the JuMP.jl and CEPLEX.jl part should not be needed anymore... but CPLEX needs to be installed.

Needs Julia -> Download and install Julia
Needs JuMP.jl and all its dependencies including a solver, which in this case is CPLEX.jl
CPLEX therefore needs to be installed, which is free for students and academia. The Path to the CPLEX installation should be adapted to ones personal installation folder.

```Julia
import Pkg
Pkg.add("JuMP")
ENV["CPLEX_STUDIO_BINARIES"] = "C:\\Program Files\\CPLEX_Studio1210\\cplex\\bin\\x86-64_win\\"
Pkg.add("CPLEX")
```

### Usage

Can run whole simulation from command line, but can best be used from interactive Julia session (e.g. REPL) for more granular control of plotting etc.

## References

If someone uses this code please cite the following paper: blabla
