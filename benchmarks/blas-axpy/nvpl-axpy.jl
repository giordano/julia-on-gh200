include(joinpath(@__DIR__, "common.jl"))

using LinearAlgebra
using Libdl
const nvpl = find_library("libnvpl_blas_ilp64_gomp.so")

# Make sure we're using NVPL
let
    BLAS.lbt_forward(nvpl; clear=true)
    blases = BLAS.get_config().loaded_libs
    blas = findfirst(x -> contains(x.libname, basename(nvpl)), blases)
    @assert !isnothing(blas)
    @assert blases[blas].interface === :ilp64
end

for T in (Float32, Float64)
    benchmark(BLAS.axpy!, T, "nvpl")
end
