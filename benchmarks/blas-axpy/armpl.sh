#!/bin/bash

# Fix number of threads
export OMP_NUM_THREADS=1

# ARMPL currently requires you to set `LD_LIBRARY_PATH` to load the libraries.
export LD_LIBRARY_PATH="${HOME}/armpl/arm-performance-libraries_23.10_RHEL-9/opt/arm/armpl_23.10_gcc-11.3/lib"
julia --project=. armpl-axpy.jl
