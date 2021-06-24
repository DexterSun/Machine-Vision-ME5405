% class method
% assume we have binarized the image with gray-levels 0 and 1

function IMG = classmethod(img)
LB = 0;
LE = 1;
[height,width] = size(img);
B = zeros(height,width);
C = zeros(height,width);
for i = 2:height
    for j = 2:width
        if img(i,j) == img(i,j-1)
            B(i,j) = LB;
        else
            B(i,j) = LE;
        end
    end
end

for j = 2:width
    for i = 2:height
        if img(i,j) == img(i-1,j)
            C(i,j) = LB;
        else
            C(i,j) = LE;
        end
    end
end

for i = 2:height
    for j = 2:width
        if B(i,j)==LE || C(i,j)==LE
            img(i,j) = LE;
        else
            img(i,j) = 0;
        end
    end
end
IMG = img;
            