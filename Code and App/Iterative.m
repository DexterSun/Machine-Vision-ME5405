function T=Iterative(img)
I=img;
 
zmax=max(max(I));
zmin=min(min(I));
T=(zmax+zmin)/2; 
bcal=1;  
[m,n]=size(I);  
while(bcal)  

    iforeground=0;  
    ibackground=0;  
 
    foregroundsum=0;  
    backgroundsum=0;  
    for i=1:m  
        for j=1:n  
            tmp=I(i,j);
            if(tmp>=T)
              
                iforeground=iforeground+1;  
                foregroundsum=foregroundsum+double(tmp);  
            else  
                ibackground=ibackground+1;  
                backgroundsum=backgroundsum+double(tmp);  
            end  
        end  
    end  
   
    z1=foregroundsum/iforeground;  
    z2=backgroundsum/ibackground;  
    tktmp=uint8((z1+z2)/2); 
    if(tktmp==T)  
        bcal=0;  
    else
        T=tktmp;
    end

imageout=struct('image',[],'Th',[]);
img(img<T)=0;
img(img>T)=1;
img=logical(img);
imageout.Th=T;
imageout.image=img;
end  