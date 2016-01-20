diffSubdir1 = './sunsetDetectorImages/TestDifficultSunsets';
diffFileList1 = dir(diffSubdir1);
diffSubdir2 = './sunsetDetectorImages/TestDifficultNonsunsets';
diffFileList2 = dir(diffSubdir2);

diffK1 = size(diffFileList1, 1) - 2;
diffK2 = size(diffFileList1, 1)+size(diffFileList2, 1) - 4;

diffFeatures = zeros(diffK2, 294);
for i = 3:size(diffFileList1)
    img = imread([diffSubdir1  '/'  diffFileList1(i).name]);
    diffFeatures(i-2, :) = extractFeature(img);
end

for i = 3:size(diffFileList2)
    img = imread([diffSubdir2  '/'  diffFileList2(i).name]);
    diffFeatures(i + k1 - 2, :) = extractFeature(img);
end

normal_diffFeatures = normalizeFeatures01(diffFeatures);
normal_test_diff_sunset = normal_diffFeatures(1:diffK1, :);
normal_test_diff_nonsunset = normal_diffFeatures(diffK1+1:diffK2, :);

c = 40;
sigma = .62;

net = svm(size(normal_features, 2), 'rbf', [sigma], c);
pos_class = ones(size(normal_train_sunset, 1), 1);
neg_class = ones(size(normal_train_nonsunset, 1), 1);
neg_class(:) = -1;
yTrain = vertcat(pos_class, neg_class);
xTrain = vertcat(normal_train_sunset, normal_train_nonsunset);
net = svmtrain(net, xTrain, yTrain);

xTest = vertcat(normal_test_diff_sunset, normal_test_diff_nonsunset);
[detectedClasses, distances] = svmfwd(net, xTest);
pos_test_class = ones(size(normal_test_diff_sunset, 1), 1);
neg_test_class = ones(size(normal_test_diff_nonsunset, 1), 1);
neg_test_class(:) = -1;
yTest = vertcat(pos_test_class, neg_test_class);

thresholdMatrix = [-1.4:0.1:4.9];
tprMatrix = zeros(size(thresholdMatrix, 2), 1);
fprMatrix = zeros(size(thresholdMatrix, 2), 1);

diffSunsetSuccessMatrix = zeros(size(normal_diffFeatures, 1), 1);
diffNonsunsetSuccessMatrix = zeros(size(normal_diffFeatures, 1), 1);
diffSunsetFailureMatrix = zeros(size(normal_diffFeatures, 1), 1);
diffNonsunsetFailureMatrix = zeros(size(normal_diffFeatures, 1), 1);

index = 1;
diffSunsetSuccess = 0;
diffNonsunsetSuccess = 0;
diffSunsetFailure = 0;
diffNonsunsetFailure = 0;

for threshold = thresholdMatrix
    truePos = 0;
    falseNeg = 0;
    falsePos = 0;
    trueNeg = 0;
    for i = 1:length(yTest)
        if (yTest(i) == 1)
            if (distances(i) > threshold)
                truePos = truePos + 1;
            else
                falseNeg = falseNeg + 1;
            end
        else
            if (distances(i) > threshold)
                falsePos = falsePos + 1;
            else
                trueNeg = trueNeg + 1;
            end
        end
    end
    tprMatrix(index) = truePos / (truePos + falseNeg);
    fprMatrix(index) = falsePos / (falsePos + trueNeg);
    index = index + 1;
end

% best threshold is 1.2 or 1.3 so median is 1.25

for i = 1:length(yTest)
    if (yTest(i) == 1)
        if (distances(i) >= -1.5)
            diffSunsetSuccess = diffSunsetSuccess + 1;
            diffSunsetSuccessMatrix(diffSunsetSuccess + 1) = i;
        else
            diffSunsetFailure = diffSunsetFailure + 1;
            diffSunsetFailureMatrix(diffSunsetFailure) = i;
        end
    else
        if (distances(i) >= -1.5)
            diffNonsunsetFailure = diffNonsunsetFailure + 1;
            diffNonsunsetFailureMatrix(diffNonsunsetFailure) = i;
        else
            diffNonsunsetSuccess = diffNonsunsetSuccess + 1;
            diffNonsunsetSuccessMatrix(diffNonsunsetSuccess) = i;
        end
    end
end

diffSunsetSuccessMatrix = diffSunsetSuccessMatrix(1:diffSunsetSuccess, :);
diffNonsunsetSuccessMatrix = diffNonsunsetSuccessMatrix(1:diffNonsunsetSuccess, :);
diffSunsetFailureMatrix = diffSunsetFailureMatrix(1:diffSunsetFailure, :);
diffNonsunsetFailureMatrix = diffNonsunsetFailureMatrix(1:diffNonsunsetFailure, :);
accuracy = (diffSunsetSuccess + diffNonsunsetSuccess) / size(yTest, 1);

roc(tprMatrix, fprMatrix);