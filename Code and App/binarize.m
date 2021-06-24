function [outImg] = binarize( inputImg,T )
%% 
[m,n] = size(inputImg);
outImg = zeros(m,n);
for i = 1:m
    for j =1:n
        if inputImg(i,j)<T
            outImg(i,j) =0;
        else 
            outImg(i,j) = 1;
        end
    end
end

            
