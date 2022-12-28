%-----------------------------------------------------%
%-----------------------------------------------------%

diagTrain = readtable('/Volumes/TFG/train/_train.csv'); %Llegim el .csv
data=table2cell(diagTrain); %Convertim el .csv a cel·la per poder interpretar

%-----------------------------------------------------%
%-----------------------------------------------------%

directori = '/Volumes/TFG/_train/';
dir_train = dir([directori '*.dcm']);

%-----------------------------------------------------%
%-----------------------------------------------------%

for i = 1:150
    i
    nom1 = dir_train(i).name; %GT i Img tenen el mateix nom
    nom = eraseBetween(nom1,1,2);
    A = dicomread([directori nom]); %es pot canviar per imread segons el format 
    [r,g,b] = imsplit(A); %extraiem R, G i B de la imatge en color

    %Ag = rgb2gray(r); %Nivell de gris. Una altra opció hagues sigut
    B = double(r)/double(max(A(:)));
    st = strel('square',50); %Definim element estructural
    C = (imerode(imdilate(B,st),st)); %Close
    D = C-B;
    thres = graythresh(D); %Threshold automàtic
    st2 = strel('square',5); %Definim element estructural
    E = (imdilate(imerode(D>thres,st2),st2)); %Open
    F = B;
    F(E>0) = C(E>0);
    %figure; imshow(F);

    %Ag = rgb2gray(g); %Nivell de gris. Una altra opció hagues sigut
    B = double(g)/double(max(A(:)));
    st = strel('square',50); %Definim element estructural
    C = (imerode(imdilate(B,st),st)); %Close
    D = C-B;
    thres = graythresh(D); %Threshold automàtic
    st2 = strel('square',5); %Definim element estructural
    E = (imdilate(imerode(D>thres,st2),st2)); %Open
    F2 = B;
    F2(E>0) = C(E>0);
    %figure; imshow(F2);

    %Ag = rgb2gray(b); %Nivell de gris. Una altra opció hagues sigut
    B = double(b)/double(max(A(:)));
    st = strel('square',50); %Definim element estructural
    C = (imerode(imdilate(B,st),st)); %Close
    D = C-B;
    thres = graythresh(D); %Threshold automàtic
    st2 = strel('square',5); %Definim element estructural
    E = (imdilate(imerode(D>thres,st2),st2)); %Open
    F3 = B;
    F3(E>0) = C(E>0);
    %figure; imshow(F3);

    RGB = cat(3, F, F2, F3);
    % figure; imshow(RGB);
    %
    % figure; imshow(A);

    % subplot(1,2,1), imshow(A);
    % subplot(1,2,2), imshow(RGB);

end


    %% RGB ho fa pels 3 plans %Divideix pel màxim absolut no del pla
