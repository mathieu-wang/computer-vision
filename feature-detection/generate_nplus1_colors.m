function colors = generate_nplus1_colors(n)
    colors = zeros([n+1 3]);
    for i = 1:n
        interval = 3/n;
        progress = i * interval;
        if progress > 2
            colors(i, 1) = progress - 2;
            colors(i, 2) = 1;
            colors(i, 3) = 1;
        elseif progress > 1
            colors(i, 1) = 0;
            colors(i, 2) = progress - 1;
            colors(i, 3) = 1;
        else
            colors(i, 1) = 0;
            colors(i, 2) = 0;
            colors(i, 3) = progress;
        end
    end
    colors(n+1,:) = [0 0 0];