%-----Inicialitzem els vectors----------------%
vecTrain = []; % VECTOR DE CARACTERÍSTIQUES
dT = {}; % VECTOR ETIQUETES REALS

%---Carreguem els directoris------------------%
directoriTrainB = '/Volumes/TFG/ambResize/trainSensePels_Pur/benign/';
dTrainB = dir([directoriTrainB '*.jpg']);
directoriTrainM = '/Volumes/TFG/ambResize/trainSensePels_Pur/malignant/';
dTrainM = dir([directoriTrainM '*.jpg']);

%--Recorregut per la carpeta BENIGNES--------%
for b = 1:length(dTrainB)
    b
    if (dTrainB(b).name(1)=='.')
        nom = eraseBetween(dTrainB(b).name,1,2);
    end
    if (dTrainB(b).name(1)=='I')
        nom = dTrainB(b).name;
    end
    A = imread([directoriTrainB nom]);
    vecTrain(b,:) = computeFeatureVector(A);
    dT{b} = 'benign';
end

%--Recorregut per la carpeta MALIGNES--------%
for m = 1:length(dTrainM)
    b+m
    if (dTrainM(m).name(1)=='.')
        nom = eraseBetween(dTrainM(m).name,1,2);
    end
    if (dTrainM(m).name(1)=='I')
        nom = dTrainM(m).name;
    end
    A = imread([directoriTrainM nom]);
    vecTrain(b+m,:) = computeFeatureVector(A);
    dT{b+m} = 'malignant';
end

%%--------------------------------------------------------------------%%
%%--------------------------------------------------------------------%%
vecVal = [];
dV = {};

% Carreguem els directoris
directoriValB = '/Volumes/TFG/ambResize/valSensePelsPur/benign/';
dValB = dir([directoriValB '*.jpg']);
directoriValM = '/Volumes/TFG/ambResize/valSensePelsPur/malignant/';
dValM = dir([directoriValM '*.jpg']);

% Recorregut per la carpeta BENIGNES
for b = 1:length(dValB)
    b
    if (dValB(b).name(1)=='.')
        nom = eraseBetween(dValB(b).name,1,2);
    end
    if (dValB(b).name(1)=='I')
        nom = dValB(b).name;
    end
    A = imread([directoriValB nom]);
    vecVal(b,:) = computeFeatureVector(A);
    dV{b} = 'benign';
end

% Recorregut per la carpeta MALIGNES
for m = 1:length(dValM)
    b + m
    if (dValM(m).name(1)=='.')
        nom = eraseBetween(dValM(m).name,1,2);
    end
    if (dValM(m).name(1)=='I')
        nom = dValM(m).name;
    end
    A = imread([directoriValM nom]);
    vecVal(b+m,:) = computeFeatureVector(A);
    dV{b+m} = 'malignant';
end

% %Un cop hem entrenat el model i tenim el conjunt de validació busquem el
% %millor classificador. Per classificar benigne-maligne s'ha provat KNN,
% %Adaboost,Random Forest i SVM.

%-------KNN-------
%Md1 = fitcknn(vecTrain,dT,'NumNeighbors',3,'Standardize',false,'NSMethod','exhaustive','Distance','euclidean');
%-------ADABOOST-------
Md2 = fitcensemble(vecTrain,dT,'Method','AdaBoostM1','NumLearningCycles',100);
%-------RANDOM FOREST-------
%Md3 = fitcensemble(vecTrain,dT,'Method','bag');
%-------SVM--------
%Md4 = fitcsvm(vecTrain,dT,'Standardize',true,'KernelFunction','rbf','KernelScale','auto');

% %Fem prediccions utilitzant els models i les característiques de
% %validacio
%[label1] = predict(Md1,vecVal); %Classificant Benigne o Maligne
%cm1 = confusionmat(dV,label1); %Matriu de confusió Benigne o Maligne
%confusionchart(cm3)
%accuracy1 = sum(diag(cm1)/sum(cm1(:))); %Accuracy Benigne o Maligne

[label2] = predict(Md2,vecVal); %Classificant Benigne o Maligne
cm2 = confusionmat(dV,label2); %Matriu de confusió Benigne o Maligne
confusionchart(cm2)
accuracy2 = sum(diag(cm2)/sum(cm2(:)));

%[label3] = predict(Md3,vecVal); %Classificant Benigne o Maligne
%cm3 = confusionmat(dV,label3); %Matriu de confusió Benigne o Maligne
%confusionchart(cm3)
%accuracy3 = sum(diag(cm3)/sum(cm3(:)));

%[label4] = predict(Md4,vecVal); %Classificant Benigne o Maligne
%cm4 = confusionmat(dV,label4); %Matriu de confusió Benigne o Maligne
%confusionchart(cm3)
%accuracy4 = sum(diag(cm4)/sum(cm4(:)));


% PER FER LA PART DE TEST S'HAN CANVIAT ELS DIRECTORIS %