function [ colors ] = color_pick( colormap )
%COLOR_PICK pick the color index of some points in colormap
%           via user interaction
figure;
myimshow_cluster(colormap);
display('Please click at the pixels whose color index you would like to know');
display('After you finish, press the Enter button');
[cols, rows] = ginput;
rows = round(rows);
cols = round(cols);
colors = zeros(size(rows));
for k = 1:numel(colors)
   colors(k) =  colormap(rows(k),cols(k));
end



end

