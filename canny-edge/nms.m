function N = nms(M, zeta)

[M_row, M_col] = size(M);
for i = 1:M_row
    for j = 1:M_col
        center_value = M(i, j);
        sector = zeta(i, j);
        neighbor1 = 0;
        neighbor2 = 0;
        if sector == 0
            if j > 1
                neighbor1 = M(i, j-1);
            end
            if j < M_col
                neighbor2 = M(i, j+1);
            end
        elseif sector == 1
            if i < M_row && j > 1
                neighbor1 = M(i+1, j-1);
            end
            if i > 1 && j < M_col
                neighbor2 = M(i-1, j+1);
            end
        elseif sector == 2
            if i < M_row
                neighbor1 = M(i+1, j);
            end
            if i > 1
                neighbor1 = M(i-1, j);
            end
        else
            if i < M_row && j < M_col
                neighbor1 = M(i+1, j+1);
            end
            if i > 1 && j > 1
                neighbor2 = M(i-1, j-1);
            end
        end

        if neighbor1 >= center_value || neighbor2 >= center_value
            M(i, j) = 0;
        end
    end
end
N = M;