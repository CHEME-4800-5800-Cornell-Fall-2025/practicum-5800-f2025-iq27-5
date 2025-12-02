#throw(ErrorException("Oppps! No methods defined in src/Types.jl. What should you do here?"))
mutable struct MyClassicalHopfieldNetworkModel <: AbstractHopfieldNetworkModel
    W::Array{<:Number, 2}
    b::Array{<:Number, 1}
    energy::Dict{Int64, Float32}

    MyClassicalHopfieldNetworkModel() = new();
end