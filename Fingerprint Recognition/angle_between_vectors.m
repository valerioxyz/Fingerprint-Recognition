function [ThetaInDegrees] = angle_between_vectors(u,v)
%fa riferimento all'origine degli assi cartesiani

%ogni punto (ad esempio u) fa riferimento ad una retta passante per (0,0) & il punto u 

cosTheta = max(min(dot(u,v)/(norm(u)*norm(v)),1),-1);
ThetaInDegrees = real(acosd(cosTheta));

end


