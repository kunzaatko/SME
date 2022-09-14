using Query, FreqTables, Statistics, Plots, LaTeXStrings, StatsPlots, NamedArrays
pgfplotsx()

(data, eagle, dominos) = include("./data_preparation.jl")

println("""

#######################################################################
#                 Kombinované diagramy podle kategoií                 #
#######################################################################
""")

function combined_diagram_grouped_crust_description(data_frame)
    @df data_frame violin(
        :CrustDescription, :Diameter; ylabel=L"$D$ (cm)", lab=nothing, linewidth=0
    )
    @df data_frame boxplot!(
        :CrustDescription, :Diameter; lab=nothing, linewidth=1, fillalpha=0.70
    )
    @df data_frame dotplot!(
        :CrustDescription, :Diameter; lab=nothing, marker=(:black, stroke(0), 2, 0.8)
    )
    return current()
end

function combined_diagram_grouped_topping(data_frame)
    @df data_frame violin(:Topping, :Diameter; ylabel=L"$D$ (cm)", lab=nothing, linewidth=0)
    @df data_frame boxplot!(:Topping, :Diameter; lab=nothing, linewidth=1, fillalpha=0.70)
    @df data_frame dotplot!(
        :Topping, :Diameter; lab=nothing, marker=(:black, stroke(0), 2, 0.8)
    )
    return current()
end

println("""

#######################################################################
#                             Histogramy                              #
#######################################################################
""")

len = 20
eagle_diam_in_data = ustrip.(eagle[:, :Diameter_inch])
hist_eagle = histogram(
    eagle_diam_in_data;
    bins=range(minimum(eagle_diam_in_data); stop=maximum(eagle_diam_in_data), length=len),
    label=L"$D_{\text{EagleBoys}}$",
);

dominos_diam_in_data = ustrip.(dominos[:, :Diameter_inch])
hist_dominos = histogram(
    dominos_diam_in_data;
    bins=range(
        minimum(dominos_diam_in_data); stop=maximum(dominos_diam_in_data), length=len
    ),
    label=L"$D_{\text{Domino's}}$",
);

