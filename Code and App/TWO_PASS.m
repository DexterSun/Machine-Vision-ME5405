function [s, outImg, labels ] = TWO_PASS( inputImg )
%Connectivity_Label Self-made connected area analysis function
%   [ outImg, labels ] = MyBwLabel( inputImg )
%   inputIg: The input image requires a two-valued image with a maximum value of 255.
%   outputImg: The output image, different connectivity areas;
%   labels£ºThe number of connected areas.
%

    inputImg = logical(inputImg);
    labels = 1;
    outImg = double( inputImg );
    markFlag = false( size(inputImg) );
    [height , width] = size( inputImg );

    %% first pass
    for ii = 1:height
        for jj = 1:width
            if inputImg(ii,jj) > 0  % If it is the foreground point, it is statistically processed.
                neighbors = [];  % Record the fore fore fore fore forequent points in the required neighborhood, followed by rows, columns, and values.
                if (ii-1 > 0)
                    if (jj-1 > 0 && inputImg(ii-1,jj-1) > 0)
                        neighbors = [neighbors ; ii-1 , jj-1 , outImg(ii-1,jj-1)];
                    end
                    if inputImg(ii-1,jj) > 0
                        neighbors = [neighbors ; ii-1 , jj , outImg(ii-1,jj)];
                    end
                elseif (jj-1) > 0 && inputImg(ii,jj-1) > 0
                    neighbors = [neighbors ; ii , jj-1 , outImg(ii,jj-1)];
                end

                if isempty(neighbors)
                    labels = labels + 1;
                    outImg(ii , jj) = labels;
                else
                    outImg(ii ,jj) = min(neighbors(:,3));
                end

            end
        end
    end

    %% second pass
    [r , c] = find( outImg ~= 0 );
    for ii = 1:length( r )
        if r(ii)-1 > 0
            up = r(ii)-1;
        else
            up = r(ii);
        end
        if r(ii)+1 <= height
            down = r(ii)+1;
        else
            down = r(ii);
        end
        if c(ii)-1 > 0
            left = c(ii)-1;
        else
            left = c(ii);
        end
        if c(ii)+1 <= width
            right = c(ii)+1;
        else
            right = c(ii);
        end

        tmpM = outImg(up:down , left:right);
        [r1 , c1] = find( tmpM ~= 0 );
        if ~isempty(r1)
            tmpM = tmpM(:);
            tmpM( tmpM == 0 ) = [];

            minV = min(tmpM);
            tmpM( tmpM == minV ) = [];
            for kk = 1:1:length(tmpM)
                outImg( outImg == tmpM(kk) ) = minV;
            end

        end
    end

    u = unique(outImg);
    for ii = 2:1:length(u)
        outImg(outImg == u(ii)) = ii-1;
    end
labels = length( u ) - 1;

label_num=unique(outImg(outImg>0));
num=numel(label_num);
%% Combine features that contain relationships
for i = 1:num
    for j = 1:num
        [r1,c1] = find(outImg==label_num(i));
        [r2,c2] = find(outImg==label_num(j));
        center1 = [mean(c1),mean(r1)];
        center2 = [mean(c2),mean(r2)];
        if norm((center1-center2),2)<1
            outImg(outImg == label_num(i)) = label_num(j);
        end
    end
end
label_num=unique(outImg(outImg>0));    
num=numel(label_num);

%% Add as structure
s(num) = struct('Image',[],'address',[],'Centroid',[],'BoundingBox',[]);
 for i=1:num
     [r,c] = find(outImg==label_num(i));
     s(i).address = [r,c];

     r_ = r-min(r)+1;
     c_ = c-min(c)+1;
     s(i).Image = zeros(max(r_),max(c_));
     s(i).boundingframe=[min(c)-0.5,min(r)-0.5,max(c_),max(r_)];
     for q=1:size(r_)
             s(i).Image(r_(q),c_(q))=1;
             s(i).Image=logical(s(i).Image);
     end  
     s(i).Centroid=[mean(c),mean(r)];
     
 end
end