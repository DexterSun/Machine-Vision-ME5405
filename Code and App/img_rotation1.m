function img_rotate=img_rotation1(img1,angle)

[m, n, o] = size(img1);
new_n = ceil(abs(n*cosd(angle)) + abs(m*sind(angle)));
new_m = ceil(abs(m*cosd(angle)) + abs(n*sind(angle)));

% reverse mapping matrices
rm1 = [1 0 0; 0 -1 0; -0.5*new_n 0.5*new_m 1];
rm2 = [cosd(angle) sind(angle) 0; -sind(angle) cosd(angle) 0; 0 0 1];
rm3 = [1 0 0; 0 -1 0; 0.5*n 0.5*m 1];

for i = 1:new_n
   for j = 1:new_m
       % rotated image's coordinates to no-rotation image's coordinates
      old_coordinate = [i j 1]*rm1*rm2*rm3;
      col = round(old_coordinate(1));
      row = round(old_coordinate(2));
      % prevent border overflow 
      if row < 1 || col < 1 || row > m || col > n
          new_img_nnp(j, i) = 0;
          new_img_lp(j, i) = 0;
      else
          % nearest neighbor interpolation
          new_img_nnp(j, i, 1) = img1(row, col, 1);
          
          % bilinear interpolation
          left = floor(col);
          right = ceil(col);
          top = floor(row);
          bottom = ceil(row);
          
          a = col - left;
          b = row - top;
          new_img_lp(j, i, 1) = (1-a)*(1-b)*img1(top, left, 1) + a*(1-b)*img1(top, right, 1) + ...
              (1-a)*b*img1(bottom, left, 1) + a*b*img1(bottom, right, 1);
      end
   end
end
img_rotate=logical(new_img_lp);