kelly_colors = {'F2F3F4', '222222', 'F3C300', '875692', 'F38400', 'A1CAF1', 'BE0032', 'C2B280', '848482', '008856', 'E68FAC', '0067A5', 'F99379', '604E97', 'F6A600', 'B3446C', 'DCD300', '882D17', '8DB600', '654522', 'E25822', '2B3D26'};
kelly_rgb = zeros(length(kelly_colors), 3);
for k = 1:size(kelly_colors,2)
    kelly_rgb(k,:) = hex2rgb(kelly_colors{k}, 256);
end



