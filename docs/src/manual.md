# Manual

!!! info
    This page is still in the making and will contain a step by step guide on how to use `Leelo.jl`.

## Installation

### Prerequisites

The `Leelo.jl` package uses [`JuMP.jl`](https://github.com/jump-dev/JuMP.jl) to build the mathematical model and IBM's CPLEX to solve said models optimization problem. The CPLEX's API is managed by the [`CPLEX.jl`](https://github.com/jump-dev/CPLEX.jl) package.
While `JuMP.jl` is solver independent, i.e. any supported solver can be chosen, `CPLEX.jl` requires IBM's CPLEX to be installed **before** installing it and adding it to the project.

To install [IBM® ILOG® CPLEX® Optimization
Studio](https://www.ibm.com/products/ilog-cplex-optimization-studio) follow the steps on their website. CPLEX is free for academia.
After installation the `CPLEX_STUDIO_BINARIES` environment variable has to be set to the installation location, as shown below.

```Julia
ENV["CPLEX_STUDIO_BINARIES"] = "C:\\Program Files\\CPLEX_Studio1210\\cplex\\bin\\x86-64_win\\"
```

!!! info
    Your path may differ, check your CPLEX installation directory.

### The `Leelo.jl` Package

The first step to using `Leelo.jl` is to get the package and it's dependencies installed. Since it is not registered in the Julia General Registry, it needs to be added as unregistered package.
This is done by adding it via the specific github repository URL.

```Julia
using Pkg
Pkg.add("https://github.com/simjunky/Leelo")
```

Alternatively, especcially if you want to make modifikations to the models code, instead of just the computed scenarios, you can just use git to clone the github repository to your PC.
When doing so, to then use the packages functions, you need to use `activate` to switch from the standard Julia environment to the packages one. In the `REPL` navigate to the cloned directory, then use:

```Julia
using Pkg
Pkg.activate(".")
```

From here on out, no matter which method you chose, you should be able to use `Leelo.jl`'s functions as usual via:

```Julia
using Leelo
```

The following [Run the Model](@ref) section gives an overview on how to run a simulation model. The [Documentaion](@ref) gives a detailed overview of all provided functions.

## Run the Model

## Custom Data and Scenarios

## Visualization
