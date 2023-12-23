using Plots, DelimitedFiles

julia_16 = readdlm(joinpath(@__DIR__, "julia_Float16.csv"), ',', Float64; skipstart=1)
julia_32 = readdlm(joinpath(@__DIR__, "julia_Float32.csv"), ',', Float64; skipstart=1)
nvpl_32 = readdlm(joinpath(@__DIR__, "nvpl_Float32.csv"), ',', Float64; skipstart=1)
# blis_32 = readdlm(joinpath(@__DIR__, "blis_Float32.csv"), ',', Float64; skipstart=1)
# armpl_32 = readdlm(joinpath(@__DIR__, "armpl_Float32.csv"), ',', Float64; skipstart=1)
openblas_32 = readdlm(joinpath(@__DIR__, "openblas_Float32.csv"), ',', Float64; skipstart=1)
julia_64 = readdlm(joinpath(@__DIR__, "julia_Float64.csv"), ',', Float64; skipstart=1)
nvpl_64 = readdlm(joinpath(@__DIR__, "nvpl_Float64.csv"), ',', Float64; skipstart=1)
# blis_64 = readdlm(joinpath(@__DIR__, "blis_Float64.csv"), ',', Float64; skipstart=1)
# armpl_64 = readdlm(joinpath(@__DIR__, "armpl_Float64.csv"), ',', Float64; skipstart=1)
openblas_64 = readdlm(joinpath(@__DIR__, "openblas_Float64.csv"), ',', Float64; skipstart=1)

gflops(n, t) = 2 * n / t

function plot_benchmarks(title, julia)
    p = plot(; title=title, xscale=:log10, xlabel="Vector size", ylabel="GFLOPS",
             xticks=floor.(Int, exp10.(0:9)), yticks=0:2.5:40, legend=:topleft)
    plot!(p, julia[:, 1], gflops.(julia[:, 1], julia[:, 3]); label="Julia", marker=:auto, markersize=3)
    return p
end

function plot_benchmarks_no_armpl(title, julia, nvpl, #=blis,=# openblas)
    p = plot_benchmarks(title, julia)
    plot!(p, nvpl[:, 1], gflops.(nvpl[:, 1], nvpl[:, 3]); label="NVPL", marker=:auto, markersize=3)
    # plot!(p, blis[:, 1], gflops.(blis[:, 1], blis[:, 3]); label="BLIS", marker=:auto, markersize=3)
    plot!(p, openblas[:, 1], gflops.(openblas[:, 1], openblas[:, 3]); label="OpenBLAS", marker=:auto, markersize=3)
    return p
end

function plot_benchmarks(title, julia, nvpl, #=blis,=# openblas, armpl)
    p = plot_benchmarks_no_armpl(title, julia, nvpl, blis, openblas)
    plot!(p, armpl[:, 1], gflops.(armpl[:, 1], armpl[:, 3]); label="ARMPL", marker=:auto, markersize=3)
    return p
end

plot_benchmarks("axpy (half precision)", julia_16)
savefig("axpy-half.pdf")
# plot_benchmarks("axpy (single precision)", julia_32, nvpl_32, #=blis_32,=# openblas_32, armpl_32)
# savefig("axpy-single.pdf")
# plot_benchmarks("axpy (double precision)", julia_64, nvpl_64, #=blis_64,=# openblas_64, armpl_64)
# savefig("axpy-double.pdf")
plot_benchmarks_no_armpl("axpy (single precision)", julia_32, nvpl_32, openblas_32, #=blis_32=#)
savefig("axpy-single.pdf")
plot_benchmarks_no_armpl("axpy (double precision)", julia_64, nvpl_64, openblas_64, #=blis_64=#)
savefig("axpy-double.pdf")
