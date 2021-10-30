using Query, FreqTables, Statistics, Plots, LaTeXStrings, StatsPlots
pgfplotsx()

(data, eagle, dominos) = include("./data_preparation.jl")

println("""
#######################################################################
#                          Četnostní tabulky                          #
#######################################################################
""")

println("""

###############
#  Kategorie  #
###############
""")

println("""
# EagleBoys
""")
eagle_categories = freqtable(eagle, :CrustDescription, :Topping)
eagle_categories_prop = prop(eagle_categories)

println("EagleBoys četnostní tabulka kategorií:")
println(eagle_categories, "\n")
println("Proporce četností (EagleBoys)")
println(eagle_categories_prop, "\n")

println("""
# Dominos
""")
dominos_categories = freqtable(dominos, :CrustDescription, :Topping)
dominos_categories_prop = prop(dominos_categories)

println("Dominos četnostní tabulka kategorií:")
println(dominos_categories, "\n")
println("Proporce četností (Dominos)")
println(dominos_categories_prop, "\n")

println("""

###########
#  Firmy  #
###########
""")

println("""
# Crust
""")
freq_crust = freqtable(data, :Store, :Crust)
prop_crust = prop(freq_crust)

println("Četnostní tabulka kůrka:")
println(freq_crust, "\n")
println("Proporce četností (kůrka)")
println(prop_crust, "\n")

println("""
# Top
""")
freq_top = freqtable(data, :Store, :Top)
prop_top = prop(freq_top)

println("Četnostní tabulka přísady:")
println(freq_top, "\n")
println("Proporce četností (přísady)")
println(prop_top, "\n")

println("""

#######################################################################
#               Deskriptivní statistiky velikosti pizz                #
#######################################################################
""")

function simp_diam_stats_grouped(group_name::Symbol, data_frame=data)
    simp_stats = @from i in data_frame begin
        @group i by i[group_name] into g
        @select {
            group = key(g),
            meanDiam_in = mean(g.Diameter_inch),
            meanDiam = mean(g.Diameter_cm),
            stdDiam_in = std(g.Diameter_inch),
            stdDiam = std(g.Diameter_cm),
            stdMed_in = median(g.Diameter_inch),
            stdMed = median(g.Diameter_cm),
            maxDiam_in = maximum(g.Diameter_inch),
            maxDiam = maximum(g.Diameter_cm),
            minDiam_in = minimum(g.Diameter_inch),
            minDiam = minimum(g.Diameter_cm),
        }
        @collect DataFrame
    end
    return simp_stats
end
function simp_diam_stats_grouped(group_name::String, args...)
    return simp_diam_stats_grouped(Symbol(group_name), args...)
end

println("""

###############
#  Kategorie  #
###############
""")

println("""

# EagleBoys
""")
println("\nZákladní statistiky podle kůrky")
println(simp_diam_stats_grouped("CrustDescription", eagle))
println("\nZákladní statistiky podle přísad")
println(simp_diam_stats_grouped("Topping", eagle))

println("""

# Dominos
""")
println("\nZákladní statistiky podle kůrky")
println(simp_diam_stats_grouped("CrustDescription", dominos))
println("\nZákladní statistiky podle přísad")
println(simp_diam_stats_grouped("Topping", dominos))

println("""

###########
#  Firmy  #
###########
""")

println(simp_diam_stats_grouped("Store", data))

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
        :CrustDescription,
        :Diameter;
        lab=nothing,
        marker=(:black, stroke(0), 2, 0.8),
    )
    return current()
end

function combined_diagram_grouped_topping(data_frame)
    @df data_frame violin(
        :Topping, :Diameter; ylabel=L"$D$ (cm)", lab=nothing, linewidth=0
    )
    @df data_frame boxplot!(
        :Topping, :Diameter; lab=nothing, linewidth=1, fillalpha=0.70
    )
    @df data_frame dotplot!(
        :Topping, :Diameter; lab=nothing, marker=(:black, stroke(0), 2, 0.8)
    )
    return current()
end

println("""

#######################################################################
#                             Histogramy
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

