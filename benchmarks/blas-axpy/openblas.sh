#!/bin/bash

# Fix number of OpenBLAS threads
export OMP_NUM_THREADS=1

julia --project=. openblas-axpy.jl
