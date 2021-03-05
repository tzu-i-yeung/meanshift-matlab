function [ features ] = compute_features( rgb_img, include_texture_features )
if nargin < 2
    include_texture_features = false;
end
if include_texture_features
    N_features = 20;
else
    N_features = 3;
end
features = zeros(N_features, size(rgb_img, 1), size(rgb_img, 2));
lab_img = rgb2lab(rgb_img);
brightness = lab_img(:,:,1);
color_a = lab_img(:,:,2);
color_b = lab_img(:,:,3);
features(1,:,:) = brightness;
features(2,:,:) = color_a;
features(3,:,:) = color_b;
if include_texture_features
    gray_img = rgb2gray(rgb_img);
    texture = texture_features(gray_img);   
    features(4:end, :, :) = texture;
end
end

