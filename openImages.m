disp(' ');
disp('This script opens two randomly selected images from each set of successes and failures.');
disp('The first two images are from test sunsets and were successfully classified as sunsets');

sunsetTestSize = size(pos_test_class, 1);

randNumVector = randi(sunsetSuccess - 1, 1, 2);
while randNumVector(1) == randNumVector(2)
    randNumVector = randi(sunsetSuccess, 1, 2);
end
%   i needs to be incremented by 2 because the first 2 files are
%   directories
idx1 = sunsetSuccessMatrix(randNumVector(1), 1) + 2;
idx2 = sunsetSuccessMatrix(randNumVector(2), 1) + 2;
img1 = imread([subdir3  '/'  fileList3(idx1).name]);
img2 = imread([subdir3  '/'  fileList3(idx2).name]);
f1 = figure; imshow(img1);
f2 = figure; imshow(img2);

disp(' ');
disp('Press any key to see two successful nonsunset classifications')
pause

disp(' ');
disp('These two images are from test nonsunsets and were successfully classified as nonsunsets');
randNumVector = randi(nonsunsetSuccess - 1, 1, 2);
while randNumVector(1) == randNumVector(2)
    randNumVector = randi(nonsunsetSuccess, 1, 2);
end
%   i needs to be incremented by 2 because the first 2 files are
%   directories
idx1 = nonsunsetSuccessMatrix(randNumVector(1), 1) - sunsetTestSize + 2;
idx2 = nonsunsetSuccessMatrix(randNumVector(2), 1) - sunsetTestSize + 2;
img1 = imread([subdir4  '/'  fileList4(idx1).name]);
img2 = imread([subdir4  '/'  fileList4(idx2).name]);
f3 = figure; imshow(img1);
f4 = figure; imshow(img2);

disp(' ');
disp('Press any key to see two misclassified sunsets')
pause

disp(' ');
disp('These two images are from test sunsets and unfortunately, were misclassified as nonsunsets');
randNumVector = randi(sunsetFailure - 1, 1, 2);
while randNumVector(1) == randNumVector(2)
    randNumVector = randi(sunsetFailure, 1, 2);
end
%   i needs to be incremented by 2 because the first 2 files are
%   directories
idx1 = sunsetFailureMatrix(randNumVector(1), 1) + 2;
idx2 = sunsetFailureMatrix(randNumVector(2), 1) + 2;
img1 = imread([subdir3  '/'  fileList3(idx1).name]);
img2 = imread([subdir3  '/'  fileList3(idx2).name]);
f5 = figure; imshow(img1);
f6 = figure; imshow(img2);

disp(' ');
disp('Press any key to see two misclassified nonsunsets')
pause

disp(' ');
disp('These two images are from test nonsunsets and unfortunately, were misclassified as sunsets');
randNumVector = randi(nonsunsetFailure - 1, 1, 2);
while randNumVector(1) == randNumVector(2)
    randNumVector = randi(nonsunsetFailure, 1, 2);
end
%   i needs to be incremented by 2 because the first 2 files are
%   directories
idx1 = nonsunsetFailureMatrix(randNumVector(1), 1) - sunsetTestSize + 2;
idx2 = nonsunsetFailureMatrix(randNumVector(2), 1) - sunsetTestSize + 2;
img1 = imread([subdir4  '/'  fileList4(idx1).name]);
img2 = imread([subdir4  '/'  fileList4(idx2).name]);
f7 = figure; imshow(img1);
f8 = figure; imshow(img2);

disp(' ');
disp('Press any key to end the demo')
pause

delete(f1);
delete(f2);
delete(f3);
delete(f4);
delete(f5);
delete(f6);
delete(f7);
delete(f8);