imDir = '/media/yannicko/DATA/TestImages/img2';
pxDir = '/media/yannicko/DATA/TestImages/seg2';
imds = imageDatastore(imDir);
classNames = ["cell" "background"];
pixelLabelID = [0 1];
pxds = pixelLabelDatastore(pxDir,classNames,pixelLabelID);
trainingData = pixelLabelImageDatastore(imds,pxds);
tbl = countEachLabel(trainingData)
totalNumberOfPixels = sum(tbl.PixelCount);
frequency = tbl.PixelCount / totalNumberOfPixels;
classWeights = 1./frequency;


augmenter = imageDataAugmenter( ...
'RandScale',[0.8,1.2]);
patchds = randomPatchExtractionDatastore(imds,pxds,68,'PatchesPerImage',3, 'DataAugmentation',augmenter);


opts = trainingOptions('sgdm', ...
'InitialLearnRate',1e-3, ...
'MaxEpochs',200, ...
'LearnRateSchedule', 'piecewise',...
'LearnRateDropFactor',0.1, ...
'LearnRateDropPeriod',80, ...
'MiniBatchSize',48,...
'ExecutionEnvironment','parallel',...
'Shuffle','every-epoch',...
'Verbose',true, ...
'Plots','training-progress');


inputSize = [68 68 1];
numFilters = 128;
numClasses = numel(classNames);
layers = [
imageInputLayer(inputSize)
convolution2dLayer(3,numFilters,'DilationFactor',1,'Padding','same')
batchNormalizationLayer
reluLayer
convolution2dLayer(3,numFilters,'DilationFactor',1,'Padding','same')
batchNormalizationLayer
reluLayer
convolution2dLayer(3,numFilters,'DilationFactor',1,'Padding','same')
batchNormalizationLayer
reluLayer
convolution2dLayer(3,numFilters,'DilationFactor',2,'Padding','same')
batchNormalizationLayer
reluLayer
convolution2dLayer(3,numFilters,'DilationFactor',2,'Padding','same')
batchNormalizationLayer
reluLayer
convolution2dLayer(3,numFilters,'DilationFactor',2,'Padding','same')
batchNormalizationLayer
reluLayer
convolution2dLayer(3,numFilters,'DilationFactor',4,'Padding','same')
batchNormalizationLayer
reluLayer
convolution2dLayer(3,numFilters,'DilationFactor',4,'Padding','same')
batchNormalizationLayer
reluLayer
convolution2dLayer(3,numFilters,'DilationFactor',4,'Padding','same')
batchNormalizationLayer
reluLayer
convolution2dLayer(3,numFilters,'DilationFactor',6,'Padding','same')
batchNormalizationLayer
reluLayer
convolution2dLayer(3,numFilters,'DilationFactor',6,'Padding','same')
batchNormalizationLayer
reluLayer
convolution2dLayer(3,numFilters,'DilationFactor',6,'Padding','same')
batchNormalizationLayer
reluLayer
convolution2dLayer(1,numClasses)
softmaxLayer
pixelClassificationLayer('Classes',tbl.Name,'ClassWeights',classWeights)];


net = trainNetwork(patchds,layers,opts);
