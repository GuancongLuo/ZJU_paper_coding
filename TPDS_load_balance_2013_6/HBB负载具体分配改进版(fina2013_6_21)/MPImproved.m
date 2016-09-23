clc,clear;                    %��Ԫ��������������ĸ���ʵʱ���ȼ�ع������ƽ̨ ����ʽ�㷨
tic
format short                   %���Թ滮����
M=[5000 4000 4000];           %�������ķ����������Ŀ 
F=[];
Pr1=[34.8 33.2 28 25.6 25 24.6 22.8 24.8 27.2 31.85 33.4 35.2 36.2 36.2 36.8 37.2 38.5 40.4 41 42.4 41.7 47.1 45.2 36.6;...
74.73 74.73 74.73 74.73	74.73 74.73 74.73 74.73	74.73 74.73	74.73 74.73	74.73 74.73	74.73 74.73 74.73 74.73 74.73 74.73 74.73 74.73 74.73 74.73;...
19.35 18.2 17.87 17.99 20.54 21.95 25.79 29.22 34.38 36.58 38.23 37.93 39.5 49.94 55.45	50.93 42.49	36.91 36.73	36.09 30.4 27.14 25.73 21.03]';

%%%%%%ת����ʱ%%%%%%%%%%%
% %DL1=[1.5 1 2 2.5 3 3.3 3.2 2 2.5 2.1 3.2 4.5 2.5 2.1 2 2 2.1 2.3 2.1 3 5.3 2 2 1.9;53 42 40 55 60 70 80 91 92 98 90 88 87 85 82 80 84 86 88 93 72 54 52 51;...
%      37 33 30 40 50 55 60 72 78 82 87 89 82 75 64 65 62 67 88 75 55 48 44 35;62 56 50 46 54 76 84 90 84 87 94 99 90 88 83 80 90 91 94 100 85 77 70 77]/1000;
% DL2=[58 54 53 60 66 70 75 80 90 95 96 90 89 88 76 77 82 85 89 96 78 65 55 56;2.3 1.8 2 2.3 2.5 2.8 2.7 3.2 3.4 3.6 3.8 4.4 3.5 3.2 2.4 2 2.2 2.5 2.9 2.8 3.6 1.5 1 1;...
%      26 24 23 25 29 32 40 53 62 68 74 78 73 72 70 66 64 66 68 71 75 64 45 35;8 6 6.5 6 8 12 16 20 25 27 30 32 26 25 22 21 19 19 20 29 25 20 18 13]/1000;
% DL3=[44 37 35 40 45 57 67 75 80 80 85 86 83 83 78 70 67 69 72 84 65 58 44 40;36 33 27 30 35 43 51 62 72 72 74 77 70 69 68 58 60 65 68 71 56 45 38 39;...
%     1.1 1.2 1.5 2 2.4 2.8 2.5 3 3.6 3.7 2.9 2.8 2.7 2.6 2.1 2 2 2.5 3.4 1.5 1.6 1.5 1.1 1;38 38 36 37 35 46 56 65 73 75 78 75 72 74 70 64 67 69	77 73 64 55 46 40]/1000;
L1=30000*ones(1,24);
L2=40000*ones(1,24);
L3=40000*ones(1,24);
L4=30000*ones(1,24);
% xlswrite('L1',L1');
% xlswrite('L2',L2');
% xlswrite('L3',L3');
% xlswrite('L4',L4');
% L1=xlsread('L1');
% L2=xlsread('L2');
% L3=xlsread('L3');
% L4=xlsread('L4');
np=length(Pr1(:,1));
Fval=[];
for nj=1:24
StX=[];
Ub=[];
Lb=[];
SUb=[];
SLb=[];
StF=[];
Aeq=[];
Beq=[];
Pr=Pr1(nj,:);
L=[L1(nj), L2(nj), L3(nj),L4(nj)];   %input
% L=[30004 50255 39970 20043];
n=length(M);                  %��ʾ�������ĵĸ���
c=length(L);                  %��ʾǰ�˷�����
D=80/1000;                     %��ʱ�Ͻ� 
%%%%��ʱ����%%%%%
Tm=[0 0 0];
u=20;     
upr=unique(Pr);               %�жϵ���Ƿ���ͬ
DL=M*u;                       %���������������
Po=133.99/10^6;                        %����
Beq=L';
LL=[];
for i=1:c
Lp(1:n)=L(i);
LL=[LL,Lp];
end
Aq1=[];
ki=0;
Bq1=[];
f1=Pr*Po;               %Ŀ�꺯������ʽϵ��
f2=zeros(1,c*n);
f=[f1,f2];
MOF=zeros(c,n);       
Rmd1=[];
xs=ones(1,n);           %����n��1 
for i1=1:c
    ZL=zeros(c,n);      %ȫ��0����
    ZL(i1,:)=xs;    
    Rmd1=[Rmd1,ZL];
end
Aeq=[MOF,Rmd1;Aq1];      %��һ��Լ������: �����غ�
Beq=[Beq;Bq1']; 
Dy=(D-Tm)';              %%%%%��ʱ����
Rm2=eye(n,n);            %rmd ��ϵ��
Rmd2=[];
for i=1:c
    Rmd2=[Rmd2,Rm2];
end
m2=-u*eye(n,n);          %m��ϵ��
%OF1=diag(1./Dy);         %ON/OFF��ϵ��
A=[m2,Rmd2];        %�ڶ���Լ����������ʱ����

% OF2=-diag(DL);           %ON/OFF��ϵ��
% m3=zeros(n,n);
% A2=[m3,OF2,Rmd2];        %������Լ������������Լ��

% A=[A1;A2];
% B=zeros(2*n,1);          %����ʽ�ұ�
D_bd=[];
D_bd=1./Dy;               %delay constraint ����ʽ�ұ�
B=-D_bd;                 %����ʽ�ұ�
nl=c*n+n;
Lb=zeros(nl,1);          %δ֪�����½�
%OF3=ones(1,n);           %ON/OFFϵ��
Ub=[M,LL]';
nc=min(n,c);
if length(upr)==1
   for i=1:nc
       ii=(i-1)*n+i;
   if (DL(i)-1/D)>L(i)
       B3(i)=L(i);
       Aq2(i,ii+n)=1;
   else 
       B3(i)=(DL(i)-1/D);
       Aq2(i,ii+n)=1;
   end  
   end
   Aeq=[Aeq;Aq2];
   Beq=[Beq;B3']; 
end                                  %�����ͬ���ط������
[x,fval,exitflag,ouput,lambda]=linprog(f,A,B,Aeq,Beq,Lb,Ub);
RL=fval;
RU=f1*M';
MRU=RU;
k=1;
StF(k)=MRU;
[flag,S,H]=fNull(x,n);
while (flag)
    UbP=Ub;                        %�洢��һ��
    LbP=Lb;
    BB=[];
    for T=1:2                      %��֦���
        Ubt=Fub(S,H,T,Lb,Ub);
        BB(:,T)=Ubt;
    end
    for T=1:2
        if T==1
            Ub=BB(:,T);             %�ı��Ͻ�
            Lb=LbP;                 %�½粻��
            [x,fval,exitflag,ouput,lambda]=linprog(f,A,B,Aeq,Beq,Lb,Ub);
            if exitflag>0
               x1=x;
               FF1=fval;
               [flag,S,H]=fNull(x1,n);
               n1=length(S);
               if (flag==0 && FF1<RU)
                   RU=floor(FF1*1000)/1000;
                   XR=x1;
               end
            else
               FF1=inf;
               n1=3*n;
            end
        else if T==2
             Ub=UbP;
             Lb=BB(:,T);            %�½�
             [x,fval,exitflag,ouput,lambda]=linprog(f,A,B,Aeq,Beq,Lb,Ub);
             if exitflag>0
               x2=x;
               FF2=fval;
               [flag,S,H]=fNull(x2,n);
               n2=length(S);
               if (flag==0 && FF2<RU)
                   RU=floor(FF2*1000)/1000;
                   XR=x2;
               end
             else
               FF2=inf;
               n2=3*n;
             end
            end
        end
    end
    %% ��ȡ��������
    if n1==0 && n2==0
        fz=0;flag=0;
     else fz=1;
    end
    if length(upr)==1 && flag==0
        fz=0;
        x=[];
        flag=1;
    end
    F1=floor(FF1*1000)/1000;
    F2=floor(FF2*1000)/1000;
    Fmin=min(F1,F2);  %%%
    Fmax=max(F1,F2);
    Nmax=max(n1,n2);
    %%%%%����ʽ����
   if fz==1
   if (Fmin<RU)
       fa=F1/(F1+F2);  %��һ��
       fb=F2/(F1+F2);
       na=n1/(n1+n2);
       nb=n2/(n1+n2);
     if (fa+na)<=(fb+nb)    %���ۺ���
        x=x1;
        Ub=BB(:,1);        %��֧��ѡ��
        Lb=LbP;
       if F2<RU
        StX(:,k)=x2;
        StF(k)=F2;
        SUb(:,k)=UbP;
        SLb(:,k)=BB(:,2);
        k=k+1;
       end
     else   
        x=x2;              %�½�
        Lb=BB(:,2);
        Ub=UbP;
        if F1<RU
          StX(:,k)=x1;
          StF(k)=F1;
          SUb(:,k)=BB(:,1);
          SLb(:,k)=LbP;
          k=k+1;
        end
      end
    [flag,S,H]=fNull(x,n);
      else flag=0;
    end
   end
    if (flag==0)          %������н�
      [minF,ni]=min(StF);
      if length(minF)>=1 & RU>minF
          x=StX(:,ni);
          Ub=SUb(:,ni);
          Lb=SLb(:,ni);
          StF(ni)=[];
          StX(:,ni)=[];
          SUb(:,ni)=[];
          SLb(:,ni)=[];
          k=k-1;
      else x=[];
      end
    end
    [flag,S,H]=fNull(x,n);
    display('-++++++++++--');
end
rmd=XR(n+1:n+c*n);
for j=0:(c-1)
    for i=1:n
        k2=j*n+i;
        rx(j+1,i)=rmd(k2);
    end
end
Fval=[Fval,RU];          %��Сֵ�洢
STM(nj,:)=ceil(XR(1:n));       %��������Ŀ
LS(nj,:)=sum(rx);        % ��i��ǰ�˷�������IDC
rxt=rx';
Ff=RU;
mw=STM(nj,:);
IDC1(nj,:)=rxt(1,:);       
IDC2(nj,:)=rxt(2,:); 
IDC3(nj,:)=rxt(3,:); 
DS1(nj,:)=rx(1,:);       
DS2(nj,:)=rx(2,:); 
DS3(nj,:)=rx(3,:); 
DS4(nj,:)=rx(4,:);        
IDC=sum(rx);            %��ĳһ���������ĵĸ�����Ŀ
end
% xlswrite('HLoad1',DS1);  %��������
% xlswrite('HLoad2',DS2);
% xlswrite('HLoad3',DS3);
% xlswrite('HLoad4',DS4);  
% xlswrite('HIDC1',IDC1);
% xlswrite('HIDC2',IDC2);
% xlswrite('HIDC3',IDC3);
xlswrite('HBB_OPVal',Fval);  %optimal cost
xlswrite('Server_Lei',STM);
xlswrite('LSum',LS);
display('------*******the running is OK Now********---');
toc