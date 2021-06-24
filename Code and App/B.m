close all;
clc;
clear all;
%%task 1
fileID = fopen('charact1.txt','r');%% open file, permission is 'read'
formatSpec = '%s';%% define load_format as string
sizeA = [64,64];
A1 = fscanf(fileID,formatSpec,sizeA);
A = A1';
Mapping = [zeros(1,'0'-1) , 0:9 , zeros(1,'A'-'9'-1) , ('A':'Z')-'A' + 10]; %%Map the ascii code table to numbers
img = uint8(Mapping(A));%%Use the map to read the picture and standardize its format to uint8
imshow(img);
title('original');
%% 
% Otsu
T = Otsu(img);
img1 = logical(binarize(img,T));
figure(1);
imshow(img1);
title('Otsu algorithm');
%Iterative
T = Iterative(img)
img2 = logical(binarize(img,T));
figure(2);
imshow(img2);
title('Iterative algorithm');
%Kittler algorithm
T = Kittler(img)
img3 = logical(binarize(img,T));
figure(3);
imshow(img3);
title('Kittler algorithm');
%Bernsen
%T = Bernsen(img)
% figure(4);
% imshow(img4);
%title('Bernsen algorithm');
I=img;
title('srcImage');
I1=myimrotate(I,30);     %调用myimrotate()函数旋转30° 
I2=myimrotate(I,-90);     %调用myimrotate()函数旋转-90°
figure,imshow(I1);
title('旋转30°：I1');
figure,imshow(I2);
title('旋转-90°：I2');
