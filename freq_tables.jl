using FreqTables, NamedArrays

(data, eagle, dominos) = include("./data_preparation.jl")

#' @description
#'
#' Concatenates the array with vector of sums in every dimension
function cat_Σ(arr::NamedArray)::NamedArray# {{{
    for i in 1:length(size(arr))
        # NOTE: String. has to be here, because otherwise it is String15 <kunzaatko> #
        names_i = names(arr, i)
        push!(names_i, eltype(names_i)("Σ_" * string(i)))
        arr = cat(arr, sum(arr; dims=i); dims=i)
        setnames!(arr, string.(names_i), i)
    end
    return arr
end # }}}

#' @description
#'
#' Generates the freqtable and the proportion_freqtable with sum vectors
function get_prop_freq_tables( # {{{
    frame,
    cat_1::Symbol,
    cat_2::Symbol,
)
    categories = freqtable(frame, cat_1, cat_2)
    categories_prop = prop(categories)
    for i in 1:length(size(categories_prop))
        setnames!(
            categories_prop,
            map(name -> typeof(name)(string(name) * "_%"), names(categories_prop, i)),
            i,
        )
    end
    return Dict(
        :freqtable => cat_Σ(categories), :proportion_freqtable => cat_Σ(categories_prop)
    )
end # }}}

eagle_freq = get_prop_freq_tables(eagle, :CrustDescription, :Topping)

dominos_freq = get_prop_freq_tables(dominos, :CrustDescription, :Topping)

crust_freq = get_prop_freq_tables(data, :Store, :Crust)

top_freq = get_prop_freq_tables(data, :Store, :Top)

return Dict(
    :eagle_boys => eagle_freq,
    :dominos => dominos_freq,
    :crust => crust_freq,
    :top => top_freq,
)
