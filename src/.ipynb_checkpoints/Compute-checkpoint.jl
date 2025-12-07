#throw(ErrorException("Oppps! No methods defined in src/Compute.jl. What should you do here?"))
function op(a::Array{T, 1}, b::Array{T,1}) where T <: Number
    matrix = zeros(length(a), length(b));
    for i in 1:length(a)
        for j in 1:length(b)
            matrix[i, j] = a[i]*b[j];
        end
    end
    return matrix
end

function _energy(s::Array{<:Number, 1}, W::Array{<:Number, 2}, b::Array{<:Number, 1})
    E = 0.0;
    for i in 1:length(s)
        for j in 1:length(s)
            E += W[i, j]*s[i]*s[j];
        end
    end
    E *= -1/2;
    for i in 1:length(s)
        E -= b[i]*s[i];
    end
    
    return E  
end

function decode(s::Array{T, 1}) where T <: Number
    vis = zeros(Int32, number_of_rows, number_of_cols);
    index = 1;
    for i in 1:number_of_rows
        for j in 1:number_of_cols
            if s[index] == 1
                vis[i, j] = 1;
            end
            index += 1;
        end
    end
    return vis
end

function recover(model::MyClassicalHopfieldNetworkModel, sₒ::Array{Int32, 1}, true_image_energy::Float32; maxiterations::Int = 1000, patience::Union{Int, Nothing} = nothing, miniterations_before_convergence::Union{Int, Nothing} = nothing)
    W = model.W;
    b = model.b;
    s = copy(sₒ);
    frames = Dict{Int64, Array{Int32, 1}}();
    energydictionary = Dict{Int64, Float32}();
    if isnothing(patience) == true
       patience = 5;
    end
    if isnothing(miniterations_before_convergence) == true
        miniterations_before_convergence = patience;
    end
    Q = Queue{Array{Int32, 1}}();
    converged = false;
    frames[0] = s;
    energydictionary[0] = _energy(s, W, b);
    t = 1;

    while converged == false
        i = rand(1:length(s));
        snew = sign(sum(W[i, :].*s) - b[i]);
        if snew == 0
            if rand() < 0.5
                snew = -1;
            else
                snew = 1;
            end
        end
        s[i] = snew;
        frames[t] = s;
        energydictionary[t] = _energy(s, W, b);
        enqueue!(Q, s);

        if length(Q) == patience && t >= miniterations_before_convergence
            for state1 in Q
                for state2 in Q
                    if hamming(state1, state2) == 0 && state1 != state2
                        converged = true;
                    end
                end
            end
        end
        if energydictionary[t] <= true_image_energy
            converged = true;
            println("Energy lower than true energy.");
        end
        if t >= maxiterations && converged == false
            converged = true;
            println("Maximum iterations reached without convergence.");
        end
        if length(Q) > patience
            dequeue!(Q);
        end
            
        t += 1; 
    end
    return frames, energydictionary
end
    
    
