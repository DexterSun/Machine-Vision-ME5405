function [outimg]=RG(grayimg)

%% 
I = grayimg;

figure 
imshow(I,[0,31],'InitialMagnification','fit')
[M,N]=size(I);
[y,x]=getpts; %After clicking to take the point, press enter to end
x1=round(x);
y1=round(y);
seed=I(x1,y1); %Get the gray value of the center pixel

J=zeros(M,N);
J(x1,y1)=1;

count=6; %Number of points to be processed
threshold=1;
while count>0
    count=0;
    for i=1:M %Traverse the entire image
    for j=1:N
        if J(i,j)==1 %Click in the "stack"
        if (i-1)>1&(i+1)<M&(j-1)>1&(j+1)<N %The neighborhood is within the image range
            for u=-1:1 %8-Neighborhood growth
            for v=-1:1
                if J(i+u,j+v)==0&abs(I(i+u,j+v)-seed)<=threshold
                    J(i+u,j+v)=1;
                    count=count+1;  %Record the number of points newly grown this time
                end
            end
            end
        end
        end
    end
    end
end
outimg = J;
figure;
imshow(outimg,'InitialMagnification','fit');
title('Regional growth');
