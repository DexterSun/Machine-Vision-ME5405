function sharp=imsharp(A,k)
A=double(A);
sharpenForce=k;
kernel=[0, -1*sharpenForce,0;-1*sharpenForce, (4*sharpenForce)+1, -1*sharpenForce;0, -1*sharpenForce,0];
image=A;
image_height=size(A,1);
image_width=size(A,2);

for Y = 2:image_height-1
    for X = 2:image_width-1
        NewPixelValue=0;
        for YK = -1:1  
            for XK = -1:1
                PixelValue = A(Y+YK,X+XK);
                NewPixelValue = kernel(YK+2,XK+2)*PixelValue+NewPixelValue;
            end
        end
        image(Y,X)=NewPixelValue;
    end
end
sharp=uint8(image);