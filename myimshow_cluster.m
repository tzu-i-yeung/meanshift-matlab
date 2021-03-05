function [ ] = myimshow_cluster( gray_img )
color_def;
kelly_rgb = uint8(kelly_rgb);
gray_img = squeeze(gray_img);
if islogical(gray_img) 
    gray_img = int8(gray_img);
end
rgb_img = zeros([size(gray_img),3]);
num_color = size(kelly_rgb,1);

gray_img = mod(gray_img, num_color) + 1;
for row = 1:size(gray_img,1)
    for col = 1:size(gray_img,2)
        rgb_img(row,col,:) = kelly_rgb(gray_img(row,col),:);    
    end
end
imshow(rgb_img/256);


end



