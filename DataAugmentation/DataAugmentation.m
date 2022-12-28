% dirValImg2 = '/Volumes/TFG/valSensePels_Pur/';
% dVal2 = dir([dirValImg2 '*.jpg']);
% 
% mkdir("/Volumes/TFG/",'val_malignes_augmentades');
% 
% %--------ORDENAR LA CARPETA PER NOM-------------%
% %--------VAL2-----------%
% for i = 1:length(dVal2)
%     i
%     if (dVal2(i).name(1)=='.')
%         nom = eraseBetween(dVal2(i).name,1,2);
%         dVal2(i).name = nom;
%     end
% end
% 
% dVal2Table = struct2table(dVal2);
% dVal2OrdenatTable = sortrows(dVal2Table,1);
% dVal2 = table2struct(dVal2OrdenatTable);
% 
% %---------ORDENAR LA TAULA PER NOM----------------%
% diagVal2 = readtable('valSensePels_Pur.csv'); %Llegim el .csv
% diagVal2 = sortrows(diagVal2,1);
% ddval2=table2cell(diagVal2); %Convertim el .csv a cel·la per poder interpretar-lo
% vec1 = [1,2,3,4];
% vec2 = [1,2,3,4];

for i = 1:length(dVal2)
    A = imread(dVal2(1).folder +"/"+ dVal2(1).name);
    % Add randomized Gaussian blur
    v1 = vec1(randi(length(vec),1,1));
    if v1 == 1
        sigma = 1+3*rand;
        temp = imgaussfilt(A,sigma);
    end
    if v1 == 2
        % Add salt and pepper noise
        temp = imnoise(A,"salt & pepper");
    end
    if v1 == 3
        temp = imnoise(A,"gaussian");
    end
    if v1 == 4
        temp = A;
    end

    v2 = vec2(randi(length(vec),1,1));
    if v2 == 1
        temp = jitterColorHSV(temp,Contrast=[0.7 1.7]);
    end
    if v2 == 2
        temp = jitterColorHSV(temp,Brightness=[-0.5 -0.5]);
    end
    if v2 == 3
        temp = jitterColorHSV(temp,Saturation=[-0.5 +0.5]);
    end
    if v2 == 4
        temp = A;
    end

    %Reflection
    tform = randomAffine2d(XReflection=true,YReflection=true);
    outputView = affineOutputView(size(temp),tform);
    temp = imwarp(temp,tform,OutputView=outputView);

    % Add randomized rotation and scale
    angles = 0:90:270;
    tform = randomAffine2d(Rotation=@() angles(randi(4)));
    outputView = affineOutputView(size(temp),tform);
    temp = imwarp(temp,tform,OutputView=outputView);
end
