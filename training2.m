accuracyMatrix = zeros(41, 119);
cMatrix = zeros(41, 119);
sigmaMatrix = zeros(41,119);

j = 1;
index = 0;
for c = 30:3:150
    k = 1;
    for sigma = 0.1:0.5:sqrt(3528)
        index = index + 1;
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
        accuracy = (trueNeg + truePos)/length(yTest);
        fprintf('at iteration %d, accuracy = %d\n', index, accuracy);
        accuracyMatrix(j, k) = accuracy;
        cMatrix(j, k) = c;
        sigmaMatrix(j, k) = sigma;
        k = k + 1;
    end
    j = j + 1;
end

maxAcc = max(max(accuracyMatrix));
maxIdx = find(accuracyMatrix==maxAcc);
cBest = cMatrix(maxIdx);
sigmaBest = sigmaMatrix(maxIdx);