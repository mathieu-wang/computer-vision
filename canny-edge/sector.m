function [zeta, edges] = sector(theta)

sector_values = [0, 1, 1, 2, 2, 3, 3, 0, 0, 1, 1, 2, 2, 3, 3, 0];
binStep = 22.5/180*pi;
edges = -pi:binStep:pi;
[~, edge_columns] = size(edges);
[rows, columns] = size(theta);

zeta = theta;
for i = 1 : rows
    for j = 1 : columns
        value = theta(i, j);
        for k = 1 : edge_columns-1
            if (edges(k) < value && edges(k+1) > value) % find the right interval
                sector_value = sector_values(k); % get sector value from predefined array
                zeta(i, j) = sector_value;                
            end
        end
    end
end
