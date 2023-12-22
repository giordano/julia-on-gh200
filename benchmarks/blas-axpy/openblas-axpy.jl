include(joinpath(@__DIR__, "common.jl"))

using LinearAlgebra

# Make sure we're using OpenBLAS
let
    blases = BLAS.get_config().loaded_libs
    openblas = findfirst(x -> contains(x.libname, "openblas"), blases)
    BLAS.set_num_threads(1)
    @assert isone(BLAS.get_num_threads())
    @assert !isnothing(openblas)
    @assert blases[openblas].interface === :ilp64
end

for T in (Float32, Float64)
    benchmark(BLAS.axpy!, T, "openblas")
end
