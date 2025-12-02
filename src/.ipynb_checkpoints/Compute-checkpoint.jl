#throw(ErrorException("Oppps! No methods defined in src/Compute.jl. What should you do here?"))
function decode(s::Array{T, 1}) where T <: Number
    vis = zeros(Int32, number_of_rows, number_of_cols);
    index = 1;
    for i in 1:number_of_rows
        for j in 1:number_of_cols
            if s[index] == -1
                vis[i, j] = 0;
            else
                vis[i, j] = 1;
            end
            index += 1;
        end
    end
    return vis
end
    
    
