#!/bin/bash

julia --startup-file=no --project=. --threads=72 bench.jl | tee output.txt
