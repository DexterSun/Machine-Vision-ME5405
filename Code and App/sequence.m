function [scale_image] = sequence(inputimg,imethod)
%% 1
if imethod == 1
scalemax=0;
s = inputimg;
 for i=1:size(s,2)
     if scalemax<size(s(i).Image,1)
     scalemax=size(s(i).Image,1);
     end
 end  
 str= struct('a',{},'b',{});
 for i=1:6
     str(i).a=zeros(scalemax(1),size(s(i).Image,2));
     str(i).a(1:size(s(i).Image,1),1:size(s(i).Image,2))=s(i).Image;
 end
 scale_image=zeros(scalemax(1),1);
 str(1).b=str(4).a;
 str(2).b=str(1).a;
 str(3).b=str(5).a;
 str(4).b=str(2).a;
 str(5).b=str(6).a;
 str(6).b=str(3).a;
 for i=1:size(str,2)
      scale_image=cat(2,scale_image,zeros(scalemax(1),1),str(i).b);
 end
end

%% 1
if imethod == 2
scalemax=0;
s = inputimg;
 for i=1:size(s,2)
     if scalemax<size(s(i).Image,1)
     scalemax=size(s(i).Image,1);
     end
 end  
 str= struct('a',{},'b',{});
 for i=1:15
     str(i).a=zeros(scalemax(1),size(s(i).Image,2));
     str(i).a(1:size(s(i).Image,1),1:size(s(i).Image,2))=s(i).Image;
 end
 scale_image=zeros(scalemax(1),1);
 seqq = [3 5 1 12 13 14 7 8 4 2 15 11 9 10];
 for jj = 1:14
     str(jj).b = str(seqq(jj)).a;
 end
 for i=1:size(str,2)
      scale_image=cat(2,scale_image,zeros(scalemax(1),1),str(i).b);
 end
end
end
 
 
 