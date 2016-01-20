tighterAccuracyMatrix = zeros(21, 85);
tighterCMatrix = zeros(21,85);
tighterSigmaMatrix = zeros(21,85);

j = 1;

for c = 30:5:130
    k = 1;
    for sigma = 0.5:0.02:2.2
        net = svm(size(normal_features, 2), 'rbf', [sigma], c);
        pos_class = ones(size(normal_train_sunset, 1), 1);
        neg_class = ones(size(normal_train_nonsunset, 1), 1);
        neg_class(:) = -1;
        yTrain = vertcat(pos_class, neg_class);
        xTrain = vertcat(normal_train_sunset, normal_train_nonsunset);
        net = svmtrain(net, xTrain, yTrain);

        falsePos = 0;
        falseNeg = 0;
        truePos = 0;
        trueNeg = 0;

        xTest = vertcat(normal_test_sunset, normal_test_nonsunset);
        [detectedClasses, distances] = svmfwd(net, xTest);
        pos_test_class = ones(size(normal_test_sunset, 1), 1);
        neg_test_class = ones(size(normal_test_nonsunset, 1), 1);
        neg_test_class(:) = -1;
        yTest = vertcat(pos_test_class, neg_test_class);
        
        for i = 1:length(yTest)
            if (yTest(i) == 1)
                if (detectedClasses(i) == 1)
                    truePos = truePos + 1;
                else
                    falseNeg = falseNeg + 1;
                end
            else
                if (detectedClasses(i) == 1)
                    falsePos = falsePos + 1;
                else
                    trueNeg = trueNeg + 1;
                end
            end
        end

        tighterAccuracyMatrix(j, k) = (trueNeg + truePos)/length(yTest);
        tighterCMatrix(j, k) = c;
        tighterSigmaMatrix(j, k) = sigma;
        k = k + 1;
    end
    j = j + 1;
end

tighterMaxAcc = max(max(tighterAccuracyMatrix));
tighterMaxIdx = find(tighterAccuracyMatrix==tighterMaxAcc);
tighterCBest = tighterCMatrix(tighterMaxIdx);
tighterSigmaBest = tighterSigmaMatrix(tighterMaxIdx);