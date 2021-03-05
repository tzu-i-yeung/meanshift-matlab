function [ output_maps ] = rescale_augment( maps )
%RESCALE_EXPAND rescale each channel, so that their values lie in [0,1]
%  and add two more features, storing the spatial position of each pixel
[sz1, sz2, sz3] = size(maps);
output_maps = zeros(sz1+2, sz2, sz3);
for k = 1:sz1
    lb = min(min(maps(k,:,:)));
    ub = max(max(maps(k,:,:)));
    output_maps(k+2,:,:) = (maps(k,:,:)-lb) / (ub-lb);
end
a_inverse = min(sz2, sz3);
for row = 1:sz2
    for col = 1:sz3
        output_maps(1,row,col) = row/a_inverse;
        output_maps(2,row,col) = col/a_inverse;
    end
end
