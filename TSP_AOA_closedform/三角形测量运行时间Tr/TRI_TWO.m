function [P_Bias, H_Bias] = TRI_TWO(SB,DOA,UL,NA)  %%%%%伪线性最小二乘法PLS
% DOA : 1 x n, t时刻各个阵列接收到绝对坐标系下的角度信息;
% Array : n x 2， t时刻各个阵列的位置;
% global SIGMA
lt=length(DOA);  
VT=nchoosek(1:lt,2);
ko=0;
L=length(VT(:,1));
tt1=cputime;
for j=1:L
    VC=VT(j,:);
    j1=VC(1);
    j2=VC(2);
    BN1=SB(j1,:);
    BN2=SB(j2,:);
    AOA1=abs(DOA(j1)-DOA(j2));
    if AOA1>pi
        AOA1=2*pi-AOA1;
    end
    if AOA1> pi/2
        AOA1=2*pi-2*AOA1;
    end
    AOA=2*AOA1;
    d2=(BN1(1)-BN2(1))^2+(BN1(2)-BN2(2))^2;%信标之间的距离
    r2=d2/(2-2*cos(AOA));
    tm1=cputime;
    syms x y
    [x y]=solve((x-BN1(1))^2+(y-BN1(2))^2-r2,2*(BN2(1)-BN1(1))*x+BN1(1)^2-BN2(1)^2+2*(BN2(2)-BN1(2))*y+BN1(2)^2-BN2(2)^2);
    x=vpa(x,6);
    y=vpa(y,6);
    XY=[];
    XY=[x,y];
    xy=[];
    xy=double(XY);
    O1=[];
    O1=unique(xy,'rows');%排序
    if isempty(O1)==1
        LO=0;
    else
       LO=length(O1(:,1));
    end
    for ii=1:LO
        OO=O1(ii,:);
        Xr=sqrt((OO(1)-UL(1))^2+(OO(2)-UL(2))^2);
        dd=abs(Xr-sqrt(r2));
        if dd<15
            ko=ko+1;
            O(ko,:)=OO;
            DR(ko)=r2;  
        end
    end
end
tt2=cputime;
T2=tt2-tt1;
% XE=[];
% RN=[];
% XN=O(ko,:); % last one beacon
% RN=DR(ko);  %r^2
% if ko<L
%     L=ko;
% end
% for ij=1:L
%     XB=O(ij,:); %beacon
%     C(ij,1) = 2*(XB(1)-XN(1));
%     C(ij,2) = 2*(XB(2)-XN(2));
%     D(ij,1) = XB(1)^2-XN(1)^2+XB(2)^2-XN(2)^2-DR(ij)+RN;
% end
% XY = inv(C'*C)*C'*D;
% ADOA=atan2(SB(:,2)-XY(2),SB(:,1)-XY(1));
% % kd=0;
% for di=1:length(ADOA)
%     ORI=ADOA(di);
%     if ORI<0
%         ORI=ORI+2*pi;
%         Hd=abs(ORI-DOA(di));
%     else
%         Hd=abs(ORI-DOA(di));
%     end
%     if Hd>pi
%         Hd=2*pi-Hd;
%     end
%     kd=kd+1;
%     HB(kd)=abs(Hd-NA)*180/pi;
% end
H_Bias=180/pi;
P_Bias=NA-10;