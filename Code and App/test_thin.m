function IMG = test_thin(img)
IterThinning = 100 ;
Image = img
Raw = Image ;

for Iter = 1:IterThinning
    OutBW1 = Condition1( Image, 0 ) ;
    OutBW2 = Condition2( OutBW1, 0 ) ;
    Image = OutBW2 ;
end
IMG = OutBW2