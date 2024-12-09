using Plots, DelimitedFiles

function plot_strong_scaling()
    strong_scaling = readdlm(joinpath(@__DIR__, "hexadecimal-pi.csv"), ',', Float64; skipstart=1)

    nthreads = Int.(strong_scaling[:, 1])

    p = plot(nthreads, strong_scaling[1, 3] ./ strong_scaling[:, 3] ./ nthreads;
             xticks=(nthreads, string.(nthreads)),
             xscale=:log2,
             xlabel="Number of threads",
             xrotation=90,
             yticks=0.9:0.002:1,
             ylabel="Parallel efficiency",
             marker=:circle,
             markersize=3,
             label="",
             title="Strong scaling of hexadecimal pi",
             )
    savefig("strong-scaling.pdf")
end

plot_strong_scaling()
