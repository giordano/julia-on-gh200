#!/bin/bash

set -euo pipefail

BABELSTREAM_ROOT=$(julia +1.9 --project=. --startup-file=no -e 'using JuliaStream; print(pkgdir(JuliaStream))')
CUDA_PROJECT="${BABELSTREAM_ROOT}/CUDA"
CUDA_STREAM="${BABELSTREAM_ROOT}/src/CUDAStream.jl"
THREADED_PROJECT="${BABELSTREAM_ROOT}/Threaded"
PLAIN_STREAM="${BABELSTREAM_ROOT}/src/PlainStream.jl"
THREADED_STREAM="${BABELSTREAM_ROOT}/src/ThreadedStream.jl"

# Use same number of elements as https://docs.nvidia.com/gh200-benchmarking-guide.pdf
julia +1.9 --startup-file=no --project="${CUDA_PROJECT}" "${CUDA_STREAM}" -s 1308622848 | tee output.txt
# julia +1.9 --startup-file=no --project="${THREADED_PROJECT}" "${PLAIN_STREAM}" | tee -a output.txt
# julia +1.9 --startup-file=no -t 72 --project="${THREADED_PROJECT}" "${PLAIN_STREAM}" -s 120000000 | tee -a output.txt
