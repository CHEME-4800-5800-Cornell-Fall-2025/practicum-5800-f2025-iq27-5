#throw(ErrorException("Oppps! No methods defined in src/Factory.jl. What should you do here?"))
function build(modeltype::Type{MyClassicalHopfieldNetworkModel}, data::NamedTuple)

    model = modeltype();
    memories = data.memories;
    nrows, ncols = size(memories);
    W = zeros(Float32, nrows, nrows);
    b = zeros(Float32, nrows);

    for j in 1:ncols
        W += op(memories[:, j], memories[:, j]);
    end
    for i in 1:nrows
        W[i, i] = 0.0f0;
    end
    W = W/ncols;

    energy = Dict{Int64, Float32}();
    for j in 1:ncols
        energy[j] = _energy(memories[:, j], W, b);
    end

    model.W = W;
    model.b = b;
    model.energy = energy;
    
    return model;
end
    