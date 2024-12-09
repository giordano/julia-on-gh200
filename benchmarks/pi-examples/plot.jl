using Plots, DelimitedFiles

function plot_weak_scaling()
    weak_scaling = readdlm(joinpath(@__DIR__, "weak-scaling.csv"), ',', Float64; skipstart=1)

    nthreads = Int.(weak_scaling[:, 1])

    p = plot(nthreads, weak_scaling[1, 3] ./ weak_scaling[:, 3];
             xticks=(nthreads, string.(nthreads)),
             xscale=:log2,
             xlabel="Number of threads",
             xrotation=90,
             yticks=0.9:0.005:1,
             ylabel="Parallel efficiency",
             marker=:circle,
             markersize=3,
             label="",
             title="Weak scaling of pi example",
             )
    savefig("weak-scaling.pdf")
end

function plot_strong_scaling()
    strong_scaling = readdlm(joinpath(@__DIR__, "strong-scaling.csv"), ',', Float64; skipstart=1)

    nthreads = Int.(strong_scaling[:, 1])

    p = plot(nthreads, strong_scaling[1, 3] ./ strong_scaling[:, 3] ./ nthreads;
             xticks=(nthreads, string.(nthreads)),
             xscale=:log2,
             xlabel="Number of threads",
             xrotation=90,
             yticks=0.9:0.005:1,
             ylabel="Parallel efficiency",
             marker=:circle,
             markersize=3,
             label="",
             title="Strong scaling of pi example",
             )
    savefig("strong-scaling.pdf")
end

plot_weak_scaling()
plot_strong_scaling()
