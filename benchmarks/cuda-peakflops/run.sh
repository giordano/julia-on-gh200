#!/bin/bash

julia --startup-file=no --project=. -e 'using CUDA; include(joinpath(pkgdir(CUDA), "examples", "peakflops.jl"))' | tee output.txt
