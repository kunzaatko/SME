using StatsPlots, LaTeXStrings

_, eagle, dominos = include("../data_preparation.jl")

pgfplotsx()

@df eagle begin
    violin(
        string.(:Crust),
        :Diameter;
        ylab=L"D \text{ (cm)}",
        linewidth=0,
        label="EagleBoys",
        side=:left,
        legend=:topleft,
    )
    dotplot!(
        string.(:Crust), :Diameter; marker=:black, markersize=1, label=nothing, side=:left
    )
end

@df dominos begin
    violin!(string.(:Crust), :Diameter; linewidth=0, label="Domino's", side=:right)
    dotplot!(
        string.(:Crust), :Diameter; marker=:black, markersize=1, label=nothing, side=:right
    )
end

fig_path = normpath(dirname(@__FILE__) * "/../report/figs/Stores_Crust_diagrams.tikz")
savefig(fig_path)
