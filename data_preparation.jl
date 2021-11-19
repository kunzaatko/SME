using CSV, DataFrames, Unitful, Query

# Declaring that the Diameter column is in centimeters... This will be usefull testing the hypothesis where the diameter is in inches
data = DataFrame(
    @mutate(Diameter_cm = _.Diameter * 1u"cm")(CSV.read("./data/pizzasize.csv", DataFrame))
)

# Creating a column for diameter in inches
data[!, :Diameter_inch] = uconvert.(u"inch", data[!, :Diameter_cm])
for col in [:CrustDescription, :Topping, :Store]
    data[!, col] = convert.(String, data[!, col])
end

#' @description
#'
#' Renames the crust category of the pizzas
#'
#' @param crust original crust
#'
#' @returns renamed_crust::String renamed version of the crust
rename_crust = function (crust)
    if crust in ["ThinNCrispy", "ThinCrust"]
        "Thin"
    else
        crust in ["MidCrust", "ClassicCrust"] ? "Mid" : crust
    end
end

insertcols!(data, 4, :Crust => Symbol.(rename_crust.(data[!, :CrustDescription])))

#' @description
#'
#' Renames the topping property of the pizzas
#'
#' @param topping original topping
#'
#' @returns renamed_topping::String renamed version of the topping
rename_topping = function (topping)
    return topping in ["SuperSupremo", "Supreme"] ? "Supreme" : topping
end

insertcols!(data, 6, :Top => Symbol.(rename_topping.(data[!, :Topping])))

# reordering columns in data
data = data[
    !,
    [
        :ID,
        :Store,
        :Crust,
        :Top,
        :Diameter,
        :Diameter_cm,
        :Diameter_inch,
        :CrustDescription,
        :Topping,
    ],
]

# Choosing only EagleBoys datapoints
eagle = @from i in data begin
    @where i.Store == "EagleBoys"
    @select i
    @collect DataFrame
end

# Choosing only Dominos datapoints
dominos = @from i in data begin
    @where i.Store == "Dominos"
    @select i
    @collect DataFrame
end

(data, eagle, dominos)
