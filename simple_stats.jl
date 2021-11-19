using Statistics

(data, eagle, dominos) = include("./data_preparation.jl")

#' @description
#'
#' Return simple statistics of dataframe grouped by group_name
function simp_diam_stats_grouped(group_name::Symbol, data_frame=data) # {{{
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
end # }}}

function simp_diam_stats_grouped(group_name::String, args...)
    return simp_diam_stats_grouped(Symbol(group_name), args...)
end

simple_stats = Dict(:data => Dict(:Store => simp_diam_stats_grouped("Store", data)))

for (data, key) in zip([eagle, dominos], [:eagle_boys, :dominos])
    simple_stats[key] = Dict(
        :CrustDescription => simp_diam_stats_grouped("CrustDescription", data),
        :Topping => simp_diam_stats_grouped("Topping", data),
    )
end

return simple_stats
