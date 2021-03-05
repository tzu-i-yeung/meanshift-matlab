function [ filtered_map ] = texture_features( graymap, sigma )
% TEXTURE_FEATURES computes the response of an image to 17 Gaussian filters
% Parameters:
% graymap: the grayscale image
% sigma:  the standard deviation of the Gaussian distribution

if nargin < 3
    sigma = 0.1;
end

graymap = double(graymap);
filters = gaussian_filter(sigma, 8, 25);
sz_filter = size(filters);
sz_gray = size(graymap);
filtered_map = zeros(sz_filter(3), sz_gray(1), sz_gray(2));
pad_thickness = floor(sz_filter(1) / 2);
graymap = padarray(graymap,[pad_thickness, pad_thickness] ,'symmetric', 'both');
for k = 1:sz_filter(3)
    filtered_map(k, :,:) = conv2(graymap, squeeze(filters(:,:,k)), 'valid');
end

end

