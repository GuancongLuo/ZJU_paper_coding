function [flag,S,H]=fNull(x,n)
jm=1;
S=[];
H=[];
factor=0.001;
for im=(1+n):length(x)
    if abs(x(im)-round(x(im)))>factor
        S(jm)=x(im);           %����������
        H(jm)=im;              %���
        jm=jm+1;
    end
end
if isempty(S)==1
    flag=0;
else 
    flag=1;
end