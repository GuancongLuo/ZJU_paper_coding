function [P_Bias, H_Bias] = TRI(SB,DOA,UL,NA)  %%%%%伪线性最小二乘法PLS
% DOA : 1 x n, t时刻各个阵列接收到绝对坐标系下的角度信息;
% Array : n x 2， t时刻各个阵列的位置;
lt=length(DOA);   
VT=nchoosek(1:lt,3);
for j=1:length(VT(:,1))
    VC=VT(j,:);
    j1=VC(1);
    j2=VC(2);
    j3=VC(3);
    BN1=SB(j1,:);
    BN2=SB(j2,:);
    BN3=SB(j3,:);
    AOA1=abs(DOA(j1)-DOA(j2));
    if AOA1>pi
        AOA1=2*pi-AOA1;
    end
    a=(BN1(1)-BN2(1))^2+(BN1(2)-BN2(2))^2;
    AOA2=abs(DOA(j1)-DOA(j3));
    if AOA2>pi
        AOA2=2*pi-AOA2;
    end
    b=(BN1(1)-BN3(1))^2+(BN1(2)-BN3(2))^2;
    AOA3=abs(DOA(j2)-DOA(j3));
    if AOA3>pi
        AOA3=2*pi-AOA3;
    end
    c=(BN2(1)-BN3(1))^2+(BN2(2)-BN3(2))^2;
    syms x y z
    [x y z]=solve(x^2+y^2-2*x*y*cos(AOA1)-a,x^2+z^2-2*x*z*cos(AOA2)-b,y^2+z^2-2*y*z*cos(AOA3)-c);
    x=vpa(x,5);
    y=vpa(y,5);
    z=vpa(z,5);
    dx=abs(x);
    dy=abs(y);
    dz=abs(z);
    XYZ=[dx,dy,dz];
    xyz=double(XYZ);
    SDT=unique(xyz,'rows');
    kj=1;
    for ji=1:length(SDT(:,1))
        DT=SDT(ji,:);
        if DT(1)>=1 && DT(2)>=1 && DT(1)<=200 && DT(2)<=200 && DT(3)<=200 && DT(3)>=1
           TX(kj,:)=DT;
           kj=kj+1;
        end
    end
    TX
  
end
   P_Bias=0;
   H_Bias=0;

% for i=1:lt
%     C(i,1) = sin(DOA(i));
%     C(i,2) = -cos(DOA(i));
%     C(i,3) = -(SB(i,1)*cos(DOA(i))+SB(i,2)*sin(DOA(i)));
%     D(i,1) = sin(DOA(i))*SB(i,1) - cos(DOA(i))*SB(i,2);
% end
% T = inv(C'*C)*C'*D;
% X=(T(1)-T(3)*T(2))/(1+T(3)^2);
% Y=(T(2)+T(1)*T(3))/(1+T(3)^2);
% Fai=atan(T(3)); 
% if Fai<0
%     Fai=Fai+pi;            %修正角度
% end
% P_Bias=sqrt((UL(1)-X)^2+(UL(2)-Y)^2);
% H_Bias=abs(Fai-NA)*180/pi;
% OV=[X,Y,Fai];