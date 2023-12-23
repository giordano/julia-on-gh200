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

# Hack: for small vector sizes, times are subnanoseconds, in the case the bumpt
# them to 32ns, which is what empirically found to be the minimum otherwise.
gflops(n, t) = 2 * n / max(t, 32)

# https://resources.nvidia.com/en-us-grace-cpu/grace-hopper-superchip
l1_size =  64 << 10 #  64 KB
l2_size =   1 << 20 #   1 MB
l3_size = 117 << 20 # 117 MB

function plot_benchmarks(title, julia; type::Union{Nothing,DataType}=nothing)
    p = plot(; title=title, xscale=:log10, xlabel="Vector size", ylabel="GFLOPS",
             xticks=floor.(Int, exp10.(0:9)), yticks=0:5:60, legend=:topleft)
    plot!(p, julia[:, 1], gflops.(julia[:, 1], julia[:, 2]); label="Julia", marker=:circle, markersize=3)
    if !isnothing(type)
        # Lines corresponding to cache sizes.  Remember that there are two
        # vectors involved, hence the factor `2` at the denominator.
        caches = [l1_size, l2_size, l3_size] ./ (2 * sizeof(type))
        vline!(p, caches; label="")
        format(str) = (str, 8, :black, :left)
        annotate!(p, caches[1] * 1.2, 1, format("L1"))
        annotate!(p, caches[2] * 1.2, 1, format("L2"))
        annotate!(p, caches[3] * 1.2, 1, format("L3"))
    end
    return p
end

function plot_benchmarks(title, julia, nvpl, #=blis,=# openblas; type::Union{Nothing,DataType}=nothing)
    p = plot_benchmarks(title, julia; type)
    plot!(p, nvpl[:, 1], gflops.(nvpl[:, 1], nvpl[:, 2]); label="NVPL", marker=:star, markersize=3)
    # plot!(p, blis[:, 1], gflops.(blis[:, 1], blis[:, 2]); label="BLIS", marker=:diamond, markersize=3)
    plot!(p, openblas[:, 1], gflops.(openblas[:, 1], openblas[:, 2]); label="OpenBLAS", marker=:cross, markersize=3)
    # plot!(p, armpl[:, 1], gflops.(armpl[:, 1], armpl[:, 2]); label="ARMPL", marker=:utriangle, markersize=3)
    return p
end

plot_benchmarks("axpy (half precision)", julia_16; type=Float16)
savefig("axpy-half.pdf")
plot_benchmarks("axpy (single precision)", julia_32, nvpl_32, openblas_32, #=blis_32=#; type=Float32)
savefig("axpy-single.pdf")
plot_benchmarks("axpy (double precision)", julia_64, nvpl_64, openblas_64, #=blis_64=#; type=Float64)
savefig("axpy-double.pdf")
