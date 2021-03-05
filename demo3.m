%% read the image
A = imread('159091.jpg');

%% down size the image for faster demo (optional)
downsize_scale = sqrt(size(A,1)*size(A,2)/16000);
if downsize_scale > 1
    A = imresize(A, [round(size(A,1)/downsize_scale), round(size(A,2)/downsize_scale)]);
end

%% compute the features
features = compute_features(A, false);  %the second argument specifies whether to include the texture features
features = rescale_augment(features);

%% perform meanshift
display('We are going to run the meanshift algorithm, this may take some time.');
display('A waitbar will be displayed.');
display('Press any key to continue...');
pause;
converge_points = meanshift(features, 0.15);
map  = coloring(converge_points, 0.2);  

%% visualize the segmentation result
figure();
myimshow_cluster(map);