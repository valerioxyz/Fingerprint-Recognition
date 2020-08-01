function [uniqueFingerprints,valid_points] = initialize_points()

    if(isfile("uniqueFingerprints.mat"))
        uniqueFingerprints=importdata("uniqueFingerprints.mat");
    else
        %in realtà questa operazione nella pratica è irrealizzabile ovvero
        %quella di popolare tabelle di dati a runtime piuttosto che interrogare
        %una base di dati. 
        uniqueFingerprints=["1.tif";"2.tif";"3.tif";"4.tif";"5.tif";"6.tif";"7.tif";"8.tif";"9.tif";"10.tif"];
        save('uniqueFingerprints.mat', 'uniqueFingerprints')
    end

    if(isfile("valid_points.mat"))
        fprintf("Valid points have already been calculated! returning them...\n");
        valid_points=importdata("valid_points.mat");
        for j=1:2
            for i=1:size(uniqueFingerprints,1)
                if(isempty(valid_points{i,j}))
                    fprintf("Empty cell detected in valid_points! recalculating them...\n");
                    delete("valid_points.mat");
                    [uniqueFingerprints,valid_points]=initialize_points();
                    break;
                end
            end
        end
    else
        fprintf("It appears nobody ever calculated valid_points on fingerprints! Doing it by myself!\n");

        valid_points=cell(size(uniqueFingerprints,1),2);
        figure;
        for i=1:size(uniqueFingerprints,1)
            fprintf(uniqueFingerprints(i)+"...\n");
            I=imread(uniqueFingerprints(i));
            [fp]=extract_fingerprint(I);

            [x1,y1,width,height]=roi_from_finger(fp);
            points1 = detectSURFFeatures(fp,'ROI',[x1,y1,width,height]);
            [fc,vpts1] = extractFeatures(fp,points1,'Method','SURF');

            valid_points{i,1}=fc; %cell array
            valid_points{i,2}=vpts1;

            img_segm = insertShape(fp,'rectangle',[x1,y1,width,height],'LineWidth',1);
            imshow(img_segm);hold on;
            plot(points1); hold on;
            plot(x1,y1,'y*'); hold on;
            plot(x1+width,y1+height,'y*');
        end
        save('valid_points.mat', 'valid_points')
    end
end