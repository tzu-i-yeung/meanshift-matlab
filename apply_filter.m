function [ filtered ] = apply_filter( imgs, filter )
%APPLY_FILTER

[sz0, sz1, sz2] = size(imgs);
[f_sz1, f_sz2] = size(filter);
new_sz1 = sz1 + floor(f_sz1/2);
new_sz2 = sz2 + floor(f_sz2/2);
filtered = zeros(sz0, new_sz1, new_sz2);
for k = 1:sz0
    filtered(k,:,:) = conv2(squeeze(imgs(k,:,:)), filter);
end

