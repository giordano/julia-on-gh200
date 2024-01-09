# Julia on Nvidia Grace Hopper GH200

This repo contains some information and benchmarks about using the Julia
programming language on a node of NVIDIA GH200 Grace Hopper Superchip available
at [UCL Centre for Advanced Research
Computing](https://www.ucl.ac.uk/advanced-research-computing).

This is a similar effort to what previously done about running Julia on Fujitsu
A64FX (another ARM CPU) in the following repositories:

* [`giordano/julia-on-fugaku`](https://github.com/giordano/julia-on-fugaku)
* [`giordano/julia-on-ookami`](https://github.com/giordano/julia-on-ookami)

Some relevant documents:

* [NVIDIA GH200 Grace Hopper Superchip datasheet](https://resources.nvidia.com/en-us-grace-cpu/grace-hopper-superchip)
* [NVIDIA GH200 Benchmarking Guide](https://docs.nvidia.com/gh200-benchmarking-guide.pdf)

Note: benchmarks have been run with a Julia installation provided by
[juliaup](https://github.com/JuliaLang/juliaup), which allows managing different
versions of Julia, which is useful for us as we may need specific versions of
Julia for certain benchmarks.
