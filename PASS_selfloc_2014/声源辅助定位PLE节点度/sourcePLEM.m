clc;  %%%���þ�̬��Դ����ʵ�ֵ���δ֪�ڵ㶨λ
clear all
format long
close all

%% �趨ȫ�ֱ���
global SIGMA
global M
%% �趨�����Ĳ������������ؿ���ĸ�����DOA��Χ����Դ�����Ȳ���
M = 1000;                         %Monte Caro times
NumSource =[40 60 80 100 120];            %��Դ�ĸ���
NumB=30;                           %�ű�ڵ�
NumU=60;                           %δ֪�ڵ���� 
R=100;                             %��֪�뾶
threshold = 100;
err=3;
z=0;
%% �ڲ�ͬ��Դ��Ŀ�½��ж�λ
 for ii=1:length(NumSource)
    ASource=NumSource(ii);
    for SIGMA = 2: 1 : 2
        nm=0;
        for i=1:M           
            SL1=round(rand(ASource,2)*500); %�����Դλ�÷ֲ�500*500
            %SL2=round(rand(ASource/2,2)*500);
            SLocation=SL1;
            BL=round(rand(NumB,2)*500);
%             BL2=round(rand(NumB/2,2)*500);
%             BL=[BL1;BL2];
            BA=round(rand(NumB,1)*pi*10)/10;
            Beacon=[BL,BA];
            UL=round(rand(NumU,2)*500);        %δ֪�ڵ�
%             UL2=round(rand(NumU/2,2)*500);        %δ֪�ڵ�
%             UL=[UL1;UL2];
            UA=round(rand(NumU,1)*pi*10)/10;  
            Unode=[UL,UA];
            kk=1;
            ei=0;
            pi1=0;
            SPbias=[];
            S_Source=[];
            A_Source=[];
     %% �ű궨λ��̬��Դ��δ֪�ڵ�%%%%%%%%
            for j=1: ASource
                for k=1:NumB
                    BBeacon=Beacon(k,:);           %�ű���Ϣ
                    SSource=SLocation(j,:);        %��Դ��Ϣ
                    if sqrt((SSource(1)-BBeacon(1))^2+(SSource(2)-BBeacon(2))^2)<=R   %��֪�뾶��Χ֮��
                       XITA= DOAMeasure(SSource,BBeacon); % ����Դ��DOAֵ�Ӻ���
                       XXITA(kk)=XITA+BBeacon(3);             %��������ϵ�µĽǶ�
                       Beacon_use(kk,:)= BBeacon;             %�ܹ��⵽���ű�ڵ�
                       kk=kk+1;
                    end
                end
     %% �ű�ڵ�Ծ�̬��Դ���ж�λ
                 if (kk-1)>=2
                    OV1 = TLS_Single(XXITA,Beacon_use(:,1:2));    %��Դ����λ�ô洢PLE
                    Spt = BML1(XXITA,Beacon_use(:,1:2),OV1);
                    pc=sqrt((SSource(1)-Spt(1))^2+(SSource(2)-Spt(2))^2); %λ��ƫ��
                    if all(OV1==0)~=1 && pc<threshold  %�趨��ֵ
                       ei=ei+1;
                       pi1=pi1+1;
                       SPbias(pi1)=pc;
                       S_Source(ei,:)=Spt;  %�Ѿ���λ����Դ�洢
                       A_Source(ei,:)=SSource;%%׼ȷλ��
                    end
                 end
                 XXITA=[];
                 Beacon_use=[];   
                 kk=1;             
            end
            
 %% %%%%%%%%%%% δ֪�ڵ����Դ���ű�ڵ��DOA����ֵ%%%%%%%%%%%%%%%%%%%%
            S_Bcon=Beacon(:,1:2);
            B_Source=[];
            AB_Source=[];
            B_Source=[S_Source;S_Bcon];       %�ű����Դλ����Ϣ
            AB_Source=[A_Source;S_Bcon];      %׼ȷλ��  
            cnt=0;
            nu1=0;
            nu2=0;
            nu3=0;
            nu4=0;
            nu5=0;
            for ij=1:NumU
                ku=0;
                for iu=1:length(B_Source(:,1))
                     %Unodes=[];
                     BSL=AB_Source(iu,:);           %�Ѷ�λ����Դ���ű�
                     E_BSL=B_Source(iu,:);          %����λ��
                     Unodes=Unode(ij,:);
                     if sqrt((BSL(1)-Unodes(1))^2+(BSL(2)-Unodes(2))^2)<=R                       
                           ku=ku+1;
                           DOA(ku)= DOAMeasure(BSL,Unodes);   % ��õĴ�������DOAֵ
                           SBStore(ku,:)=E_BSL;    %��Դ����λ�ô洢
                     end
                end
%                 if ku>=3
%                     nu1=nu1+1;
%                 end
%                 if ku>=4
%                     nu2=nu2+1;
%                 end
%                 if ku>=5
%                     nu3=nu3+1;
%                 end
%                 if ku>=6
%                     nu4=nu4+1;
%                 end
%                 if ku>=7
%                     nu5=nu5+1;
%                 end
                DOA=[];
                SBStore=[];
                S_Source=[];  %һ�ν���
            end
            SKU(i)=ku;
        end       
        display('---------the programing is running now-----------------');
        z=z+1;
        NKU(z)=mean(SKU);
        SPavg=[];
        SKU=[];
        PI=[];
   end
    
 end
%% ���ݴ洢
xlswrite('NodeDegree',NKU);%λ������
display('----******-OK--*******--');
NKU


