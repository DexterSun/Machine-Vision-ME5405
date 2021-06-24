function [s,label_image,label_num]=BFS_connectivity(input_image,type)
%% initialization
if nargin<2
    type=4;
end
    [row,column,layers] = size(input_image);
    assert(type==4||type==8,'Warning: parameter "type" is only allowed to be assigned as 4 or 8');
    assert(row>2 && column>2 && layers==1);
    assert(numel(find(input_image==1))+numel(find(input_image==0))==numel(input_image));
    
    
    label_image = zeros(row,column);
    label_counter = 1;
%% traverse labeling
    for i=1:row
        for j=1:column
            if input_image(i,j) == 1
                label_image(i,j) = label_counter;
                label_counter = label_counter+1;
            end
        end
    end
    
if type==4
    

     while true
         temp = label_image;
         for i=2:row-1
             for j=2:column-1
                if label_image(i,j)~=0
                     adjunct=[label_image(i,j),label_image(i+1,j),label_image(i,j+1),...
                     label_image(i-1,j),label_image(i,j-1)];                       
                     label = min(adjunct(adjunct>0));
                           if numel(label) ~= 0                         
                                label_image(i,j)=label;
                           end
                end
             end
         end
         if temp==label_image
             break
         end
     end
elseif type==8
      while true
         temp = label_image;
         for i=2:row-1
             for j=2:column-1
                if label_image(i,j)~=0
                     adjunct=[label_image(i,j),label_image(i+1,j),label_image(i,j+1),...
                        label_image(i-1,j),label_image(i,j-1),label_image(i-1,j-1),...
                        label_image(i-1,j+1),label_image(i+1,j-1),label_image(i+1,j+1)];                       
                     label = min(adjunct(adjunct>0));
                           if numel(label) ~= 0                         
                                label_image(i,j)=label;
                           end
                end
             end
         end
         if temp==label_image
             break
         end
     end
end



%%
label_num=unique(label_image(label_image>0));
num=numel(label_num);

s(num) = struct('Image',[],'address',[]);
 for i=1:num
     [r,c] = find(label_image==label_num(i));
     s(i).address = [r,c];
     r_ = r-min(r)+1;
     c_ = c-min(c)+1;
     s(i).Image = zeros(max(r_),max(c_));
     for q=1:size(r_)
             s(i).image(r_(q),c_(q))=1;
     end  
end
 
%%
disp(['You are using ',num2str(type), ' connection method.']);
disp(['Congratulations! ',num2str(num), ' connected area(s) found!']);
end
