function result=c_number(P)
N = 0;
for k = 1:4
    temp = ~P(2*k-1) - ~P(2*k-1)*~P(2*k)*~P(2*k+1);
    N = N + temp;
end
result = N;