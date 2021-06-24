function ireg=iregion(img,i,j,dim)
tempt=img(i:(i+dim-1),j:(j+dim-1));
tempt=tempt(:);
ireg=mean(tempt);
end