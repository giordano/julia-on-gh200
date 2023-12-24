#!/bin/bash

set -euo pipefail

BABELSTREAM_ROOT=$(julia +1.9 --project=. --startup-file=no -e 'using JuliaStream; print(pkgdir(JuliaStream))')
CUDA_PROJECT="${BABELSTREAM_ROOT}/CUDA"
CUDA_STREAM="${BABELSTREAM_ROOT}/src/CUDAStream.jl"

# Use same number of elements as https://docs.nvidia.com/gh200-benchmarking-guide.pdf
julia +1.9 --project="${CUDA_PROJECT}" "${CUDA_STREAM}" -s 1308622848 | tee output.txt
