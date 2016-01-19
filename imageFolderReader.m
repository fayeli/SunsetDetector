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
k1 = size(fileList1, 1) - 2;
k2 = size(fileList1, 1)+size(fileList2, 1) - 4;
k3 = size(fileList1, 1)+size(fileList2, 1)+size(fileList3, 1) - 6;
k4 = size(fileList1, 1)+size(fileList2, 1)+size(fileList3, 1) +size(fileList4, 1) - 8;

features = zeros(k4, 294);
for i = 3:size(fileList1)
    img = imread([subdir1  '/'  fileList1(i).name]);
    features(i-2, :) = extractFeature(img);
end

for i = 3:size(fileList2)
    img = imread([subdir2  '/'  fileList2(i).name]);
    features(i + k1 - 2, :) = extractFeature(img);
end

for i = 3:size(fileList3)
    img = imread([subdir3  '/'  fileList3(i).name]);
    features(i + k2 - 2, :) = extractFeature(img);
end

for i = 3:size(fileList4)
    img = imread([subdir4  '/'  fileList4(i).name]);
    features(i + k3 - 2, :) = extractFeature(img);
end

normal_features = normalizeFeatures01(features);
normal_train_sunset = normal_features(1:k1, :);
normal_train_nonsunset = normal_features(k1+1:k2, :);
normal_test_sunset = normal_features(k2+1:k3, :);
normal_test_nonsunset = normal_features(k3+1:k4, :);