clc;  %%%���þ�̬��Դ����ʵ�ֵ���δ֪�ڵ㶨λ
clear all
format long
close all

%% �趨ȫ�ֱ���
display('----start now-----');
global SIGMA
global M
%% �趨�����Ĳ������������ؿ���ĸ�����DOA��Χ����Դ�����Ȳ���
M = 10000;                %Monte Caro times
NumSource =50;            %unknown node�ĸ���
NumB=30;                  %�ű�ڵ�
R=100;                    %��֪�뾶
threshold = 150;
err=4;
%% �ڲ�ͬ��Դ��Ŀ�½��ж�λ
 for ii=1:6
    ASource=NumSource;
    z=0;
    for SIGMA = 3: 1 : 3
        nu=0;
        nm=0;
        for i=1:M           
            SL1=round(rand(ASource/2,2)*500); %�����Դλ�÷ֲ�500*500
            SL2=round(rand(ASource/2,2)*500);
            SL=[SL1;SL2];
            UA=round(rand(ASource,1)*pi*10)/10;  
            SLocation=[SL,UA];
            BL1=round(rand(NumB/2,2)*500);
            BL2=round(rand(NumB/2,2)*500);
            BL=[BL1;BL2];
            BA=round(rand(NumB,1)*pi*10)/10;
            Beacon=[BL,BA];
            kk=1;
            ei=0;
            pi1=0;
            SPbias=[];
            S_Source=[];
            A_Source=[];
            jj=0;
            Unode=[];
            cnt=0;
     %% �ű궨λ��̬��Դ��δ֪�ڵ�%%%%%%%%
            for j=1: ASource
                for k=1:NumB
                    BBeacon=Beacon(k,:);           %�ű���Ϣ
                    SSource=SLocation(j,:);  %��Դ��Ϣ
                    if sqrt((SSource(1)-BBeacon(1))^2+(SSource(2)-BBeacon(2))^2)<=R   %��֪�뾶��Χ֮��
                       XITA= DOAMeasure(BBeacon,SSource); % ����Դ��DOAֵ�Ӻ���
                       XXITA(kk)=XITA;         %��������ϵ�µĽǶ�
                       Beacon_use(kk,:)= BBeacon;          %�ܹ��⵽���ű�ڵ�
                       kk=kk+1;
                    end
                end
     %% �ű�ڵ�Ծ�̬��Դ���ж�λ
                 if (kk-1)>=3
                     nu=nu+1;
                     Deg(nu)=kk-1;
                    [SPT,pc]=PLS1(Beacon_use(:,1:2),XXITA,SSource(1:2),SSource(3));
                    if pc(1)<threshold  %�趨��ֵ
                       ei=ei+1;
                       pi1=pi1+1;
                       SPbias(pi1)=pc(1);
                       S_Source(ei,:)=SPT;  %�Ѿ���λ����Դ�洢
                       A_Source(ei,:)=SSource(1:2);%%׼ȷλ��
                       cnt=cnt+1;
                    else jj=jj+1; Unode(jj,:)=SSource; 
                    end
                 else
                     jj=jj+1;
                     Unode(jj,:)=SSource;     
                 end
                 XXITA=[];
                 Beacon_use=[];   
                 kk=1;             
            end
 %% %%%%%%%%%%% δ֪�ڵ����Դ���ű�ڵ��DOA����ֵ%%%%%%%%%%%%%%%%%%%%
            S_Bcon=Beacon(:,1:2);
            B_Source=[];
            AB_Source=[];
            B_Source=[S_Source;S_Bcon];         %�ű����Դλ����Ϣ
            AB_Source=[A_Source;S_Bcon];      %׼ȷλ��  
            if isempty(Unode)==1
                NumU=0;
            else
               NumU=length(Unode(:,1));
            end
            for ij=1:NumU
                ku=0;
                for iu=1:length(B_Source(:,1))
                     Unodes=[];
                     BSL=AB_Source(iu,:);           %�Ѷ�λ����Դ���ű�
                     E_BSL=B_Source(iu,:);          %����λ��
                     Unodes=Unode(ij,:);
                     if sqrt((BSL(1)-Unodes(1))^2+(BSL(2)-Unodes(2))^2)<=R                       
                           ku=ku+1;
                           DOA(ku)= DOAMeasure(BSL,Unodes);   % ��õĴ�������DOAֵ
                           SBStore(ku,:)=E_BSL;    %��Դ����λ�ô洢
                     end
                end
                nu=nu+1;
                Deg(nu)=ku;
                DOA=[];
                SBStore=[];
                S_Source=[];  %һ�ν���
            end
        end
        display('---------the programing is running now-----------------');
        z=z+1;
        Num(ii,z)=mean(Deg); %���붨λ����
        SPavg=[];
        Deg=[];
   end
    
 end
%% ���ݴ洢
xlswrite('NodeD30',Num);%λ������
display('-----OK***********NOW----')


