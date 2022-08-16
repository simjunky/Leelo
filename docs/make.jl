using Documenter, Leelo

makedocs(sitename = "Leelo.jl",
    pages = ["index.md", "manual.md", "documentation.md"])

deploydocs(repo = "github.com/simjunky/Leelo.git")
