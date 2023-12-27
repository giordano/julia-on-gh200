# BLAS `axpy` benchmark

`axpy` is a simple level-1
[BLAS](https://en.wikipedia.org/wiki/Basic_Linear_Algebra_Subprograms) routine,
which represents the mathematical operation

$$ \mathbf{y} = a \mathbf{x} + \mathbf{y} $$

where $a$ is a real scalar, and $\mathbf{x}$ and $\mathbf{y}$ are real vectors
of the same length.

`axpy` is a simple and easy to optimise operation, but it can still be useful to
benchmark it, to see whether a compiler can make full use of the CPU resources
already in a simple case.

This directory contains benchmarks comparing a pure-Julia implementation of
`axpy` with some implementations in other BLAS libraries, including
[NVPL](https://developer.nvidia.com/nvpl), the vendor one.
