function [ mask ] = wander_explore_multi_channel( imgs, seeds, threshold )
%WANDER_EXPLORE starting from one point (seed), go exploring neighboring
%points if their values are close to the current position
if nargin<3
    threshold = 0.05;
end
[sz0, sz1, sz2] = size(imgs);
img = zeros(sz1,sz2);
move = [1 0; -1 0; 0 1; 0 -1; 1 1; 1 -1; -1 1; -1 -1];
mask = false(size(img));
visited = false(size(img));
inqueue = false(size(img));
queue = zeros(numel(img),2);
front = 1;
for k = 1:size(seeds,1)
    mask(seeds(k,1), seeds(k,2)) = true;  
    queue(k,:) = seeds(k,:);
    inqueue(seeds(k,1), seeds(k,2)) = true;
end
rear = size(seeds,1);
while front <= rear
   row = queue(front,1);
   column = queue(front,2);
   for k = 1:size(move,1)
       u = row + move(k,1);   
       v = column + move(k,2);
       if u<1 || u>sz1 || v<1 || v>sz2
           continue;
       end
       %display([u v]);
       
       if ~visited(u,v)
          if norm(imgs(:,u,v)-imgs(:,row,column)) < threshold
             mask(u,v) = true;
             if ~inqueue(u,v)
               rear = rear+1;
               queue(rear,:) = [u v];
               inqueue(u,v) = true;
             end
          end    
       end    
   end
   visited(row, column) = true;
   front = front+1;
end

end

