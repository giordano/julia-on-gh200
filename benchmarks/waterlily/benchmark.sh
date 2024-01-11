#!/bin/bash

set -e

rm -f jelly.txt jelly_*.json tgv.txt tgv_*.json

# Get Waterlily root directory
WATERLILY_ROOT=$(julia --project=. --startup-file=no -e 'using WaterLily; print(pkgdir(WaterLily))')

# Run the benchmarks.  jelly only up to log2p=7 because the case log2p=8 is superslow on CPU
"${WATERLILY_ROOT}/benchmark/benchmark.sh"  -v "1.10" -t "12 24 36 48 60 72" -b "Array CuArray" -c "tgv jelly" -p "5,6,7,8 5,6,7" -s "100 100" -ft "Float32 Float32"

# Save the outputs
julia --project "${WATERLILY_ROOT}/benchmark/compare.jl" $(find . -name "tgv*.json" -printf "%T@ %Tc %p\n" | sort -n | awk '{print $8}')   | tee tgv.txt
julia --project "${WATERLILY_ROOT}/benchmark/compare.jl" $(find . -name "jelly*.json" -printf "%T@ %Tc %p\n" | sort -n | awk '{print $8}') | tee jelly.txt
