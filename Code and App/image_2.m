

% Otsu
sharp_image=imsharp(image2,3);
subplot(3,4,3);
imshow(sharp_image);
smooth_image1 = guassianfilter(sharp_image,7,5);
subplot(3,4,4);
imshow(smooth_image1);
binary_image=otsu(smooth_image1,256,117);
binary_image=binary_image.image;
subplot(3,4,5);
imshow(binary_image);
T = Otsu(img); 
img1 = binarize(img,T);

figure;
imshow(img1,'InitialMagnification','fit');
title('Otsu algorithm');

%% judging
if imethod == 1
    kmax = 6;
    sub1 = 2;
    sub2 = 3;
else
    kmax = 13;
    sub1 = 3;
    sub2 = 5;
end

%% task 3
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
    imshow(crop_img.Image,'InitialMagnification','fit');
    %get the centroid of the rotated image
    for n=-(round(crop_img.Centroid(:,1)-1)):... %Y = round(X),对元素四舍五入
        size(crop_img.Image,2)-round(crop_img.Centroid(:,1));
        for m=-(round(crop_img.Centroid(:,2)-1)):...
                size(crop_img.Image,1)-round(crop_img.Centroid(:,2))
            rotate_img(m+round(centroids(k,2)),n+round(centroids(k,1)))=...
                crop_img.Image(round(crop_img.Centroid(:,2))+m,round(crop_img.Centroid(:,1))+n);
            %match the centroid of the original image and the rotated image
        end
    end
end
rotate_img=logical(rotate_img);
figure;
imshow(rotate_img,'InitialMagnification','fit');%show the image of rotate 90 degree counterclockwise
hold on
plot(centroids(:,1),centroids(:,2),'R+');
hold on
%%
%rotate 35
rotate_img1=zeros(size(rotate_img,1));
s1=TWO_PASS(rotate_img);
t=s1(1).Image;
s1(1).Image=s1(2).Image;
s1(2).Image=s1(3).Image;
s1(3).Image=t;

t=s1(5).Image;
s1(5).Image=s1(6).Image;
s1(6).Image=t;
for k=1:6
    angle=-35;
    subplot(2,3,k);
    rotateimg=img_rotation1(s1(k).Image,angle);%rotate the crop image with specific angle.
    crop_img=TWO_PASS(rotateimg);
    crop_img=TWO_PASS(crop_img.Image);
    imshow(crop_img.Image);
    %get the centroid of the rotated image
    rotate_centroids=cat(1,crop_img.Centroid);
    for n=-(round(crop_img.Centroid(:,2)-1)):size(crop_img.Image,1)-round(crop_img.Centroid(:,2))
        for m=-(round(crop_img.Centroid(:,1)-1)):size(crop_img.Image,2)-round(crop_img.Centroid(:,1))
            rotate_img1(n+round(centroids(k,2)),m+round(centroids(k,1)))=crop_img.Image(round(crop_img.Centroid(:,2))+n,round(crop_img.Centroid(:,1))+m);
            %match the centroid of the original image and the rotated image
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
out_img = sequence(s);
figure;
imshow(out_img,'InitialMagnification','fit');