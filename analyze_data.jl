using HypothesisTests

#' @description
#'
#' Shows all the freqtables for the data
function show_freqtables()
    # {{{
    include("./freq_tables.jl")

    eagle_freq = get_prop_freq_tables(eagle, :CrustDescription, :Topping; sums=true)
    dominos_freq = get_prop_freq_tables(dominos, :CrustDescription, :Topping; sums=true)
    crust_freq = get_prop_freq_tables(data, :Store, :Crust; sums=true)
    top_freq = get_prop_freq_tables(data, :Store, :Top; sums=true)

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
        color=:red,
    )
    printstyled(
        """
    #  Firma  #
""";
        color=:green,
    )
    printstyled(
        """
        # EagleBoys
""";
        color=:cyan,
    )
    printstyled(
        """
            Četnostní tabulka kategorií:
""";
        color=:blue,
    )
    show(freq_tables[:eagle_boys][:freqtable])
    printstyled(
        """\n
            Proporce četností:
""";
        color=:blue,
    )
    show(freq_tables[:eagle_boys][:proportion_freqtable])

    printstyled(
        """\n
        # Dominos
""";
        color=:cyan,
    )

    printstyled(
        """
            Četnostní tabulka kategorií:
""";
        color=:blue,
    )
    show(freq_tables[:dominos][:freqtable])
    printstyled(
        """\n
            Proporce četností:
""";
        color=:blue,
    )
    show(freq_tables[:dominos][:proportion_freqtable])

    printstyled(
        """\n\n
    #  Kategorie  #
""";
        color=:green,
    )

    printstyled(
        """
        # kůrka
""";
        color=:cyan,
    )
    printstyled(
        """
            Četnostní tabulka firem:
""";
        color=:blue,
    )
    show(freq_tables[:crust][:freqtable])
    printstyled(
        """\n
            Proporce četností:
""";
        color=:blue,
    )
    show(freq_tables[:crust][:proportion_freqtable])

    printstyled(
        """\n
        # přísada
""";
        color=:cyan,
    )

    printstyled(
        """
            Četnostní tabulka firem:
""";
        color=:blue,
    )
    show(freq_tables[:top][:freqtable])
    printstyled(
        """\n
            Proporce četností:
""";
        color=:blue,
    )
    return show(freq_tables[:top][:proportion_freqtable])
end # }}}

#' @description
#'
#' Shows hypothesis tests for independence of categories for subpopulations by stores
function show_category_indep_hyp_tests()
    # {{{
    include("./freq_tables.jl")
    eagle_freq = get_prop_freq_tables(eagle, :CrustDescription, :Topping)
    dominos_freq = get_prop_freq_tables(dominos, :CrustDescription, :Topping)
    eagle_freq_sums = get_prop_freq_tables(eagle, :CrustDescription, :Topping; sums=true)
    dominos_freq_sums = get_prop_freq_tables(
        dominos, :CrustDescription, :Topping; sums=true
    )

    indep_eagle = ChisqTest(eagle_freq[:freqtable])
    indep_dominos = ChisqTest(dominos_freq[:freqtable])

    printstyled(
        """
#######################################################################
#                   Testy nezávislosti kategorií                      #
#######################################################################
""";
        color=:red,
    )
    printstyled(
        """
    # EagleBoys
""";
        color=:cyan,
    )
    printstyled("\t\t", eagle_freq_sums[:proportion_freqtable], "\n\n"; color=:blue)
    show(indep_eagle)

    printstyled(
        """\n
    # Dominos
""";
        color=:cyan,
    )
    printstyled("\t\t", dominos_freq_sums[:proportion_freqtable], "\n\n"; color=:blue)
    return show(indep_dominos)
end # }}}

#' @description
#'
#' Shows hypothesis tests for homogenity of category for subpopulation by stores
function show_store_category_indep_hyp_tests()
    # {{{
    include("./freq_tables.jl")
    crust_freq = get_prop_freq_tables(data, :Store, :Crust)
    top_freq = get_prop_freq_tables(data, :Store, :Top)
    crust_freq_sums = get_prop_freq_tables(data, :Store, :Crust; sums=true)
    top_freq_sums = get_prop_freq_tables(data, :Store, :Top; sums=true)

    homo_crust = ChisqTest(crust_freq[:freqtable])
    homo_top = ChisqTest(top_freq[:freqtable])

    printstyled(
        """
#######################################################################
#                 Testy homogenity firmy a kategorie                  #
#######################################################################
""";
        color=:red,
    )

    printstyled(
        """
    # Kůrka
""";
        color=:cyan,
    )
    printstyled("\t\t", crust_freq_sums[:proportion_freqtable], "\n\n"; color=:blue)
    show(homo_crust)

    printstyled(
        """\n
    # Přísada
""";
        color=:cyan,
    )
    printstyled("\t\t", top_freq_sums[:proportion_freqtable], "\n\n"; color=:blue)
    return show(homo_top)
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
        color=:red,
    )
    printstyled(
        """
    #  Kategorie  #
""";
        color=:green,
    )
    printstyled(
        """
        # EagleBoys
""";
        color=:cyan,
    )
    printstyled(
        """
            Základní statistiky podle kůrky:
""";
        color=:blue,
    )
    show(simple_stats[:eagle_boys][:CrustDescription])
    printstyled(
        """\n
            Základní statistiky podle přísad:
""";
        color=:blue,
    )
    show(simple_stats[:eagle_boys][:Topping])

    printstyled(
        """\n
        # Dominos
""";
        color=:cyan,
    )
    printstyled(
        """
            Základní statistiky podle kůrky:
""";
        color=:blue,
    )
    show(simple_stats[:dominos][:CrustDescription])
    printstyled(
        """\n
            Základní statistiky podle přísad:
""";
        color=:blue,
    )
    show(simple_stats[:dominos][:Topping])

    printstyled(
        """\n\n
    #  Firma  #
""";
        color=:green,
    )

    printstyled(
        """
        #  data
""";
        color=:cyan,
    )

    return show(simple_stats[:data][:Store])
end # }}}
