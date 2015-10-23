function [idx, closestCenter] = find_closest_center(v, C)
    idx = 0;
    closestCenter = C(1, :);
    minDist = realmax('single');
    [C_row, C_col] = size(C);
    for i = 1:C_row
        c = C(i, :);
        sum = 0;
        for j = 1:C_col
            sum = sum + (v(j) - c(j))^2;
        end
        if sum < minDist
            minDist = sum;
            closestCenter = C(i, :);
            idx = i;
        end
    end
    
          
        