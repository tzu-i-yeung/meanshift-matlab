%% read the image
A = imread('55067.jpg');

%% down size the image for faster demo (optional)
downsize_scale = sqrt(size(A,1)*size(A,2)/16000);
if downsize_scale > 1
    A = imresize(A, [round(size(A,1)/downsize_scale), round(size(A,2)/downsize_scale)]);
end

%% compute the features
features = compute_features(A, true);  %the second argument specifies whether to include the texture features
features = rescale_augment(features);

%% perform meanshift
display('We are going to run the meanshift algorithm, this may take some time.');
display('A waitbar will be displayed.');
display('Press any key to continue...');
pause;
map = meanshift_fast(features, 0.13, 1e-5, 3, 0.04); %sigma, tol_converge, subpixel, merge_threshold 

%% visualize the segmentation result
figure();
myimshow_cluster(map);

%%
display('We can manually merge some patches in the image.');
merged_map = merge_patches(map);
