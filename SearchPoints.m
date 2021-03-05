function [ points ] = SearchPoints( radius )
radius = ceil(radius);
eps = 1e-11;
count = 0;
points = zeros(1,2); %its size will be extended later
for x = -radius:radius
    for y = -radius:radius
        if x^2+y^2 <= radius^2 + eps
            count = count+1;
            points(count,:) = [x y];
 
        end
    end
end
norms = zeros(count,1);
for k = 1:count
    norms(k) = norm(points(k,:));
end
[~, idx] = sort(norms);
points = points(idx,:);

end

