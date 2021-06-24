close all;
clc;
clear all;


%% which image to run

imagenum = 2; % For task one: 1  For task two: 2
is_full = 1; % 

%% task 1 Image 1
if imagenum == 1
    imethod = 1;
    fileID = fopen('charact1.txt','r');%% open file, permission is 'read'
    formatSpec = '%s';%% define load_format as string
    sizeA = [64,64];
    A1 = fscanf(fileID,formatSpec,sizeA);
    A = A1';
    Mapping = [zeros(1,'0'-1) , 0:9 , zeros(1,'A'-'9'-1) , ('A':'Z')-'A' + 10]; %%Map the ascii code table to numbers
    img = uint8(Mapping(A));%%Use the map to read the picture and standardize its format to uint8
    imshow(img,[0,31],'InitialMagnification','fit');
    title('original');
end

%% task 1 Image 2
if imagenum == 2
    imethod = 2;
    img = imread('charact2.jpg');
    img = rgb2gray(img);
    figure;
    imshow(img,'InitialMagnification','fit');
    title('original');
    sharp_image=imsharp(img,3);
   
    figure;
    imshow(sharp_image,'InitialMagnification','fit');
    title('sharp');
    smooth_image1 = guassianfilter(sharp_image,3,3);
    img = smooth_image1;
    figure;
    imshow(img,'InitialMagnification','fit');
    title('smooth');
end




%% task 2
if imethod == 1
    T = Otsu(img); 
    img1 = binarize(img,T);
end

if imethod == 2
    T = Otsu(img); 
    img1 = binarize(img,T);
end

figure;
imshow(img1,'InitialMagnification','fit');
title('Binary Image');

%% judging
% for image 1 we have 6 characters
% for image 2 we have 15 characters(after pre-processing)
if imethod == 1
    kmax = 6;
    sub1 = 2;
    sub2 = 3;
else
    kmax = 15;
    sub1 = 4;
    sub2 = 4;
end

%% task 3
% use two-pass method to 
[I,llab,num] = TWO_PASS(img1);
img_rgb = label2rgb(llab,'hsv',[0 0 0],'shuffle');
figure;imshow(img_rgb,'InitialMagnification','fit');
s = I;
figure;
for k=1:kmax
    subplot(sub1,sub2,k);
    imshow(s(k).Image,'InitialMagnification','fit');
end


%% 4
centroids=cat(1,s.Centroid);%get the centroid of the image

%rotate 90
figure;
rotate_img=zeros(size(img1,1));
for k=1:kmax
    angle=90;
    subplot(sub1,sub2,k);
    rotateimg=img_rotation1(s(k).Image,angle);
    %imshow(rotateimage)
    crop_img=TWO_PASS(rotateimg);
    crop_img=TWO_PASS(crop_img.Image);
    s1(k) = crop_img;
    imshow(crop_img.Image,'InitialMagnification','fit');
    %get the centroid of the rotated image
    for n=-(round(crop_img.Centroid(:,1)-1)):... 
        size(crop_img.Image,2)-round(crop_img.Centroid(:,1));
        for m=-(round(crop_img.Centroid(:,2)-1)):...
                size(crop_img.Image,1)-round(crop_img.Centroid(:,2))
            if is_full == 1
                if crop_img.Image(round(crop_img.Centroid(:,2))+m,round(crop_img.Centroid(:,1))+n)==1
                    rotate_img(m+round(centroids(k,2)),n+round(centroids(k,1)))=...
                 crop_img.Image(round(crop_img.Centroid(:,2))+m,round(crop_img.Centroid(:,1))+n);
                end
            else
                rotate_img(m+round(centroids(k,2)),n+round(centroids(k,1)))=...
                 crop_img.Image(round(crop_img.Centroid(:,2))+m,round(crop_img.Centroid(:,1))+n);
            end
            %match the centroid of the original image and the rotated image
        end
    end
end
rotate_img=logical(rotate_img);
figure;
imshow(rotate_img,'InitialMagnification','fit');%show the image of rotate 90 degree counterclockwise
hold on
plot(centroids(:,1),centroids(:,2),'R+');
hold off
%%
%rotate 35
rotate_img1=zeros(size(rotate_img,1));

% if imethod == 1
%     t=s1(2).Image;
%     s1(2).Image=s1(3).Image;
%     s1(3).Image=t;
%     t=s1(4).Image;
%     s1(4).Image=s1(5).Image;
%     s1(5).Image=s1(6).Image;
%     s1(6).Image=t;
% end

figure;
for k=1:kmax
    angle=-35;
    subplot(sub1,sub2,k);
    rotateimg=img_rotation1(s1(k).Image,angle);%rotate the crop image with specific angle.
    crop_img=TWO_PASS(rotateimg);
    crop_img=TWO_PASS(crop_img.Image);
    imshow(crop_img.Image);
    %get the centroid of the rotated image
    rotate_centroids=cat(1,crop_img.Centroid);
    for n=-(round(crop_img.Centroid(:,2)-1)):size(crop_img.Image,1)-round(crop_img.Centroid(:,2))
        for m=-(round(crop_img.Centroid(:,1)-1)):...
                size(crop_img.Image,2)-round(crop_img.Centroid(:,1))
            if is_full == 1
                if crop_img.Image(round(crop_img.Centroid(:,2))+n,round(crop_img.Centroid(:,1))+m) == 1
                    rotate_img1(n+round(centroids(k,2)),m+round(centroids(k,1)))=...
                       crop_img.Image(round(crop_img.Centroid(:,2))+n,round(crop_img.Centroid(:,1))+m);
            %match the centroid of the original image and the rotated image
                end
            else
                rotate_img1(n+round(centroids(k,2)),m+round(centroids(k,1)))=...
                       crop_img.Image(round(crop_img.Centroid(:,2))+n,round(crop_img.Centroid(:,1))+m);
            end
        end
    end
    
end
img=logical(rotate_img1);
figure;
imshow(img,'InitialMagnification','fit');%show the image of rotate 90 degree counterclockwise
hold on
plot(centroids(:,1),centroids(:,2),'R+');
hold off




%% 6
IMG = classmethod(img);
figure;
imshow(IMG,[0,1],'InitialMagnification','fit');title('Class Method');


%% 7
[imageRow, imageCol] = size(img);
midPIC = zeros([imageRow+4, imageCol+4]);
midPIC(3:end-2, 3:end-2) = img;
img = midPIC;
img = Hild(img);
figure;
imshow(img,'InitialMagnification','fit'); title('Hilditch Algorithm');



%% task 8
out_img = sequence(I,imethod);
figure;
imshow(out_img,'InitialMagnification','fit');