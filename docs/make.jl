using Leelo, Documenter

makedocs(sitename = "Leelo.jl",
    pages = ["index.md", "manual.md", "documentation.md"])


ENV["GITHUB_EVENT_NAME"] = "push"
ENV["GITHUB_REPOSITORY"] = "github.com/simjunky/Leelo.git"
ENV["GITHUB_REF"] = "master"


deploydocs(repo = "github.com/simjunky/Leelo.git", target = "build", deps = nothing, make = nothing, devbranch = "master", versions = nothing, deploy_config = Documenter.GitHubActions())
