function [XY, PH_Bias] = PLS1(SB,DOA,UL,NA)  %%%%%α������С���˷�PLS

% DOA : 1 x n, tʱ�̸������н��յ���������ϵ�µĽǶ���Ϣ;
% Array : n x 2�� tʱ�̸������е�λ��;
lt=length(DOA);          
for i=1:lt
    C(i,1) = SB(i,1)*cos(DOA(i))+SB(i,2)*sin(DOA(i));
    C(i,2) = cos(DOA(i));
    C(i,3)=-sin(DOA(i));
    D(i,1) = -sin(DOA(i))*SB(i,1) + cos(DOA(i))*SB(i,2);
end
T = inv(C'*C)*C'*D;
X=(T(3)-T(1)*T(2))/(1+T(1)^2);
Y=(T(2)+T(1)*T(3))/(1+T(1)^2);
XY=[X,Y];
Fai=atan(T(1)); 
if Fai<0
    Fai=Fai+pi;            %�����Ƕ�
end
P_Bias=sqrt((UL(1)-X)^2+(UL(2)-Y)^2);
H_Bias=abs(Fai-NA)*180/pi;
PH_Bias=[P_Bias,H_Bias];