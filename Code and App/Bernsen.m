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
 imshow(img,[0,31]); %imshow（I，[min(I(:)) max(I(:))]）I中数值最大值与最小值分别为31和0
 title('orginal image','fontsize',8);
[m,n] = size(img);
I_gray=double(img);
T=zeros(m,n);
M=3;
N=3; 
for i=M+1:m-M
    for j=N+1:n-N
        max=1;min=255;
        for k=i-M:i+M 
            for l=j-N:j+N
                if I_gray(k,l)>max
                    max=I_gray(k,l);
                end
                if I_gray(k,l)<min
                    min=I_gray(k,l);
                end
            end
        end
        %T(i,j)=(max+min)/2;
         T(i,j)=(max+min)/2;
    end
end 
  I_bw=zeros(m,n);
  for i=1:m
      for j=1:n
         if I_gray(i,j)>T(i,j)
              I_bw(i,j)=1;
          else
              I_bw(i,j)=0;
         end
      end
  end 
  Img=logical(I_bw);
figure(2)
imshow(Img);
title('Bernsen algorithm');
  
 