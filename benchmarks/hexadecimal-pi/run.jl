#!/usr/bin/env julia

open("hexadecimal-pi.csv", "w") do file
    println(file, "# threads, number of digits, elapsed time (seconds)")
end

# We can't change the number of julia threads at runtime, so we have to spawn a
# separate process for each value of nthreads.
for nthreads in (1, 2, 3, 4, 8, 9, 16, 18, 32, 36, 64, 72)
    run(`$(Base.julia_cmd()) --project=$(@__DIR__) --threads=$(nthreads) hexadecimal-pi.jl 10000`)
end
