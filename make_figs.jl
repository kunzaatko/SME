for (dir, dirs, files) in walkdir("figs/")
    for f in files
        include(joinpath([dir, dirs..., f]))
    end
end
