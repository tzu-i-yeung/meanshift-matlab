function map =  coloring(final_points, threshold)
% Given the final convergence point map, calculate the coloring/clustering
if nargin<2
    threshold = 0.05;
end
map = -1 * ones(size(final_points,2), size(final_points,3));
n_color = 0;
for row = 1:size(map,1)
    for col = 1:size(map,2)
        if map(row,col) < 0
            n_color = n_color + 1;
            mask = wander_explore_multi_channel(final_points, [row, col], threshold);
            map(mask) = n_color;
        end
    end
end

display(n_color);
end