trainData = [0.5,4.5,1,0;
                  5,0.5,1,0;
                  5,4.5,1,0;
                  1,0.5,0,0;
                  4.5,4.5,0,0;
                  0.6,0.5,0,0;
                  5,4.5,0,0;
                  4.5,0.5,0,0;
                  1,4.5,0,0;
                  0.5,0.5,0,0];
              
display(trainData);

trainLabels = [1; 1;2; 2;2;2;2;1;1;2];
testLabels = [1; 1;2; 2;2;2;2;1;1;2];



svmModel = trainSVM(trainData,trainLabels,2);

testData = [0.5,4.5,1,0;
                  5,0.5,1,0;
                  5,4.5,1,0;
                  1,0.5,0,0;
                  4.5,4.5,0,0;
                  0.6,0.5,0,0;
                  5,4.5,0,0;
                  4.5,0.5,0,0;
                  1,4.5,0,0;
                  0.5,0.5,0,0];

predictedLabels = classifySVM(svmModel,testData);
display(predictedLabels);

testError = sum(abs(predictedLabels-testLabels'))/length(testLabels)