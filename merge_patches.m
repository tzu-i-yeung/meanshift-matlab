function [ out_merged_map ] = merge_patches( colormap )
%MERGE_PATCHES to merge some patches of the colormap via user interaction
% 
merged_map = colormap;

figure;
myimshow_cluster(colormap);
display('Please click on the image to specify the patches that need to be merged.');
display('After you finish, press the Enter button.');
[cols, rows] = ginput;
rows = round(rows);
cols = round(cols);
%display(round(rows));
color = colormap(rows(1), cols(1));
for k = 2:numel(rows)
    merged_map(colormap==colormap(rows(k), cols(k))) = color;
end

myimshow_cluster(merged_map);
if nargout==1
    out_merged_map = merged_map;
end

end

