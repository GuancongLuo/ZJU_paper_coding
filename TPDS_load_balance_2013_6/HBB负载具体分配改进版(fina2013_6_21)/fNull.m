function [flag,S,H]=fNull(x,n)
j=1;
S=[];
H=[];
for i=(1+n):length(x)
    if abs(x(i)-round(x(i)))>0.001  %���Ч������0.00001
        S(j)=x(i);           %����������
        H(j)=i;              %���
        j=j+1;
    end
end
if isempty(S)==1
    flag=0;
else 
    flag=1;
end