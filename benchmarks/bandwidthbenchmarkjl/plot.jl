using CSV
using DataFrames
using StatsPlots
using Plots

bwscaling = CSV.read(joinpath(@__DIR__, "bwscaling.csv"), DataFrame)
bwscaling_memdomains = CSV.read(joinpath(@__DIR__, "bwscaling_memdomain.csv"), DataFrame)
flopsscaling = CSV.read(joinpath(@__DIR__, "flopsscaling.csv"), DataFrame)
latencies = CSV.read(joinpath(@__DIR__, "core2core_latency.csv"), DataFrame)

function plot_scaling(df, title, ylabel, column)
    plot(df[:, 1], df[:, column] ./ 1000;
         title,
         xlabel="Number of threads",
         xticks=0:4:72,
         ylabel,
         marker=:circle,
         markersize=3,
         label="",
         )
end

function plot_memdomains_scaling(results::DataFrame, kernel::String)
    df = subset(results, :Function => x -> x .== kernel)
    @df df plot(:var"# Threads per domain", :var"Rate (MB/s)" ./ 1000;
                group=(:var"# Memory domains"),
                legend=:topleft,
                title="Memory Bandwidth Scaling for $(kernel)",
                xlabel="Number of cores per memory domain",
                xticks=0:4:maximum(:var"# Threads per domain"),
                ylabel="Memory Bandwidth [GB/s]",
                label="",
                marker=:circle,
                markersize=3,
                )
end

for (idx, kernel) in enumerate(("Init", "Copy", "Update", "Triad", "Daxpy", "STriad", "SDaxpy"))
    plot_scaling(bwscaling, "Memory Bandwidth Scaling for $(kernel)", "Bandwidth (GB/s)", idx+1)
    savefig(joinpath(@__DIR__, "bwscaling-$(lowercase(kernel)).pdf"))
    plot_memdomains_scaling(bwscaling_memdomains, kernel)
    savefig(joinpath(@__DIR__, "bwscaling-memdomain-$(lowercase(kernel)).pdf"))
end
plot_scaling(flopsscaling, "FLOPS Scaling", "Triad Performance (GFlop/s)", 2)
savefig(joinpath(@__DIR__, "flopsscaling.pdf"))
heatmap(Matrix(latencies); c=:viridis, frame=:box)
savefig(joinpath(@__DIR__, "core2core_latency.pdf"))
