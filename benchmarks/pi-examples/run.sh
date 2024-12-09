#!/bin/bash

julia --threads=auto -L pi.jl -e 'weak_scaling(); strong_scaling()'
