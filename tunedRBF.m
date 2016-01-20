c = 40;
sigma = .62;

net = svm(size(normal_features, 2), 'rbf', [sigma], c);
pos_class = ones(size(normal_train_sunset, 1), 1);
neg_class = ones(size(normal_train_nonsunset, 1), 1);
neg_class(:) = -1;
yTrain = vertcat(pos_class, neg_class);
xTrain = vertcat(normal_train_sunset, normal_train_nonsunset);
net = svmtrain(net, xTrain, yTrain);

xTest = vertcat(normal_test_sunset, normal_test_nonsunset);
[detectedClasses, distances] = svmfwd(net, xTest);
pos_test_class = ones(size(normal_test_sunset, 1), 1);
neg_test_class = ones(size(normal_test_nonsunset, 1), 1);
neg_test_class(:) = -1;
yTest = vertcat(pos_test_class, neg_test_class);

thresholdMatrix = [-4:0.1:4];
tprMatrix = zeros(size(thresholdMatrix, 2), 1);
fprMatrix = zeros(size(thresholdMatrix, 2), 1);

sunsetSuccessMatrix = zeros(size(normal_features, 1), 1);
nonsunsetSuccessMatrix = zeros(size(normal_features, 1), 1);
sunsetFailureMatrix = zeros(size(normal_features, 1), 1);
nonsunsetFailureMatrix = zeros(size(normal_features, 1), 1);

index = 1;
sunsetSuccess = 1;
nonsunsetSuccess = 1;
sunsetFailure = 1;
nonsunsetFailure = 1;
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

for i = 1:length(yTest)
    if (yTest(i) == 1)
        if (detectedClasses(i) == 1)
            sunsetSuccessMatrix(sunsetSuccess) = i;
            sunsetSuccess = sunsetSuccess + 1;
        else
            sunsetFailureMatrix(sunsetFailure) = i;
            sunsetFailure = sunsetFailure + 1;
        end
    else
        if (detectedClasses(i) == 1)
            nonsunsetFailureMatrix(nonsunsetFailure) = i;
            nonsunsetFailure = nonsunsetFailure + 1;
        else
            nonsunsetSuccessMatrix(nonsunsetSuccess) = i;
            nonsunsetSuccess = nonsunsetSuccess + 1;
        end
    end
end
sunsetSuccessMatrix = sunsetSuccessMatrix(1:sunsetSuccess - 1, :);
nonsunsetSuccessMatrix = nonsunsetSuccessMatrix(1:nonsunsetSuccess - 1, :);
sunsetFailureMatrix = sunsetFailureMatrix(1:sunsetFailure - 1, :);
nonsunsetFailureMatrix = nonsunsetFailureMatrix(1:nonsunsetFailure - 1, :);

roc(tprMatrix, fprMatrix);