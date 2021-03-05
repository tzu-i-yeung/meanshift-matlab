object = converge_points(3:5,:,:);
x = object(1,:,:);
y = object(2,:,:);
z = object(3,:,:);

color_map = zeros(numel(map), 3);
color_def;
kelly_rgb = uint8(kelly_rgb);
num_color = size(kelly_rgb,1);
for k = 1:numel(map)
   color_map(k,:) = kelly_rgb(mod(map(k),num_color)+1, :); 
end
pcshow([x(:), y(:), z(:)], color_map/256,'MarkerSize', 60);
xlabel('X');
ylabel('Y');
zlabel('Z');