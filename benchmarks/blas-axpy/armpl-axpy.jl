include(joinpath(@__DIR__, "common.jl"))

using LinearAlgebra
using CompilerSupportLibraries_jll
using Libdl
const armpl = find_library("libarmpl_int64.so")

# Make sure we're using ARMPL
let
    BLAS.lbt_forward(armpl; clear=true)
    blases = BLAS.get_config().loaded_libs
    blas = findfirst(x -> contains(x.libname, basename(armpl)), blases)
    @assert !isnothing(blas)
    @assert blases[blas].interface === :ilp64
end

for T in (Float32, Float64)
    benchmark(BLAS.axpy!, T, "armpl")
end
