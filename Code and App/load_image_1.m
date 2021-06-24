clear all
%%task 1
fileID = fopen('charact1.txt','r');%% open file, permission is 'read'
formatSpec = '%s';%% define load_format as string
sizeA = [64,64];
A1 = fscanf(fileID,formatSpec,sizeA);
A = A1';
Mapping = [zeros(1,'0'-1) , 0:9 , zeros(1,'A'-'9'-1) , ('A':'Z')-'A' + 10]; %%Map the ascii code table to numbers
img1 = uint8(Mapping(A));%%Use the map to read the picture and standardize its format to uint8


%% binarize
T = Otsu(img1);
img1 = binarize(img1,1);
%% Segment
[O,I,num] = Connectivity_Label(img1);
img_rgb = label2rgb(O,'hsv',[.5 .5 .5],'shuffle');
figure,imshow(img_rgb,'InitialMagnification','fit');
hold on；
s = I;
figure(2)
for k=1:6
    subplot(2,3,k);
    imshow(s(k).Image);
end


%% Arrange the characters
figure(3);
out_img = sequence(s);
imshow(out_img,'InitialMagnification','fit');

   
      


