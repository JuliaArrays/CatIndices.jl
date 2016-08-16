using CatIndices
using Base.Test

### BidirectionalVector

function checkvals(v)
    for i in indices(v,1)
        @test v[i] == i
    end
    nothing
end

v = BidirectionalVector(1:3)
@test indices(v,1) == 1:3
checkvals(v)
@test isa(push!(v, 4), BidirectionalVector)
@test indices(v,1) == 1:4
checkvals(v)
@test isa(append!(v, 5:11), BidirectionalVector)
@test indices(v,1) == 1:11
checkvals(v)
@test pop!(v) == 11
@test indices(v,1) == 1:10
checkvals(v)
@test isa(deletetail!(v, 2), BidirectionalVector)
@test indices(v,1) == 1:8
checkvals(v)
@test shift!(v) == 1
@test indices(v,1) == 2:8
checkvals(v)
@test isa(unshift!(v, 0, 1), BidirectionalVector)
@test isa(unshift!(v, -1), BidirectionalVector)
@test indices(v,1) == -1:8
checkvals(v)
@test isa(prepend!(v, -5:-2), BidirectionalVector)
@test indices(v,1) == -5:8
checkvals(v)
@test isa(deletehead!(v,2), BidirectionalVector)
@test indices(v,1) == -3:8
checkvals(v)

v[0] = 200
@test v[0] == 200

@test indices(similar(v)) === indices(v)
@test indices(similar(v, Float64)) === indices(v)
@test indices(similar(v, Float64, 3)) === (Base.OneTo(3),)
a = similar(Array{Float64}, indices(v))
@test isa(a, BidirectionalVector)
@test indices(a) === indices(v)

### vcat

@test !CatIndices.is_pinned(1:3)
@test CatIndices.is_pinned(PinIndices(1:3))
v = vcat(1:3, PinIndices(4:5), 6:10)
@test indices(v,1) == -2:7
@test_throws ArgumentError vcat(1:3, PinIndices(4:5), PinIndices(6:10))

nothing
