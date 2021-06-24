function out=zs(im)
%
%zs appises the Zhang-Suen skeletonization algorithm to image IM. IM must
%be binary.
%
luteven=makelut('zseven',3);
lutodd=makelut('zsodd',3);
done=0;
N=2;
last=im;
previous=applylut(last ,lutodd);
current=applylut(previous,luteven);
while done==0,
if all(current(:)==last(:)),
done=1;
end
N=N+1;
last=previous;
previous=current;
if mod(N,2)==0,
current=applylut(current,luteven);
else
current=applylut(current,lutodd);
end;

end;
out=current;
end