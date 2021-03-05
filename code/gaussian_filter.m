function filters = gaussian_filter(sigma, num_orientation, filter_size)
% This function is used to generate odd-symmetric and even-symmetric
% gaussian filters, as well as a center-surround gaussian (Difference of Gaussian) filter
if nargin<3
    filter_size = 25;
end
if nargin<2
    num_orientation = 8;
end
  
odd_filters = zeros(filter_size,filter_size,num_orientation);
even_filters = zeros(filter_size,filter_size,num_orientation);
center = (filter_size+1)/2;
for k = 1:num_orientation
    theta =(k-1) * pi/num_orientation;
    rot_matrix = [cos(theta), -sin(theta); sin(theta), cos(theta)];
    for x = 1: filter_size
        for y = 1: filter_size
           coordinate = rot_matrix*[x-center;y-center];
           tmp = gaussmf(coordinate(2), [sigma 0]) * gaussmf(coordinate(1), [sigma*3 0]);
           odd_filters(x,y,k) = -coordinate(2)/(sigma^2)*tmp;
           even_filters(x,y,k) = ( (coordinate(2))^2/(sigma^4) - 1/(sigma^2)) * tmp;
        end
    end
end
sigma = sigma;  % handcrafted here, make the spread larger, maybe not needed, can be tuned
ratio_of_kernel = 1.6;
DoG_filter = zeros(filter_size, filter_size, 1);
coef1 = 1/(2*pi*sigma^2);
coef2 = coef1 / ratio_of_kernel^2;
for x = 1:filter_size
    for y = 1:filter_size
        r = norm([x - center, y - center], 'fro');
        DoG_filter(x,y,1) = coef1 * gaussmf(r, [sigma 0]) - coef2 * gaussmf(r, [ratio_of_kernel*sigma 0]);
    end
end

filters = cat(3, even_filters, odd_filters, DoG_filter);


% normalizing, or not?
%for k = 1:2*num_orientation
%   filters(:,:,k) = filters(:,:,k) / norm( squeeze(filters(:,:,k)) ,'fro') ;
%end

end