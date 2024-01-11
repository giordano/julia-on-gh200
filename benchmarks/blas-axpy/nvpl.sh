#!/bin/bash

# Fix number of threads
export OMP_NUM_THREADS=1

julia --project=. nvpl-axpy.jl
