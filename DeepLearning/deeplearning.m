%--Carreguem el directori------%
digitDatasetPath = fullfile('/Volumes/TFG/deeplearning/',{'benign';'malignant'});

%--Creem el dataset d'imatges------%
imds = imageDatastore(digitDatasetPath,'FileExtensions','.jpg', ...
    'LabelSource','foldernames');

%----NETEJAR NOMS------%
for i = 1:length(imds.Files)
    nomImatge = eraseBetween(imds.Files{i},1,39);
    if nomImatge(1) == '.'
        imds.Files{i} = eraseBetween(imds.Files{i},40,41);
    end
end

%---Fem la divisió de Train i Test 70% i 30%----------%
[imdsTrain,imdsTest] = splitEachLabel(imds,0.7,'randomized');

%----Carreguem la xarxa desitjada---------%
net = squeezenet();

%----Mirem quina mida necessita-----%
inputSize = net.Layers(1).InputSize;

%----Modifiquem les imatges del dataset perque tinguin la mida correcta--%
augimdsTrain = augmentedImageDatastore(inputSize(1:2),imdsTrain);
augimdsTest = augmentedImageDatastore(inputSize(1:2),imdsTest);

%--Mostrem la xarxa---%
analyzeNetwork(net);

%--Convertim la xarxa en una gràfica de capes----%
lgraph = layerGraph(net);

%--Busquem quines capes haurem de substituir-------------%
[learnableLayer,classLayer] = findLayersToReplace(lgraph);
[learnableLayer,classLayer] 

%---Fem la substitució------------------------------------%
numClasses = numel(categories(imdsTrain.Labels));

if isa(learnableLayer,'nnet.cnn.layer.FullyConnectedLayer')
    newLearnableLayer = fullyConnectedLayer(numClasses, ...
        'Name','new_fc', ...
        'WeightLearnRateFactor',10, ...
        'BiasLearnRateFactor',10);
    
elseif isa(learnableLayer,'nnet.cnn.layer.Convolution2DLayer')
    newLearnableLayer = convolution2dLayer(1,numClasses, ...
        'Name','new_conv', ...
        'WeightLearnRateFactor',10, ...
        'BiasLearnRateFactor',10);
end

lgraph = replaceLayer(lgraph,learnableLayer.Name,newLearnableLayer);

%---Substituïm la capa de classificació per una nova sense etiquetes---%
newClassLayer = classificationLayer('Name','new_classoutput');
lgraph = replaceLayer(lgraph,classLayer.Name,newClassLayer);

%----Mostrem la xarxa------------------------------------%
figure('Units','normalized','Position',[0.3 0.3 0.4 0.4]);
plot(lgraph)
ylim([0,10])

%--Congelem els pesos inicials i tornem a connectar totes les capes----%
layers = lgraph.Layers;
connections = lgraph.Connections;

layers(1:10) = freezeWeights(layers(1:10));
lgraph = createLgraphUsingConnections(layers,connections);

%Train

miniBatchSize = 10;
valFrequency = floor(numel(augimdsTrain.Files)/miniBatchSize);
options = trainingOptions('sgdm', ...
    'MiniBatchSize',miniBatchSize, ...
    'MaxEpochs',6, ...
    'InitialLearnRate',3e-4, ...
    'Shuffle','every-epoch', ...
    'ValidationData',augimdsTest, ...
    'ValidationFrequency',valFrequency, ...
    'Verbose',false, ...
    'Plots','training-progress');

net = trainNetwork(augimdsTrain,lgraph,options);

%--Classifiquem i mostrem els resultats------%
[YPred,probs] = classify(net,augimdsTest);
accuracy = mean(YPred == imdsTest.Labels);
MatriuConfusio = confusionmat(imdsTest.Labels,YPred);
confusionchart(imdsTest.Labels,YPred);

idx = randperm(numel(imdsTest.Files),4);
figure
for i = 1:4
    subplot(2,2,i)
    I = readimage(imdsTest,idx(i));
    imshow(I)
    label = YPred(idx(i));
    title(string(label) + ", " + num2str(100*max(probs(idx(i),:)),3) + "%");
end
%----------------%
