function A=m3t2(A)
%Simple dimension reduction
%size(A) should be [1 X Y]
A=reshape(A,[size(A,2),size(A,3)]);
end