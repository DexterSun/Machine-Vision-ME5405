function IMG = thinor(img)

MaskBW = zeros(size(img)+2) ;
MaskBW([2:end-1],[2:end-1]) = img ;
img = MaskBW ;
img = double( img ) ;
OutBW = img ;
[row col] = find( img == 1 ) ;


for i = 1 : length(row)
        indx = row(i) ;
        indy = col(i) ;
%         if debug == 1
%             if indx == 189 && indy == 28            
%                 close all ;
%                 imshow(img) ;
%                 hold on ;
%                 plot(indy,indx,'r*') ;
%             end
%         end
        Mask = [ img(indx-1,indy-1) img(indx-1,indy) img(indx-1,indy+1) ;...
                 img(indx,indy-1  ) img(indx,indy)   img(indx,indy+1  ) ;...
                 img(indx+1,indy-1) img(indx+1,indy) img(indx+1,indy+1) ];
%% Condition 1        
             if Mask(2,3) == 0 && ( Mask(1,3) == 1 || Mask(1,2) == 1)
                 b1 = 1;
             else
                 b1 = 0;
             end
             if Mask(1,2) == 0 && ( Mask(1,1) == 1 || Mask(2,1) == 1)
                 b2 = 1;
             else
                 b2 = 0;
             end
             if Mask(2,1) == 0 && ( Mask(3,1) == 1 || Mask(3,2) == 1)
                 b3 = 1;
             else
                 b3 = 0;
             end
             if Mask(3,2) == 0 && ( Mask(3,3) == 1 || Mask(2,3) == 1)
                 b4 = 1;
             else
                 b4 = 0;
             end
             b = b1 + b2 + b3 + b4 ; 
         
%% Condition 2
            Mask = logical(Mask) ;
            N1 = double( Mask(2,3) | Mask(1,3) ) + double( Mask(1,2) | Mask(1,1) ) + double( Mask(2,1) | Mask(3,1) ) + double( Mask(3,2) | Mask(3,3) );
            N2 = double( Mask(1,3) | Mask(1,2) ) + double( Mask(1,1) | Mask(2,1) ) + double( Mask(3,1) | Mask(3,2) ) + double( Mask(3,3) | Mask(2,3) ) ;
            NCondition2 = min(N1,N2) ;
            
            
%% Condition 3
            Mask = logical(Mask) ;
            Mask(3,3) = ~Mask(3,3) ;
            
            NCondition3 = ( Mask(1,3) | Mask(1,2) | Mask(3,3) ) & Mask(2,3) ;
            
%% Judgement
             if NCondition3 == 0 && NCondition2>=2 && NCondition2<=3 && b == 1
                 OutBW(indx,indy) = 0 ;
             end            
end
IMG = OutBW([2:end-1],[2:end-1]) ;