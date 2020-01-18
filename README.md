# CatIndices

[![Build Status](https://travis-ci.org/JuliaArrays/CatIndices.jl.svg?branch=master)](https://travis-ci.org/JuliaArrays/CatIndices.jl)
[![codecov.io](http://codecov.io/github/JuliaArrays/CatIndices.jl/coverage.svg?branch=master)](http://codecov.io/github/JuliaArrays/CatIndices.jl?branch=master)
[![PkgEval][pkgeval-img]][pkgeval-url]

A Julia package for concatenating, growing, and shrinking arrays in
ways that allow control over the resulting axes.

# Usage

## BidirectionalVector

These vectors can grow or shrink from either end, and the axes
update correspondingly. In this demo, pay careful attention to the
axes at each step:

```julia
julia> using CatIndices

julia> v = BidirectionalVector(rand(3))
CatIndices.BidirectionalVector{Float64} with indices CatIndices.URange(1,3):
 0.32572
 0.250426
 0.834728

julia> append!(v, rand(2))
CatIndices.BidirectionalVector{Float64} with indices CatIndices.URange(1,5):
 0.32572
 0.250426
 0.834728
 0.388788
 0.282573

julia> prepend!(v, rand(3))
CatIndices.BidirectionalVector{Float64} with indices CatIndices.URange(-2,5):
 0.992902
 0.849368
 0.189849
 0.32572
 0.250426
 0.834728
 0.388788
 0.282573

julia> pop!(v)
0.28257294456774673

julia> axes(v)
(CatIndices.URange(-2,4),)

julia> popfirst!(v)
0.9929020233076613

julia> axes(v)
(CatIndices.URange(-1,4),)
```

`deleteat!` and `insert!` are not supported, since it is unclear
whether it should shrink/grow from the beginning or end.  To eliminate
many items at the beginning or end of the vector, this package exports
`deletehead!(v, n)` and `deletetail!(v, n)`.

# Concatenation

This is still mostly a TODO. For one-dimensional arrays (`AbstractVector`s),
`PinIndices` provides a convenient interface for specifying which indices "win":

```julia
julia> v = vcat(1:3, PinIndices(4:5), 6:10)
10-element OffsetArray(::Array{Int64,1}, -2:7) with eltype Int64 with indices -2:7:
  1
  2
  3
  4
  5
  6
  7
  8
  9
 10

julia> v[1]
4
```

The array wrapped in `PinIndices` keeps its own indexes, and everything else adjusts to compensate.

[pkgeval-img]: https://juliaci.github.io/NanosoldierReports/pkgeval_badges/C/CatIndices.svg
[pkgeval-url]: https://juliaci.github.io/NanosoldierReports/pkgeval_badges/report.html
