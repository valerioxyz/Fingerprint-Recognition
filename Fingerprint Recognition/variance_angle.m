function y = variance_angle(matchedPoints1,matchedPoints2,img1)

    length=matchedPoints1.Count;
    if(length==0 || length==1 || length==2)
       y=1000; 
    else
        C=zeros(length,1);
        for i=1:length
            x1=matchedPoints1.Location(i,1);
            y1=matchedPoints1.Location(i,2);
            x2=matchedPoints2.Location(i,1);
            y2=matchedPoints2.Location(i,2);
            A=[x1,x2+size(img1,2)];
            B=[y1,y2];
            C(i)=angle_between_vectors(A,B);
        end

        %più le linee sono parallele più sarà bassa la varianza =>
        %corrispondenza pratica!
        y=var(C);
    end
end

