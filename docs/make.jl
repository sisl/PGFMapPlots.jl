using Documenter
using PGFMapPlots

# Generate documents
makedocs(
    modules   = [PGFMapPlots],
    doctest   = false,
    clean     = true,
    linkcheck = true,
    format    = Documenter.HTML(),
    sitename  = "PGFMapPlots.jl",
    authors   = "Duncan Eddy",
    pages     = Any[
        "Home" => "index.md",
    ]
)

# Generate plots
# makeplots()

deploydocs(
    repo = "github.com/sisl/PGFMapPlots.jl",
    devbranch = "master",
    devurl = "latest",
)