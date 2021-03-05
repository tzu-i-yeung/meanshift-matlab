%% read the image
A = imread('388016.jpg');

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
converge_points = meanshift(features, 0.2);
map  = coloring(converge_points, 0.25);  

%% visualize the segmentation result
figure();
myimshow_cluster(map);

%% we can visualize the converge_points in the feature space (only the LAB channels)
display('To facilitate tuning the threshold of merging, we can visualize the converge_points in the feature space.(only the LAB channels)');
display('Press any key to proceed...');
pause;
figure();
inspection;
