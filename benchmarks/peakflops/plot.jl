using Plots, DelimitedFiles

function plot_strong_scaling()
    strong_scaling = readdlm(joinpath(@__DIR__, "peakflops.csv"), ',', Float64; skipstart=1)

    nthreads = Int.(strong_scaling[:, 1])
    @assert allequal(strong_scaling[:, 2])
    N = Int(strong_scaling[1, 2])

    p = plot(nthreads, strong_scaling[1, 3] .\ strong_scaling[:, 3] ./ nthreads;
             xticks=(nthreads, string.(nthreads)),
             xscale=:log2,
             xrotation=90,
             xlabel="Number of threads",
             ylabel="Parallel efficiency",
             marker=:circle,
             markersize=3,
             label="",
             title="Strong scaling of OpenBLAS $(N) x $(N) DGEMM",
             )
    savefig("gemm-strong-scaling.pdf")
end

plot_strong_scaling()
