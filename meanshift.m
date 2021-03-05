function [ terminals ] = meanshift( maps, sigma, tol_converge )
%MEANSHIFT meanshift algorithm
% 
if nargin < 3
    tol_converge = 1e-3;
end
if nargin < 2
    sigma = 0.1; % the std. of gaussian distribution
end
[sz1, sz2, sz3] = size(maps);
a_inverse = min(sz2, sz3);
a = 1/a_inverse;
coef = -0.5/sigma^2;
%% terminals store the final convergence point for each starting position
terminals = zeros(sz1, sz2, sz3);
%%
% calculate the radius threshold for ||x - xn||
% if ||x - xn|| is larger than this radius
% the weight for xn would be considered negligible
%radius = 0.5;       %TODO
radius = sqrt(-8/coef); 
%%
% calculate the neighbors that need to be checked at each iteration                            
% the range is set larger than the radius threshold
% if it is smaller than radius threshold, we are sort of using truncated gaussian
range = 10;   %use a fixed one or use the one below that is larger than the radius threshold
%range = ceil(radius*a_inverse + sqrt(2)/2);   
%display(range); pause;
moves = SearchPoints(range);  

%% X is a container for data points. Its actual size is top_of_X other than fixed.
X = zeros(size(maps,1) ,size(moves,1));
weights = zeros(size(moves,1),1);
top_of_X = 0;
%% Run meanshift for each point
h = waitbar(0,'Initializing waitbar...');
for row = 1:sz2
    waitbar(row/sz2,h,sprintf('%d%% along...',round(row/sz2*100)));
    for col = 1:sz3
        
        u = maps(:,row,col);
        flag_continue = true;
        total_step = 0;
        while flag_continue && total_step<10000
            total_step = total_step + 1;
            if total_step == 10000
               display('Reach maximum number of steps'); 
            end
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
            
            if norm(next_u - u) < tol_converge
               flag_continue = false; 
            end
            u = next_u;
        end
        terminals(:,row,col) = u;
    end
end

delete(h);
%% End of function
end

