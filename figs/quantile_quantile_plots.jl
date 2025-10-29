using StatsPlots, Query, Distributions

_, eagle, dominos = include("../data_preparation.jl")

pgfplotsx()

get_crust(df, crust) = @from i in df begin
    @where i.CrustDescription == crust
    @select i.Diameter
    @collect
end

eagle_cs = Dict(i => get_crust(eagle, i) for i in unique(eagle.CrustDescription))
dominos_cs = Dict(i => get_crust(dominos, i) for i in unique(dominos.CrustDescription))

plot(
    qqplot(
        Normal,
        eagle_cs["MidCrust"];
        title="MidCrust",
        markersize=1,
        marker=:black,
        qqline=:fit,
        titlefontsize=10,
    ),
    qqplot(
        Normal,
        eagle_cs["DeepPan"];
        title="DeepPan",
        markersize=1,
        marker=:black,
        qqline=:fit,
        titlefontsize=10,
    ),
    qqplot(
        Normal,
        eagle_cs["ThinCrust"];
        title="ThinCrust",
        markersize=1,
        marker=:black,
        qqline=:fit,
        titlefontsize=10,
    );
    layout=(1, 3),
    size=(600, 200),
)

fig_path = normpath(dirname(@__FILE__) * "/../report/figs/QQplot_eagle_crusts.tikz")
savefig(fig_path)

plot(
    qqplot(
        Normal,
        dominos_cs["ClassicCrust"];
        title="ClassicCrust",
        markersize=1,
        marker=:black,
        qqline=:fit,
        titlefontsize=10,
    ),
    qqplot(
        Normal,
        dominos_cs["DeepPan"];
        title="DeepPan",
        markersize=1,
        marker=:black,
        qqline=:fit,
        titlefontsize=10,
    ),
    qqplot(
        Normal,
        dominos_cs["ThinNCrispy"];
        title="ThinNCrispy",
        markersize=1,
        marker=:black,
        qqline=:fit,
        titlefontsize=10,
    );
    layout=(1, 3),
    size=(600, 200),
    titlefontsize=10,
)

fig_path = normpath(dirname(@__FILE__) * "/../report/figs/QQplot_dominos_crusts.tikz")
savefig(fig_path)

plot(
    qqplot(
        Normal,
        dominos.Diameter;
        title="Domino's",
        markersize=1,
        marker=:black,
        qqline=:fit,
        titlefontsize=10,
    ),
    qqplot(
        Normal,
        eagle.Diameter;
        title="EagleBoys",
        markersize=1,
        marker=:black,
        qqline=:fit,
        titlefontsize=10,
    );
    size=(600, 300),
)

fig_path = normpath(dirname(@__FILE__) * "/../report/figs/QQplot_stores.tikz")
savefig(fig_path)
