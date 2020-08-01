function [x1,y1, width, height] = roi_from_finger(img)
[M,N]=size(img);
x1=1;
y1=1;

%valori determinati empiricamente.

for y=1:floor(M/2)-1
    if numel(find(img(y,:)==1)) > 10
       y1=y;
       break
    end
end
for y=floor(M/2):M
    if numel(find(img(y,:)==1)) < 7
       height=y-y1;
       break
    end
end
for x=1:floor(N/2)-1
    if numel(find(img(:,x)==1)) > 14
        x1=x;
        break
    end	
end
for x=floor(N/2):N
    if numel(find(img(:,x)==1)) < 8
       width=x-x1;
       break
    end
end
end

