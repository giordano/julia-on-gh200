include(joinpath(@__DIR__, "common.jl"))

using LinearAlgebra
const nvpl = "/usr/lib64/libnvpl_blas_ilp64_gomp.so.0.1.0"

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
