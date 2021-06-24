function imageout=guassianfilter(imagein,k,I)
imagein=double(imagein);
M=zeros(k,k);
re=floor(k/2);
for i=1:k
    for j=1:k
        M(i,j)=1/(2*pi*I^2)*exp(-((i-1-re)^2+(j-1-re)^2)/2/I^2);

    end
end
average=sum(sum(M));
M=M./average;
imagein=padarray(imagein,[k,k],0);
[r,c]=size(imagein);
imageout=imagein;
for i=1+re:r-re
    for j=1+re:c-re
        imageout(i,j)=sum(sum(imagein(i-re:i+re,j-re:j+re).*M));
    end
end

%%
imageout=uint8(round(imageout(1+k:end-k,1+k:end-k)));
end