function [flag,S,H]=fNull(x,n)
j=1;
S=[];
H=[];
%������ȷλ������������������Ŀ���Ե�������0.0001-0.01֮�䣻
%������������Ŀn����ʱ���ο�Ϊ0.001-0.0001;������������Ŀ����ʱ���ο�Ϊ0.01-0.001;
factor=0.01;  
for i=(1+n):length(x)
    if abs(x(i)-round(x(i)))>factor %0.001���Ե�
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