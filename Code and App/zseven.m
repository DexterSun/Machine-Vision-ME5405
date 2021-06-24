function out=zseven(nbhd)
s=sum(nbhd(:))-nbhd(5);
temp1=(2<=s)&&(s<=6);
p=[nbhd(1) nbhd(4) nbhd(7) nbhd(8) nbhd(9) nbhd(6) nbhd(3) nbhd(2)];
pp=[p(2:8) p(1)];
xp=sum((1-p).*pp);
temp2=(xp==1);
prod1=nbhd(4)*nbhd(8)*nbhd(2);
prod2=nbhd(4)*nbhd(6)*nbhd(2);
temp3=(prod1==0)&&(prod2==0);
if temp1&temp2&temp3&nbhd(5)==1
out=0;
else
out=nbhd(5);
end;
end