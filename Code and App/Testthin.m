%% Load a Image
% close all ;
fileID = fopen('charact1.txt','r');%% open file, permission is 'read'
formatSpec = '%s';%% define load_format as string
size_A = [64,64];
A1 = fscanf(fileID,formatSpec,size_A);
A = A1';
Mapping = [zeros(1,'0'-1) , 0:9 , zeros(1,'A'-'9'-1) , ('A':'Z')-'A' + 10]; %%Map the ascii code table to numbers
img = uint8(Mapping(A));%%Use the map to read the picture and standardize its format to uint8
[m,n] = size(img);
Th=Otsu(img);
%Th
for i=1:m
    for j=1:n
        if img(i,j)>=Th
            img(i,j)=1;
        else
            img(i,j)=0;
        end
    end
end
figure(2);
imshow(img,[0,1],'InitialMagnification','fit');
title('Ostu for binary image','fontsize',8); 

IterThinning = 100 ;
Image = img
Raw = Image ;

for Iter = 1:IterThinning
    OutBW1 = Condition1( Image, 0 ) ;
    OutBW2 = Condition2( OutBW1, 0 ) ;
    Image = OutBW2 ;
end


%% debug and compare the result in Matlab
I = bwmorph(Raw, 'thin',IterThinning );
close all;
figure,imshow( Raw ,[0,1],'InitialMagnification','fit') ;
figure,imshow( I,'InitialMagnification','fit') ;
figure,imshow( OutBW2,'InitialMagnification','fit' ) ;