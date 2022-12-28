FalsosPositius = [];
aux = 1;
for i = 1:length(YPred)
        if (YPred(i)=="benign" && imdsTest.Labels(i)=="malignant")
            FalsosPositius(aux) = i;
            aux = aux+1;
        end
end

FalsosNegatius = [];
aux = 1;
for i = 1:length(YPred)
        if (YPred(i)=="malignant" && imdsTest.Labels(i)=="benign")
            FalsosNegatius(aux) = i;
            aux = aux+1;
        end
end

P = [];
aux = 1;
for i = 1:length(YPred)
        if (YPred(i)=="benign" && imdsTest.Labels(i)=="benign")
            P(aux) = i;
            aux = aux+1;
        end
end

N = [];
aux = 1;
for i = 1:length(YPred)
        if (YPred(i)=="malignant" && imdsTest.Labels(i)=="malignant")
            N(aux) = i;
            aux = aux+1;
        end
end


%--Llegim la imatge que desitgem---------%
X = imdsTest.readimage(FalsosNegatius(23));
inputSize = net.Layers(1).InputSize(1:2);
X = imresize(X,inputSize);

figure
imshow(X)

%----La classifiquem i creem el scoreMap-----------%
label = classify(net,X);
scoreMap = gradCAM(net,X,label);

%----Mostrem el mapa de calor------%
figure
imshow(X)
hold on
imagesc(scoreMap,'AlphaData',0.5)
colormap jet

