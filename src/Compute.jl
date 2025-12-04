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
    
    
