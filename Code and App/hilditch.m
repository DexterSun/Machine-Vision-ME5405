
% PIC = imread('shou.bmp');
% 
% if islogical(PIC) == 0
%     PIC = im2bw(PIC);
% end
clc;
clear all;
close all;

fileID = fopen('charact1.txt','r');%% open file, permission is 'read'
formatSpec = '%s';%% define load_format as string
size_A = [64,64];
A1 = fscanf(fileID,formatSpec,size_A);
A = A1';
Mapping = [zeros(1,'0'-1) , 0:9 , zeros(1,'A'-'9'-1) , ('A':'Z')-'A' + 10]; %%Map the ascii code table to numbers
img = uint8(Mapping(A));%%Use the map to read the picture and standardize its format to uint8
figure(1);
imshow(img,[0,31],'InitialMagnification','fit'); %imshow（I，[min(I(:)) max(I(:))]）
title('orginal image','fontsize',8);

%% 2
% 2.Create a binary image using thresholding
% I1=Mapping(A)
% img = imread(img);
[m,n] = size(img);
Th=Otsu(img);
%Th
for i=1:m
    for j=1:n
        if img(i,j)>=Th
            img(i,j)=255;
        else
            img(i,j)=0;
        end
    end
end
img;
figure(2);
imshow(img,'InitialMagnification','fit');
title('Ostu for binary image','fontsize',8); 

%% 1
PIC = img/255;
[imageRow, imageCol] = size(PIC);
midPIC = zeros([imageRow+4, imageCol+4]);
midPIC(3:end-2, 3:end-2) = PIC;
PIC = midPIC;

PIC2 = PIC;                   % pic2 is used for the use of MATLAB's own refinement function for effect comparison

out1 = Hild(PIC)
out2 = thinor(PIC)
Out0 = bwmorph(PIC2, 'thin', inf);
ZhangS = zs(PIC2)
Test = test_thin(PIC)
%% Output & result comparison
close all;
figure;

subplot(2,3,1); imshow(PIC2,'InitialMagnification','fit'); title('Original Image')
subplot(2,3,2); imshow(out1,'InitialMagnification','fit'); title('Hilditch Algorithm')
subplot(2,3,3); imshow(Out0,'InitialMagnification','fit'); title('Matlab Function')
subplot(2,3,4); imshow(ZhangS,'InitialMagnification','fit'); title('Zhang Fast Algorithm')
subplot(2,3,5); imshow(out2,'InitialMagnification','fit'); title('what is this')
subplot(2,3,6); imshow(Test,'InitialMagnification','fit'); title('test thin')
