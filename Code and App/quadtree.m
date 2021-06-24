function [outimg] = quadtree(inputImg)
%% Resize
sizeA = [64,64];
I = uint8(inputImg);
I2 = uint8(ones(sizeA));
I = 8.*(I + ones) - I2;
I=imresize(I,[512 512]);
%% Image quadtree segmentation
S = qtdecomp(I,.1);

%% Construct a new image
newimg=zeros(size(I)); 
newimg(:,:)=getblocks(S,I(:,:));

newimg=uint8(newimg);
GK=zeros(1,32);             %Pre-create a vector that stores the probability of grayscale occurrence
for k=0:31
     GK(k+1)=length(find(newimg==k))/(32*32);    %¼ÆCalculate the probability of each gray level and store it in the corresponding position in GK
end
outimg = newimg;
figure;
imshow(outimg,[0,31],'InitialMagnification','fit');
title('Quadtree Image');

