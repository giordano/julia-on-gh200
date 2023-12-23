#!/bin/bash

julia --project=. --threads=72 bench.jl &> output.txt
