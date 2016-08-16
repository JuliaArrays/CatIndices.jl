using CustomUnitRanges
include(CustomUnitRanges.filename_for_urange)  # defines URange

type BidirectionalVector{T} <: AbstractVector{T}
    data::Vector{T}
    offset::Int
end
BidirectionalVector{T}(v::AbstractVector{T}, inds::AbstractUnitRange) =
    BidirectionalVector(copyelts(v), first(inds)-1)
BidirectionalVector(v::AbstractVector) = BidirectionalVector(v, Base.indices1(v))

# copies but doesn't preserve the indices
function copyelts{T}(v::AbstractVector{T})
    inds = Base.indices1(v)
    n = length(inds)
    dest = Array{T}(n)
    for (vel, j) in zip(v, 1:n)
        dest[j] = vel
    end
    dest
end

# Don't implement size or length
Base.indices1(v::BidirectionalVector) = URange(1+v.offset, length(v.data)+v.offset)
Base.indices( v::BidirectionalVector) = (Base.indices1(v),)

function Base.similar(v::AbstractArray, T::Type, inds::Tuple{URange})
    inds1 = inds[1]
    n = length(inds1)
    BidirectionalVector(Array{T}(n), first(inds1)-1)
end

function Base.similar(f::Union{Function,DataType}, inds::Tuple{URange})
    inds1 = inds[1]
    n = length(inds1)
    BidirectionalVector(f(Base.OneTo(n)), first(inds1)-1)
end

@inline function Base.getindex(v::BidirectionalVector, i::Int)
    @boundscheck checkbounds(v, i)
    @inbounds ret = v.data[i-v.offset]
    ret
end

@inline function Base.setindex!(v::BidirectionalVector, val, i::Int)
    @boundscheck checkbounds(v, i)
    @inbounds v.data[i-v.offset] = val
    val
end

Base.push!(v::BidirectionalVector, x) = (push!(v.data, x); v)
Base.pop!(v::BidirectionalVector) = pop!(v.data)
Base.append!(v::BidirectionalVector, collection2) = (append!(v.data, collection2); v)
function Base.prepend!(v::BidirectionalVector, collection2)
    v.offset -= _length(collection2)
    prepend!(v.data, collection2)
    v
end
function Base.shift!(v::BidirectionalVector)
    v.offset += 1
    shift!(v.data)
end
function Base.unshift!(v::BidirectionalVector, x)
    v.offset -= 1
    unshift!(v.data, x)
    v
end
@inline function Base.unshift!(v::BidirectionalVector, y...)
    v.offset -= length(y)
    unshift!(v.data, y...)
    v
end


function deletetail!(v::BidirectionalVector, n::Integer)
    deleteat!(v.data, length(v.data)-n+1:length(v.data))
    v
end
function deletehead!(v::BidirectionalVector, n::Integer)
    v.offset += n
    deleteat!(v.data, 1:n)
    v
end

_length(a::AbstractArray) = length(linearindices(a))
_length(t) = length(t)