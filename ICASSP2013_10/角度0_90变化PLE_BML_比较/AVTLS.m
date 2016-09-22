function [OV2,P_Bias, H_Bias] = AVTLS(SB,DOA,UL,NA)  %%%%%Total Least Squareα������С���˷�

% DOA : 1 x n, tʱ�̸������н��յ���������ϵ�µĽǶ���Ϣ;
% Array : n x 2�� tʱ�̸������е�λ��;
lt=length(DOA);          
for i=1:lt
    C(i,1) = sin(DOA(i));
    C(i,2) = -cos(DOA(i));
    C(i,3) = -(SB(i,1)*cos(DOA(i))+SB(i,2)*sin(DOA(i)));
    D(i,1) = sin(DOA(i))*SB(i,1) - cos(DOA(i))*SB(i,2);
end
CD=[C,D];       %�������
[U,S,V]=svd(CD);
V4=V(:,4);
T = -V4(1:3)/V4(4);
% TC=CD'*CD;
% Val=eig(TC'*TC);
% sgm=min(Val);    %��С����ֵ
% T2 = inv(C'*C-sgm*eye(3))*C'*D
X=(T(1)-T(3)*T(2))/(1+T(3)^2);
Y=(T(2)+T(1)*T(3))/(1+T(3)^2);
Fai=atan(T(3));
Tha=atan2(SB(1,2)-Y,SB(1,1)-X);
if  Fai<0
    Fi=Fai+pi;
    if rem(abs(Tha-DOA(1)-Fi),2*pi)>pi/2
        Fi=Fai;
    end
else 
     Fi=Fai;
      if rem(abs(Tha-DOA(1)-Fi),2*pi)>pi/2
        Fi=Fai+pi;
    end
end
P_Bias=sqrt((UL(1)-X)^2+(UL(2)-Y)^2);
H_Bias=abs(Fi-NA)*180/pi;
OV2=[X,Y,Fi];
