function [ colormap ] = meanshift_fast( maps, sigma, tol_converge, subpixel, merge_threshold )
%MEANSHIFT naive meanshift alg
% 
if nargin < 5
    merge_threshold = 0.05;
end
if nargin<4
    subpixel = 2;
end
if nargin < 3
    tol_converge = 1e-5;
end
if nargin < 2
    sigma = 0.1; % the std. of gaussian distribution
end

[~, sz2, sz3] = size(maps);


a_inverse = min(sz2, sz3);
%a = 1/a_inverse;
coef = -0.5/sigma^2;

colormap = zeros( sz2, sz3);

merge_nbr = merge_threshold * a_inverse * subpixel;
move = SearchPoints(merge_nbr);

%%
% calculate the radius threshold for ||x - xn||
% if ||x - xn|| is larger than this radius
% the weight for xn would be negligible
%radius = 0.5;       %use a fixed one or use the one below
radius = sqrt(-8/coef); 
%%
% calculate the neighbors that need to be checked at each iteration                            
% the range is set larger than the radius threshold
% if it is smaller than radius threshold, we might (or might not) be using truncated gaussian
range = 15;   %TODO
%range = ceil(radius*a_inverse + sqrt(2)/2);   
%display(range); pause;
moves = SearchPoints(range); 


%% X is a container for data points, the actual size is top_of_X
X = zeros(size(maps,1) ,size(moves,1));
weights = zeros(size(moves,1),1);
top_of_X = 0;

%%

queued = false(sz2*subpixel, sz3*subpixel);
traces = zeros(sz2*subpixel, sz3*subpixel);
max_step = 10000;
queue = zeros(max_step, 2);
top_of_queue = 0;
n_color = 0;
%% Run meanshift_fast for each point
h = waitbar(0,'Initializing waitbar...');
for row = 1:sz2
    waitbar(row/sz2,h,sprintf('%d%% along...',round(row/sz2*100)));
    for col = 1:sz3
        
        u = maps(:,row,col);
        flag_continue = true;
        total_step = 0;
        while flag_continue && total_step<max_step
            total_step = total_step + 1;
            %pos = ceil(subpixel*([u(1),u(2)]*a_inverse-1));
            pos = round( [u(1),u(2)]*a_inverse*subpixel) + 1-subpixel;
            if total_step == max_step
               display('Reach maximum steps'); 
               %if pos is not colored, we are going to assign a new color to it
               if traces(pos(1), pos(2)) == 0
                  n_color = n_color + 1;
                  traces(pos(1), pos(2)) = n_color;
               end
            end

            if traces(pos(1), pos(2)) > 0
                color = traces(pos(1), pos(2));
                for k = 1:top_of_queue
                   traces(queue(k,1), queue(k,2)) = color; 
                end
                top_of_queue = 0;
                colormap(row,col) = traces(pos(1), pos(2));
                flag_continue = false;
            else
                if ~queued(pos(1), pos(2)) 
                   top_of_queue = top_of_queue+1;
                   queue(top_of_queue,:) = pos;
                   queued(pos(1), pos(2)) = true;
                end
                
                %calculate next_u
                anchor = [round(u(1)*a_inverse), round(u(2)*a_inverse)];
                top_of_X = 0;
                for k = 1:size(moves,1)
                    checkpoint = anchor + moves(k,:);
                    if checkpoint(1)>0 && checkpoint(1)<=sz2 && checkpoint(2)>0 && checkpoint(2)<=sz3
                        distance = norm(u - maps(:, checkpoint(1), checkpoint(2)));
                        if distance < radius
                            top_of_X = top_of_X + 1;
                            X(:,top_of_X) = maps(:, checkpoint(1), checkpoint(2));
                            weights(top_of_X) = exp(coef*distance^2);
                        end
                    end
                end
                weights(1:top_of_X) = weights(1:top_of_X)/sum(weights(1:top_of_X));
                next_u = X(:,1:top_of_X)*weights(1:top_of_X);
                %end of calculating next_u

                
                if norm(next_u - u) < tol_converge
                    colored_neighbor = false;
                    for k = 1:size(move,1)
                       checkpos = pos + move(k,:); 
                  
                       if min(checkpos > [0 0]) && min(checkpos <= [sz2,sz3]*subpixel)
                          if traces(checkpos(1), checkpos(2)) > 0
                              color = traces(checkpos(1), checkpos(2));
                              colored_neighbor = true;
                              break;
                          end
                       end
                    end
                    if colored_neighbor
                        traces(pos(1), pos(2)) = color;
                    else
                        n_color = n_color + 1;
                        pos = round( [next_u(1),next_u(2)]*a_inverse*subpixel) + 1-subpixel;
                        traces(pos(1), pos(2)) = n_color;
                    end
                    
                end
                u = next_u;
            
            end
        end
       
    end
end
display(n_color);
delete(h);
%% End of function
end

