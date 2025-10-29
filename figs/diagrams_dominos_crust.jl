using StatsPlots, LaTeXStrings

data, _, dominos = include("../data_preparation.jl")

pgfplotsx()

@df dominos begin
    violin(:CrustDescription, :Diameter; ylab=L"D \text{ (cm)}", linewidth=0, label=nothing)
    boxplot!(:CrustDescription, :Diameter; fillalpha=0.75, label=nothing)
    dotplot!(:CrustDescription, :Diameter; marker=:black, markersize=1, label=nothing)
end

fig_path = normpath(dirname(@__FILE__) * "/../report/figs/Dominos_Crust_diagrams.tikz")
savefig(fig_path)
