function T=Otsu(img)
[m,n]=size(img);
img=double(img);
count=zeros(256,1);
pcount=zeros(256,1);
for i=1:m
    for j=1:n
        p=img(i,j);
        count(p+1)=count(p+1)+1;
    end
end
%figure(3);
%plot(count);bar(0:255,count,'b');

dw=0; 
for i=0:255
    pcount(i+1)=count(i+1)/(m*n);
    dw=dw+i*pcount(i+1);
end
%figure(4);
%plot(pcount);bar(0:255,pcount,'b');

Th=0;
Th_best=0;
dfc_max=0;
while(Th>=0 && Th<=255) 
    dp_l=0;
    dw_l=0;
    for i=0:Th
        dp_l=dp_l+pcount(i+1); 
        dw_l=dw_l+i*pcount(i+1); 
    end
    if dp_l>0 
        dw_l=dw_l/dp_l;
    end
    dp_h=0;
    dw_h=0;
    for i=Th+1:255
        dp_h=dp_h+pcount(i+1); 
        dw_h=dw_h+i*pcount(i+1); 
    end
     if dp_h>0
        dw_h=dw_h/dp_h;
     end
    dfc=dp_l*(dw_l-dw)^2+dp_h*(dw_h-dw)^2; 
    if dfc>=dfc_max 
    dfc_max=dfc;
    Th_best=Th;
    end
    Th=Th+1;
end
T=Th_best;
imageout=struct('image',[],'Th',[]);
img(img<T)=0;
img(img>T)=1;
img=logical(img);
imageout.Th=T;
imageout.image=img;
end