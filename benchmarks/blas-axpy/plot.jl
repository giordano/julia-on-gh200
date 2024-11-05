using Plots, DelimitedFiles

julia_16 = readdlm(joinpath(@__DIR__, "julia_Float16.csv"), ',', Float64; skipstart=1)
julia_32 = readdlm(joinpath(@__DIR__, "julia_Float32.csv"), ',', Float64; skipstart=1)
nvpl_32 = readdlm(joinpath(@__DIR__, "nvpl_Float32.csv"), ',', Float64; skipstart=1)
# blis_32 = readdlm(joinpath(@__DIR__, "blis_Float32.csv"), ',', Float64; skipstart=1)
armpl_32 = readdlm(joinpath(@__DIR__, "armpl_Float32.csv"), ',', Float64; skipstart=1)
openblas_32 = readdlm(joinpath(@__DIR__, "openblas_Float32.csv"), ',', Float64; skipstart=1)
julia_64 = readdlm(joinpath(@__DIR__, "julia_Float64.csv"), ',', Float64; skipstart=1)
nvpl_64 = readdlm(joinpath(@__DIR__, "nvpl_Float64.csv"), ',', Float64; skipstart=1)
# blis_64 = readdlm(joinpath(@__DIR__, "blis_Float64.csv"), ',', Float64; skipstart=1)
armpl_64 = readdlm(joinpath(@__DIR__, "armpl_Float64.csv"), ',', Float64; skipstart=1)
openblas_64 = readdlm(joinpath(@__DIR__, "openblas_Float64.csv"), ',', Float64; skipstart=1)

# Hack: for small vector sizes, times are unreliable subnanoseconds, in the case we bump
# them to 32ns, which is what empirically found to be the minimum otherwise.
gflops(n::Float64, t::Float64) = 2 * n / max(t, 32)
gflops(m::Matrix{Float64}) = gflops.(m[:, 1], m[:, 2])

# https://resources.nvidia.com/en-us-grace-cpu/grace-hopper-superchip
l1_size =  64 << 10 #  64 KiB
l2_size =   1 << 20 #   1 MiB
l3_size = 114 << 20 # 114 MiB (hwloc says L3 is 114 MiB, not 117 as written in the datasheet)
linewidth = 2

function plot_benchmarks(title, julia; type::Union{Nothing,DataType}=nothing)
    p = plot() # if you want it to be wider: plot(; size=(600,300))
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
    plot!(p; title=title, xscale=:log10, xlabel="Vector size", ylabel="GFLOPS",
             xticks=floor.(Int, exp10.(0:9)), yticks=0:5:60, legend=:topleft, linewidth)
    plot!(p, julia[:, 1], gflops(julia); label="Julia", marker=:circle, markersize=3, linewidth)
    return p
end

function plot_benchmarks(title, julia, nvpl, openblas, armpl; type::Union{Nothing,DataType}=nothing)
    p = plot_benchmarks(title, julia; type)
    plot!(p, nvpl[:, 1], gflops(nvpl); label="NVPL", marker=:star, markersize=3, linewidth)
    # plot!(p, blis[:, 1], gflops(blis); label="BLIS", marker=:diamond, markersize=3)
    plot!(p, openblas[:, 1], gflops(openblas); label="OpenBLAS", marker=:cross, markersize=3, linewidth)
    plot!(p, armpl[:, 1], gflops(armpl); label="ARMPL", marker=:utriangle, markersize=3, linewidth)
    return p
end

plot_benchmarks("axpy (half precision)", julia_16; type=Float16)
savefig("axpy-half.pdf")
plot_benchmarks("axpy (single precision)", julia_32, nvpl_32, openblas_32, armpl_32; type=Float32)
savefig("axpy-single.pdf")
plot_benchmarks("axpy (double precision)", julia_64, nvpl_64, openblas_64, armpl_64; type=Float64)
savefig("axpy-double.pdf")
