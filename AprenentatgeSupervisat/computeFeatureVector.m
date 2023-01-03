%% Compute feature vector
function vec = computeFeatureVector(image) %A partir de la imatge i el ground truth retornem un vector de característiques
vec = [];  % Inicialitzem el vector de sortida
GT = rgb2gray(image); % Passem la imatge a nivell de gris

% Corregim fons de les imatges
for i = 1:224
    for j = 1:224
        if (GT(i,j)>=255)
            GT(i,j)=mean2(image);
        end
    end
end

GT = imbinarize(GT); % Binaritzem la imatge

%Característiques de forma
features=regionprops(GT,'BoundingBox','Eccentricity','Area','EulerNumber');
if (length(features)> 1 ) %Per si les imatges tenen 2 regions (una de gran i
    % l'altre que tant sols és un pixel, ens assegurem que ens quedem amb la gran)
    [mx, pmx] = max([features.Area]);

    %Combinacions de proves
    %vrg = [features(pmx).Circularity features(pmx).MajorAxisLength
    % features(pmx).MinorAxisLength features(pmx).Area features(pmx).Eccentricity
    % features(pmx).EulerNumber];
    %vrg = [features(pmx).Eccentricity];
    %vrg = [features(pmx).Area/features(pmx).Perimeter]; %Invariable a escala
    %vrg = [features(pmx).BoundingBox];

    %Combinacions utilitzades (cal comentar la que no s'estigui
    %executant)
    vrg = [features(pmx).Eccentricity, features(pmx).BoundingBox, features(pmx).EulerNumber];
    %Guardem els valors que ens retorna la bounding box per
    %utilitzar-los més endavant. (no s'han utilitzant al model final,
    %però les hem deixat, ja que s'han utilitzat per testejar)
    %     altura = floor(features(pmx).BoundingBox(4));
    %     amplada = floor(features(pmx).BoundingBox(3));
    %     xBB = floor(features(pmx).BoundingBox(1)); % extrem superior-esquerre
    %     yBB = floor(features(pmx).BoundingBox(2)); % extrem superior-esquerre

else
    %Combinacions de proves
    %vrg = [features.Circularity features.MajorAxisLength
    % features.MinorAxisLength features.Area features.Eccentricity features.EulerNumber];
    %vrg = [features.Area/features.Perimeter];
    %vrg = [features.Eccentricity];
    %vrg = [features.BoundingBox];

    %Combinacions utilitzades
    vrg = [features.Eccentricity, features.BoundingBox, features.EulerNumber];%Benigne, maligne

    %Característiques bounding box
    %     altura = floor(features.BoundingBox(4));
    %     amplada = floor(features.BoundingBox(3));
    %     xBB = floor(features.BoundingBox(1));
    %     yBB = floor(features.BoundingBox(2));
end

vec = [vec vrg]; %Guardem els valors al vector de sortida


%     %Característiques de textura: No s'han utilitzat al model final, però
%     %s'han considerat durant la validació.
%
%     % (A) representa la zona de la lesió i els marges més propers, d'aquesta
%     % manera podrem estudiar únicament la zona afectada.
%     A = image(yBB-10:yBB+altura,xBB+10:xBB+amplada+10);
% %
% %
% %     % (B) representa la zona just a sota de la lesió, és a dir l'ombra
% %     B = image(yBB+altura:yBB+altura+100,xBB:xBB+amplada);
% %
% %        %Característiques bounding box
%     altura = floor(features.BoundingBox(4));
%     amplada = floor(features.BoundingBox(3));
%     xBB = floor(features.BoundingBox(1));
%     yBB = floor(features.BoundingBox(2));
% %
% %     %Nivell de gris
% %     v = mean(mean(A));
% %     vec = [vec v];
% %
% %     %Matrius de concurrència
% %     g1 = graycomatrix(A,'Offset',[1 0; 0 1; 1 1; 1 -1; 5 0; 0 5; 5 5; 5 -5;
%       11 0; 0 11; 11 11; 11 -11]);
% %     gst = graycoprops(g1,{'Contrast','Homogeneity','Energy','Correlation'});
% %     vg1 = [gst.Contrast, gst.Homogeneity, gst.Energy, gst.Correlation];
% %     vec = [vec vg1];
% %
%     %LBP
%     vlbp = extractLBPFeatures(A);
%     vec = [vec vlbp];
%     vlbp = extractLBPFeatures(A,'Radius',11,'Upright',false);
%     vec = [vec vlbp];
% %
% %     %Laws filters
% %     vec = [vec lawsFilters(A)];
% %
% %     %Gabor
% %     gaborBank = gabor([2 5 11],[0 90 45 -45]);
% %     gaborMag = imgaborfilt(A, gaborBank);
% %     for i=1:size(gaborMag,3)
% %         v= gaborMag(:,:,1);
% %         mu(i) = mean(v(:));
% %         st(i) = std(v(:));
% %     end
% %     vec = [vec mu st];

end
