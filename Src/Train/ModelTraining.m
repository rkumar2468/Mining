%Step 1 - Read the input file
fid_r = fopen('D:\workspace\CSE591\Mining\Dataset\LogisticReg\trainData.txt','r');
relation = textscan(fid_r, '%f %f %d %d','delimiter', ',' );
fclose(fid_r);

display(relation);

numRecords = length(relation{1,1});

trainData = zeros(numRecords,4);
for i = 1:numRecords
    trainData(i,:) = [relation{1,1}(i),relation{1,2}(i),relation{1,3}(i),relation{1,4}(i)];
end
   

fid_t = fopen('D:\workspace\CSE591\Mining\Dataset\LogisticReg\trainLabels.txt','r');
trainLabelsCell = textscan(fid_t, '%d');
fclose(fid_t);

trainLabels = zeros(length(trainLabelsCell{1,1}),1);


for i = 1:length(trainLabelsCell{1,1})
    trainLabels(i) = trainLabelsCell{1,1}(i);
end


svmModel = trainSVM(trainData,trainLabels,2);

fid_test = fopen('D:\workspace\CSE591\Mining\Dataset\LogisticReg\testData.txt','r');
testDataCell = textscan(fid_test, '%f %f %d %d','delimiter', ',' );
fclose(fid_test);


numRecordsTest = length(testDataCell{1,1});
testData = zeros(numRecordsTest,4);

for i = 1:numRecordsTest
    testData(i,:) = [testDataCell{1,1}(i),testDataCell{1,2}(i),testDataCell{1,3}(i),testDataCell{1,4}(i)];
end

predictedLabels = classifySVM(svmModel,testData);
display(predictedLabels);
