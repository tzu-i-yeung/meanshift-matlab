function [ out_map ] = recoloring( colormap )
%RECOLORING recolor the colormap so that each color is used at least once

out_map = colormap;
max_color = max(max(out_map));
current_color = 1;
while current_color < max_color
    if sum(sum(out_map == current_color)) == 0
       out_map(out_map==max_color) = current_color;
       max_color = max(max(out_map));
    end
    current_color = current_color+1;
end


end

