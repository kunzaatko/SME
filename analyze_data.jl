using HypothesisTests, Query
using Statistics: mean, var
using Distributions: Normal, cdf, Distribution, Chisq, quantile, ccdf

#' @description
#'
#' Shows all the freqtables for the data
function show_freqtables()
    # {{{
    include("./freq_tables.jl")

    eagle_freq = get_prop_freq_tables(eagle, :CrustDescription, :Topping; sums = true)
    dominos_freq = get_prop_freq_tables(dominos, :CrustDescription, :Topping; sums = true)
    crust_freq = get_prop_freq_tables(data, :Store, :Crust; sums = true)
    top_freq = get_prop_freq_tables(data, :Store, :Top; sums = true)

    freq_tables = Dict(
        :eagle_boys => eagle_freq,
        :dominos => dominos_freq,
        :crust => crust_freq,
        :top => top_freq,
    )

    printstyled(
        """
#######################################################################
#                          Četnostní tabulky                          #
#######################################################################
""";
        color = :red
    )
    printstyled(
        """
    #  Firma  #
""";
        color = :green
    )
    printstyled(
        """
        # EagleBoys
""";
        color = :cyan
    )
    printstyled(
        """
            Četnostní tabulka kategorií:
""";
        color = :blue
    )
    show(freq_tables[:eagle_boys][:freqtable])
    printstyled(
        """\n
            Proporce četností:
""";
        color = :blue
    )
    show(freq_tables[:eagle_boys][:proportion_freqtable])

    printstyled(
        """\n
        # Dominos
""";
        color = :cyan
    )

    printstyled(
        """
            Četnostní tabulka kategorií:
""";
        color = :blue
    )
    show(freq_tables[:dominos][:freqtable])
    printstyled(
        """\n
            Proporce četností:
""";
        color = :blue
    )
    show(freq_tables[:dominos][:proportion_freqtable])

    printstyled(
        """\n\n
    #  Kategorie  #
""";
        color = :green
    )

    printstyled(
        """
        # kůrka
""";
        color = :cyan
    )
    printstyled(
        """
            Četnostní tabulka firem:
""";
        color = :blue
    )
    show(freq_tables[:crust][:freqtable])
    printstyled(
        """\n
            Proporce četností:
""";
        color = :blue
    )
    show(freq_tables[:crust][:proportion_freqtable])

    printstyled(
        """\n
        # přísada
""";
        color = :cyan
    )

    printstyled(
        """
            Četnostní tabulka firem:
""";
        color = :blue
    )
    show(freq_tables[:top][:freqtable])
    printstyled(
        """\n
            Proporce četností:
""";
        color = :blue
    )
    show(freq_tables[:top][:proportion_freqtable])
    return nothing
end # }}}

#' @description
#'
#' Shows hypothesis tests for independence of categories for subpopulations by stores
function show_category_indep_hyp_tests()
    # {{{
    include("./freq_tables.jl")
    eagle_freq = get_prop_freq_tables(eagle, :CrustDescription, :Topping)
    dominos_freq = get_prop_freq_tables(dominos, :CrustDescription, :Topping)
    eagle_freq_sums = get_prop_freq_tables(eagle, :CrustDescription, :Topping; sums = true)
    dominos_freq_sums = get_prop_freq_tables(
        dominos, :CrustDescription, :Topping; sums = true
    )

    indep_eagle = ChisqTest(eagle_freq[:freqtable])
    indep_dominos = ChisqTest(dominos_freq[:freqtable])

    printstyled(
        """
#######################################################################
#                   Testy nezávislosti kategorií                      #
#######################################################################
""";
        color = :red
    )
    printstyled(
        """
    # EagleBoys
""";
        color = :cyan
    )
    printstyled("\t\t", eagle_freq_sums[:proportion_freqtable], "\n\n"; color = :blue)
    show(indep_eagle)

    printstyled(
        """\n
    # Dominos
""";
        color = :cyan
    )
    printstyled("\t\t", dominos_freq_sums[:proportion_freqtable], "\n\n"; color = :blue)
    show(indep_dominos)
    return nothing
end # }}}

#' @description
#'
#' Shows hypothesis tests for homogenity of category for subpopulation by stores
function show_store_category_indep_hyp_tests()
    # {{{
    include("./freq_tables.jl")
    crust_freq = get_prop_freq_tables(data, :Store, :Crust)
    top_freq = get_prop_freq_tables(data, :Store, :Top)
    crust_freq_sums = get_prop_freq_tables(data, :Store, :Crust; sums = true)
    top_freq_sums = get_prop_freq_tables(data, :Store, :Top; sums = true)

    homo_crust = ChisqTest(crust_freq[:freqtable])
    homo_top = ChisqTest(top_freq[:freqtable])

    printstyled(
        """
#######################################################################
#                 Testy homogenity firmy a kategorie                  #
#######################################################################
""";
        color = :red
    )

    printstyled(
        """
    # Kůrka
""";
        color = :cyan
    )
    printstyled("\t\t", crust_freq_sums[:proportion_freqtable], "\n\n"; color = :blue)
    show(homo_crust)

    printstyled(
        """\n
    # Přísada
""";
        color = :cyan
    )
    printstyled("\t\t", top_freq_sums[:proportion_freqtable], "\n\n"; color = :blue)
    show(homo_top)
    return nothing
end # }}}

function show_equal_distributions_nonparam_hyp_tests()
    # {{{
    _, eagle, dominos = include("data_preparation.jl")

    get_top(df, top) = @from i in df begin
        @where i.Topping == top
        @select i.Diameter
        @collect
    end

    eagle_hawaiian = get_top(eagle, "Hawaiian")

    eagle_bbq = get_top(eagle, "BBQMeatlovers")

    dominos_hawaiian = get_top(dominos, "Hawaiian")

    dominos_bbq = get_top(dominos, "BBQMeatlovers")

    same_eagle = MannWhitneyUTest(eagle_hawaiian, eagle_bbq)
    same_dominos = MannWhitneyUTest(dominos_hawaiian, dominos_bbq)

    printstyled(
        """
#######################################################################
#       Testy shodnosti distribuce Hawaiian a BBQMeatlovers           #
#######################################################################
""";
        color = :red
    )

    printstyled(
        """
    # Eagle
""";
        color = :cyan
    )
    show(same_eagle)

    printstyled(
        """\n
    # Dominos
""";
        color = :cyan
    )
    show(same_dominos)
end # }}}

function show_normality_hyp_test()
    # {{{
    α = 0.05
    _, eagle, dominos = include("data_preparation.jl")

    get_crust(df, crust) = @from i in df begin
        @where i.CrustDescription == crust
        @select i.Diameter
        @collect
    end

    eagle_data = Dict(i => get_crust(eagle, i) for i in unique(eagle.CrustDescription))
    dominos_data = Dict(i => get_crust(dominos, i) for i in unique(dominos.CrustDescription))

    # NOTE: Make the MLEs of parameters to normal distribution 
    eagle_params = Dict(k => Dict(:var => var(v), :mean => mean(v)) for (k, v) in eagle_data)
    dominos_params = Dict(k => Dict(:var => var(v), :mean => mean(v)) for (k, v) in dominos_data)

    eagle_dists = Dict(k => Normal(v[:mean], v[:var]) for (k, v) in eagle_params)
    dominos_dists = Dict(k => Normal(v[:mean], v[:var]) for (k, v) in dominos_params)

    # NOTE: Data quantization. This does not return right results when some of the borders
    # accidentally fall on the vector values
    function get_bins(vec::Vector; start_bin_count = 10, min_count = 5)::Vector # {{{
        max_v = maximum(vec)
        min_v = minimum(vec)
        start_bins = collect(range(min_v, max_v, start_bin_count))
        bins = start_bins[[1]]
        for v in start_bins
            if count(a -> (bins[end] < a <= v), vec) >= min_count
                append!(bins, v)
            end
        end
        append!(bins, start_bins[end])
        while count(a -> (bins[end] >= a > bins[end-1]), vec) <= min_count
            popat!(bins, length(bins) - 1)
        end
        return bins
    end # }}}

    # TODO: This should work in theory. Add some tests to check.
    function expected_probs(bins, d::Distribution)
        cdfs = cdf.(d, bins)
        return [cdfs[2:end-1]..., 1] .- cdfs[1:end-1]
    end

    get_counts(bins, data::Vector) = [count(v -> s <= v <= e, data) for (s, e) in zip(bins[1:end-1], bins[2:end])]

    function get_chisq_dict(bins, d::Distribution, data::Vector)::Dict
        return Dict(:bins => bins, :expected_counts => expected_probs(bins, d) .* length(data), :true_counts => get_counts(bins, data))
    end

    # TODO: Is the start_bin_count adequate?
    eagle_chisq_data = Dict(k => get_chisq_dict(get_bins(v, start_bin_count = 50, min_count = 5), eagle_dists[k], v) for (k, v) in eagle_data)
    dominos_chisq_data = Dict(k => get_chisq_dict(get_bins(v, start_bin_count = 50, min_count = 5), dominos_dists[k], v) for (k, v) in dominos_data)

    printstyled(
        """
#######################################################################
#                          Testy normality                            #
#######################################################################
""";
        color = :red
    )

    for data in [eagle_chisq_data, dominos_chisq_data]
        printstyled(
            """
            # $(data === eagle_chisq_data ? "EagleBoys" : "Dominos")
    """;
            color = :cyan
        )
        for (k, v) in data
            printstyled(
                """
                    # $k
        """;
                color = :blue
            )

            statistic = sum((tru - exp)^2 / exp for (tru, exp) in zip(v[:true_counts], v[:expected_counts]))
            statistic_dist = Chisq(length(v[:bins]) - 2 - 1)
            crit_value = quantile(statistic_dist, 1 - α)

            "               Test outcome: " * (statistic > crit_value ? "reject h_0" : "accept h_0") * "\n" |> print
    "               p-value:  $(ccdf(statistic_dist, statistic))\n" |> print

        end
    end

    for data in [eagle, dominos]
        printstyled(
            """
            # $(data === eagle ? "EagleBoys" : "Dominos")
    """;
            color = :cyan
        )
        diam_data = data[!,:Diameter]
        bins = get_bins(diam_data, start_bin_count = 1000, min_count = 5)
        dist = Normal(mean(diam_data), var(diam_data))
        chisq_dict = get_chisq_dict(bins,dist, diam_data)

        statistic = sum((tru - exp)^2 / exp for (tru, exp) in zip(chisq_dict[:true_counts],chisq_dict[:expected_counts]))
        statistic_dist = Chisq(length(chisq_dict[:bins]) - 2 - 1)
        crit_value = quantile(statistic_dist, 1 - α)

        "          Test outcome: " * (statistic > crit_value ? "reject h_0" : "accept h_0") * "\n" |> print
"          p-value:  $(ccdf(statistic_dist, statistic))\n" |> print

    end


end # }}}

function show_simple_stats()
    # {{{
    simple_stats = include("simple_stats.jl")

    printstyled(
        """
#######################################################################
#               Deskriptivní statistiky velikosti pizz                #
#######################################################################
""";
        color = :red
    )
    printstyled(
        """
    #  Kategorie  #
""";
        color = :green
    )
    printstyled(
        """
        # EagleBoys
""";
        color = :cyan
    )
    printstyled(
        """
            Základní statistiky podle kůrky:
""";
        color = :blue
    )
    show(simple_stats[:eagle_boys][:CrustDescription])
    printstyled(
        """\n
            Základní statistiky podle přísad:
""";
        color = :blue
    )
    show(simple_stats[:eagle_boys][:Topping])

    printstyled(
        """\n
        # Dominos
""";
        color = :cyan
    )
    printstyled(
        """
            Základní statistiky podle kůrky:
""";
        color = :blue
    )
    show(simple_stats[:dominos][:CrustDescription])
    printstyled(
        """\n
            Základní statistiky podle přísad:
""";
        color = :blue
    )
    show(simple_stats[:dominos][:Topping])

    printstyled(
        """\n\n
    #  Firma  #
""";
        color = :green
    )

    printstyled(
        """
        #  data
""";
        color = :cyan
    )

    return show(simple_stats[:data][:Store])
end # }}}
