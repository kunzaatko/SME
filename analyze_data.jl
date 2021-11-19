#' @description
#'
#' Shows all the freqtables for the data
function show_freqtables()
    # {{{
    freq_tables = include("./freq_tables.jl")

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
