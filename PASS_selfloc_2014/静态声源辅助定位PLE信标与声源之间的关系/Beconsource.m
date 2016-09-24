clc;  %%%���þ�̬��Դ����ʵ�ֵ���δ֪�ڵ㶨λ
clear all
format long
close all

%% �趨ȫ�ֱ���
global SIGMA
global M
%% �趨�����Ĳ������������ؿ���ĸ�����DOA��Χ����Դ�����Ȳ���
M = 1000;                         %Monte Caro times
%NumSource =[20 60 100];            %��Դ�ĸ���
NumU=60;                           %�ű�ڵ�
%Bl=length(Beacon(:,1));            %�ű���� Beacon=[10,20,pi/3;0,160,pi/6;170,190,pi/5;130,10,pi/4;60,100,pi/5];
NB=[20 30 40 50];                           %δ֪�ڵ���� 
R=100;                             %��֪�뾶
threshold = 100;
err=3;
SIGMA=2;
%% �ڲ�ͬ��Դ��Ŀ�½��ж�λ
 for ii=1:length(NB)
    NumB=NB(ii);
    z=0;
    for Ss=20:20:160
        ASource=Ss;
        num=0;
        nm=0;
        for i=1:M           
            SLocation=round(rand(ASource,2)*500); %�����Դλ�÷ֲ�500*500
%             SL2=round(rand(ASource/2,2)*500);
%             SLocation=[SL1;SL2];
%             BL1=round(rand(NumB/2,2)*500);
%             BL2=round(rand(NumB/2,2)*500);
            BL=round(rand(NumB,2)*500);
            BA=round(rand(NumB,1)*pi*10)/10;
            Beacon=[BL,BA];
%             UL1=round(rand(NumU/2,2)*500);        %δ֪�ڵ�
%             UL2=round(rand(NumU/2,2)*500);        %δ֪�ڵ�
            UL=round(rand(NumU,2)*500);
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
                    OV1 = TLS_Single(XXITA,Beacon_use(:,1:2));    %��Դ����λ�ô洢
                    if all(OV1==0)~=1
                    Spt = BML1(XXITA,Beacon_use(:,1:2),OV1);
                    pc=sqrt((SSource(1)-Spt(1))^2+(SSource(2)-Spt(2))^2); %λ��ƫ��
                    else pc=threshold+10;
                    end
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
            if isempty(SPbias)~=1
                nm=nm+1;
                SPavg(nm)=mean(SPbias);  %һ�β�����Դƽ��ƫ��            
            end
 %% %%%%%%%%%%% δ֪�ڵ����Դ���ű�ڵ��DOA����ֵ%%%%%%%%%%%%%%%%%%%%
            S_Bcon=Beacon(:,1:2);
            B_Source=[];
            AB_Source=[];
            B_Source=[S_Source;S_Bcon];         %�ű����Դλ����Ϣ
            %nn=length(B_Source(:,1))
            AB_Source=[A_Source;S_Bcon];      %׼ȷλ��  
            %nm=length(AB_Source(:,1))
            cnt=0;
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
                if ku>=3                                
      %% %%%%%%%%%%%%%%%%%����֪����Դ��δ֪�ڵ���ж�λBML   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    [P_Bias, H_Bias]= AVTLS(SBStore,DOA,Unodes(1:2),Unodes(3));
                    %[P_Bias, H_Bias] = BML(SBStore,DOA,Unodes(1:2),Unodes(3), OV);%ʹ��Psedo-Linear Least Squares.
                    if  P_Bias< threshold 
                        num= num + 1;
                        PLS_PBias(num) = P_Bias;  %�洢��������д���num
                        PLS_HBias(num) = H_Bias;
%                         PLE_P(num)=PB;
%                         PLE_H(num)=HB;
                        Snum(num)=ku;
                        cnt=cnt+1;
                    end
                end  
                DOA=[];
                SBStore=[];
                S_Source=[];  %һ�ν���
            end
        end
        display('---------the programing is running now-----------------');
        S_Error=[];
        z=z+1;
        Num(ii,z)=mean(Snum); %���붨λ����
%         Prt(ii,z)=mean(PI);  %δ֪�ڵ㶨λ�ٷֱȸ�����
        PBIAS(ii,z) = mean(PLS_PBias); %λ�����
        HBIAS(ii,z)= mean(PLS_HBias);
%         PE_P(ii,z)=mean(PLE_P);
%         PE_H(ii,z)=mean(PLE_H);
        SBIAs(ii,z)=mean(SPavg);       %��Դƽ��ƫ��
        SPavg=[];
        PLS_PBias=[];
        PLS_HBias=[];
        PLE_P=[];
        PLE_H=[];
        Snum=[];
        PI=[];
    end   
 end
Sigma=10:10:80;
%% ���ݴ洢
xlswrite('Beacon_PE',PBIAS);%λ������
xlswrite('Beacon_HE',HBIAS);%�Ƕ�����
% xlswrite('AVPLE_PE',PE_P);%λ������
% xlswrite('AVPLE_HE',PE_H);%�Ƕ�����

%% ͼ����ʾ1  λ�ýڵ�ƽ�����
% figure(1)
% subplot(2,1,1)
% plot(Sigma,PBIAS(1,:),'b*--', Sigma,PBIAS(2,:),'kd--', Sigma,PBIAS(3,:),'r^--',Sigma,PBIAS(4,:),'go--','linewidth',1.6)
% set(gca,'Fontsize',15)
% legend('K=3','K=5','K=7','K=9');
% xlabel('Bearing Noise Standard Deviation (degree)');
% ylabel('Location Error (m)');
% xlim([1 err])
% grid on 
% 
% subplot(2,1,2)
% plot(Sigma, HBIAS(1,:),'b*--', Sigma, HBIAS(2,:),'kd--', Sigma, HBIAS(3,:),'r^--',Sigma, HBIAS(4,:),'go--','linewidth',1.6)
% set(gca,'Fontsize',15)
% legend('K=3','K=5','K=7','K=9');
% xlabel('Bearing Noise Standard Deviation (degree)');
% ylabel('Orienation Error (degree)')
% xlim([1 err])
% grid on 
%% ͼ����ʾ2  �ڵ㷽��
figure(1)
subplot(2,1,1)
plot(Sigma,PBIAS(1,:),'b*--', Sigma,PBIAS(2,:),'kd--', Sigma,PBIAS(3,:),'r^--',Sigma,PBIAS(4,:),'go--','linewidth',1.5)
%plot(Sigma,PBIAS(1,:),'b*--', Sigma,PBIAS(2,:),'rd--',Sigma,PBIAS(3,:),'go--','linewidth',1.5)
set(gca,'Fontsize',14)
%legend('K=9','K=13','K=15','K=17','K=18');
legend('N=40','N=60','N=80','N=100');
xlabel('The Number of Sound Sources');
ylabel('Location Error (m)');
grid on 

subplot(2,1,2)
plot(Sigma, HBIAS(1,:),'b*--', Sigma, HBIAS(2,:),'kd--', Sigma, HBIAS(3,:),'r^--',Sigma, HBIAS(4,:),'go--','linewidth',1.5)
%plot(Sigma, HBIAS(1,:),'b*--', Sigma, HBIAS(2,:),'rd--',Sigma, HBIAS(3,:),'go--','linewidth',1.5)
set(gca,'Fontsize',14)
%legend('K=9','K=13','K=15','K=17','K=18');
legend('N=40','N=60','N=80','N=100');
xlabel('The Number of Sound Sources');
ylabel('Orienation Error (degrees)')
grid on 

%%
% figure(2)
% plot(Sigma,Num(1,:),'b*--', Sigma,Num(2,:),'kd--',Sigma,Num(3,:),'ro--','linewidth',1.5)
% set(gca,'Fontsize',14)
% legend('K=10','K=30','K=70');
% xlabel('Bearing Noise Standard Deviation (degree)');
% ylabel('The Number of Beacons and Nodes ');
% xlim([1 err])
% grid on 
% 
% % δ֪�ڵ㸲�Ǳ���
% figure(3)
% plot(Sigma,Prt(1,:),'b*--', Sigma,Prt(2,:),'kd--',Sigma,Prt(3,:),'ro--','linewidth',1.5)
% set(gca,'Fontsize',14)
% legend('K=10','K=30','K=70');
% xlabel('Bearing Noise Standard Deviation (degree)');
% ylabel('The Proportion of Effective Self_localization (%)');
% xlim([1 err])
% grid on 
% display('------OK now-----');


