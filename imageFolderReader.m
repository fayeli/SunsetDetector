% Example of reading all the files in a given folder, e.g., TrainSunset. 
% For the sunset detector, you should keep the images in 4 separate folders: train and test 
% are separate, and the folder names tell you what the labels are (sunset = +1, non = -1) 
subdir1 = './sunsetDetectorImages/TrainSunset';
fileList1 = dir(subdir1);
subdir2 = './sunsetDetectorImages/TrainNonsunsets';
fileList2 = dir(subdir2);
subdir3 = './sunsetDetectorImages/TestSunset';
fileList3 = dir(subdir3);
subdir4 = './sunsetDetectorImages/TestNonsunsets';
fileList4 = dir(subdir4);

% files 1 and 2 are . (current dir) and .. (parent dir), respectively, 
% so we start with 3.
matrix_size = size(fileList1, 1) + size(fileList2, 1) + size(fileList3, 1) + size(fileList4, 1) - 8;
features = zeros(matrix_size, 294);
for i = 3:size(fileList)
    img = imread([subdir  '/'  fileList(i).name]);
    features(i-2, :) = extractFeature(img);
    % TODO: insert code of function call here to operate on image.
    % Hint: debug the loop body on 1-2 images BEFORE looping over lots of them...
    normal_features = normalizeFeatures01(features);
end

normal_train_sunset = normal_features(1:size(fileList1, 1) - 2, :);
normal_train_nonsunset = normal_features((size(fileList1, 1) - 1):(size(fileList2, 1) - 2), :);
normal_test_sunset = normal_features((size(fileList2, 1) - 1):(size(fileList3, 1) - 2), :);
normal_test_nonsunset = normal_features((size(fileList3, 1) - 1):(size(fileList4, 1) - 2), :);