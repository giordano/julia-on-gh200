#!/usr/bin/env julia

using LinearAlgebra: BLAS, peakflops

open(joinpath(@__DIR__, "peakflops.csv"), "w") do file
    println(file, "# threads, N, FLOPS")

    for nthreads in (1, 2, 4, 8, 9, 16, 18, 32, 36, 64, 72)
        BLAS.set_num_threads(nthreads)
        # Make sure the setting was effective
        @assert BLAS.get_num_threads() == nthreads

        N = 2 ^ 13
        @time flops = peakflops(N)

        @show nthreads, N, flops
        println(file, nthreads, ",", N, ",", flops)
    end
end
