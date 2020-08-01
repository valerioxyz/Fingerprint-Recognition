%VALERIO MENNILLO N46003768
%ANTONIO MENNELLA N46003696
%PROGETTO DI SISTEMI MULTIMEDIALI: FINGERPRINT RECOGNITION
clear all;close all; clc;
addpath(genpath(pwd));

%inizializzo fingerprints features...
[uniqueFingerprints,valid_points]=initialize_points();

%get random candidate from folder "candidates"
d='./candidates';
f=dir([d '\*.tif']);
n=numel(f);
idx=randi(n);

cnddt_img_name=f(idx).name; %candidate image name

% uncomment la prossima linea per fare test specifici 
% le impronte candidate sono nella cartella 'candidates'
cnddt_img_name = 'c1_2.tif';

fing_img=imread(cnddt_img_name);
c_img=extract_fingerprint(fing_img);
figure;imshow(c_img)

[x1,y1,width,height]=roi_from_finger(c_img);
c_points = detectSURFFeatures(c_img,'ROI',[x1,y1,width,height]);
[c_f,c_vpts] = extractFeatures(c_img,c_points,'Method','SURF');

figure;
img_segm = insertShape(c_img,'rectangle',[x1,y1,width,height],'LineWidth',1);
imshow(img_segm);hold on;
plot(c_points); hold on;
plot(x1,y1,'y*'); hold on;
plot(x1+width,y1+height,'y*');

length=size(uniqueFingerprints,1);

indexPairs=cell(length,1);
matchCount=zeros(length,1);

for i=1:length
    fprintf("Computing img "+cnddt_img_name+" and "+uniqueFingerprints(i)+".. "); 
    indexPairs{i} = matchFeatures(c_f,valid_points{i,1},'Unique',true,'MaxRatio',0.4);
    
    matchedPoints1 = c_vpts(indexPairs{i}(:,1));
    matchedPoints2 = valid_points{i,2}(indexPairs{i}(:,2));
    
    matchCount(i)=matchedPoints1.Count;
    
    figure;
    showMatchedFeatures(fing_img,imread(uniqueFingerprints(i)),matchedPoints1,matchedPoints2,'montage','PlotOptions',{'ro','rd','g-'} );
    if(matchCount(i)>0)
        legend('candidatePts','matchedPts','matchLine','Location','south');legend('boxoff');
    end
    title(cnddt_img_name+" & "+uniqueFingerprints(i) +" matches: "+ matchCount(i));
    
    
    
    fprintf("numero di corrispondenze: "+matchCount(i)+"\n");
    
    varianza(i)=variance_angle(matchedPoints1,matchedPoints2,c_img);
    
    fprintf("varianza media di tutti i punti: "+varianza(i)+"\n");
    
end

matchedIndex=find((matchCount)>=max(matchCount)/2);
fprintf("Count Thresholding!!! removed "+ (length-size(matchedIndex,1)) +" fingerprints!!!\n");
min_index_varianza=(matchedIndex(1));

for i=1:size(matchedIndex,1)
    if(varianza(1,matchedIndex(i))<varianza(min_index_varianza))
       min_index_varianza=matchedIndex(i);
    end
end
matchedIndex=min_index_varianza;

close all;
matchedIndexPointsCandidate=c_vpts(indexPairs{matchedIndex}(:,1));
matchedIndexPointsFound = valid_points{matchedIndex,2}(indexPairs{matchedIndex}(:,2));

figure;showMatchedFeatures(fing_img,imread(uniqueFingerprints(matchedIndex)),matchedIndexPointsCandidate,matchedIndexPointsFound,'montage','PlotOptions',{'ro','rd','g-'} );
legend('candidatePts','matchedPts','matchLine','Location','south');legend('boxoff');
fprintf("L'immagine "+cnddt_img_name+" ha il miglior numero di match ("+matchCount(min_index_varianza)+") con l'impronta "+uniqueFingerprints(matchedIndex)+" totalizzando una varianza di "+varianza(matchedIndex)+"!\n");
