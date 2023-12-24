#!/bin/bash

julia --project=. -e 'using CUDA; include(joinpath(pkgdir(CUDA), "examples", "peakflops.jl"))' > output.txt
