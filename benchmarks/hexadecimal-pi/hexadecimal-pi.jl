using Base.Threads: @spawn, nthreads
using ThreadPinning: pinthreads

pinthreads(:cores)

# Return the fractional part of x, modulo 1, always positive
fpart(x) = mod(x, one(x))

function Σ(n, j)
    # Compute the finite sum
    s = 0.0
    denom = j
    for k in 0:n
        s = fpart(s + powermod(16, n - k, denom) / denom)
        denom += 8
    end
    # Compute the infinite sum
    num = 1 / 16
    while (frac = num / denom) > eps(s)
        s     += frac
        num   /= 16
        denom += 8
    end
    return fpart(s)
end

pi_digit(n) =
    floor(Int, 16 * fpart(4Σ(n-1, 1) - 2Σ(n-1, 4) - Σ(n-1, 5) - Σ(n-1, 6)))

function pi_string_tasks!(digits::Vector{Int}, tasks::Vector{Task}, N::Int)
    for n in eachindex(tasks)
        @inbounds tasks[n] = @spawn pi_digit(n)
    end
    digits .= fetch.(tasks)
end

function pi_string_tasks(N::Int)
    # Preallocate vectors to be used by the compute function
    tasks = Vector{Task}(undef, N)
    digits = Vector{Int}(undef, N)
    # Run the function and measure the elapsed time
    elapsed = @elapsed pi_string_tasks!(digits, tasks, N)
    return digits, elapsed
end

function main()
    pi_string_tasks(100)

    N = parse(Int, ARGS[1])
    open(joinpath(@__DIR__, "hexadecimal-pi.csv"), "a") do file
        digits, elapsed = pi_string_tasks(N)
        # Make sure the result is correct
        pi_string = "0x3." * join(string.(digits, base = 16)) * "p0"
        @assert parse(Float64, pi_string) ≈ pi
        # Print timings to screen
        @show nthreads(), N, elapsed
        # Write timings to the CSV file
        println(file, nthreads(), ",", N, ",", elapsed)
    end
end

main()
