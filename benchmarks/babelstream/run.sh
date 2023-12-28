#!/bin/bash

set -euo pipefail

BABELSTREAM_ROOT=$(julia +1.9 --project=. --startup-file=no -e 'using JuliaStream; print(pkgdir(JuliaStream))')
CUDA_PROJECT="${BABELSTREAM_ROOT}/CUDA"
CUDA_STREAM="${BABELSTREAM_ROOT}/src/CUDAStream.jl"
THREADED_PROJECT="${BABELSTREAM_ROOT}/Threaded"
PLAIN_STREAM="${BABELSTREAM_ROOT}/src/PlainStream.jl"
THREADED_STREAM="${BABELSTREAM_ROOT}/src/ThreadedStream.jl"

# The GPU has 95.6 GiB of memory.  Same number of elements for the benchmark as
# https://docs.nvidia.com/gh200-benchmarking-guide.pdf would be 10468982784 (= 1308622848 *
# 8), but babelstream would allocate also other arrays during the program, which don't fit
# in memory, maximum we can do is 3925868544 elements, for a single array of ~31.4 GiB, and
# total memory during the program of 94.2 GiB.
julia +1.9 --startup-file=no --project="${CUDA_PROJECT}" "${CUDA_STREAM}" -s 3925868544 | tee output.txt
# julia +1.9 --startup-file=no --project="${THREADED_PROJECT}" "${PLAIN_STREAM}" | tee -a output.txt
# julia +1.9 --startup-file=no -t 72 --project="${THREADED_PROJECT}" "${PLAIN_STREAM}" -s 120000000 | tee -a output.txt
