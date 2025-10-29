using StatsPlots, LaTeXStrings

_, _, dominos = include("../data_preparation.jl")

pgfplotsx()

@df dominos begin
    violin(:Topping, :Diameter; ylab=L"D \text{ (cm)}", linewidth=0, label=nothing)
    boxplot!(:Topping, :Diameter; fillalpha=0.75, label=nothing)
    dotplot!(:Topping, :Diameter; marker=:black, markersize=1, label=nothing)
end

fig_path = normpath(dirname(@__FILE__) * "/../report/figs/Dominos_Topping_diagrams.tikz")
savefig(fig_path)
