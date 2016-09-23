clc;  %%%���þ�̬��Դ����ʵ�ֵ���δ֪�ڵ㶨λWLS
clear all
format long
close all
%%%%% --------CRLB-------- ���%%%%
%% �趨ȫ�ֱ���
global SIGMA
global M
%% �趨�����Ĳ������������ؿ���ĸ�����DOA��Χ����Դ�����Ȳ���
M = 2000;                         %Monte Caro times
%Beacon=[45,55;30,70;95,50;100,50;85,35;40,40;50,15;60,40;20,30;75,60];
% Beacon=round(rand(100,2)*100);
% Unodes=[100,90,pi/3];            %δ֪�ڵ��λ����ϢUnodes=[170,120,pi/3]; 
R=200;                            %��֪�뾶
threshold = 500;
err=10;
%% �ڲ�ͬ��Դ��Ŀ�½��ж�λ
z=0;
 for SIGMA = 1 : err
        num=0;
        nm=0;
        for i=1:M    
            kk=1;
            ei=0;
            pi1=0;
            SPbias=[];
            Beacon=round(rand(100,2)*100);
            node=round(rand(1,2)*100);
            Hdr=round(rand(1,1)*100*pi/2)/100;
            Unodes=[node,Hdr];
 %% %%%%%%%%%%% δ֪�ڵ����Դ���ű�ڵ��DOA����ֵ%%%%%%%%%%%%%%%%%%%%
           S_Bcon=Beacon(:,1:2); 
            ku=0;
            for ib=1:length(S_Bcon(:,1))
                 BL=S_Bcon(ib,:);           %�Ѷ�λ����Դ���ű�
                 if sqrt((BL(1)-Unodes(1))^2+(BL(2)-Unodes(2))^2)<=R                       
                       ku=ku+1;
                       DOA(ku)= Current_Radian(BL,Unodes);   % ��õĴ�������DOAֵ
                       SBStore(ku,:)=BL;    %��Դ����λ�ô洢
                 end
            end
            if ku>=3
  %% ����֪����Դ��δ֪�ڵ���ж�λ
                [U,OV,BP_Bias, BH_Bias] = BCPLS(SBStore,DOA,Unodes(1:2),Unodes(3));%ʹ��Psedo-Linear Least Squares.
                [MP, MH]=BMLF(SBStore,DOA,Unodes(1:2),Unodes(3),OV);
                if  MP< threshold 
                    [TP_Bias,TH_Bias]=BMLThy_Node(SBStore,DOA,Unodes);
                    num= num + 1;
                    BCPLS_PBias(num) = BP_Bias;  %�洢��������д���num
                    BCPLS_HBias(num) = BH_Bias;
                    ML_PBias(num) = MP;
                    ML_HBias(num) = MH; 
                    CRLB_Pbias(num)= TP_Bias;
                    CRLB_Hbias(num)= TH_Bias;
                end
            end
            DOA=[];
            SBStore=[];
        end
        display('------the programming is running now-----');
        z=z+1;
        PBIAS(z) = mean(BCPLS_PBias); %λ�����
        HBIAS(z)= mean(BCPLS_HBias);
        MPBIAS(z) =mean(ML_PBias); %λ�����
        MHBIAS(z)= mean(ML_HBias);
        CRLB_PB(z)=mean(CRLB_Pbias);
        CRLB_HB(z)=mean(CRLB_Hbias);
        BCPLS_PBias=[];
        BCPLS_HBias=[];
        ML_PBias=[];
        ML_HBias=[];
        WIV_Pbias=[];
        WIV_Hbias=[];
 end
 
Sigma=1: err;
%% ���ݴ洢
xlswrite('CRLB_PB',CRLB_PB);%MLλ������
xlswrite('CRLB_HB',CRLB_HB);%ML�Ƕ�����


%% ͼ����ʾ2  �ڵ㷽��
figure(1)
subplot(2,1,1)
plot(Sigma,PBIAS,'b*--', Sigma, MPBIAS,'rs--', Sigma, CRLB_PB,'g+--','linewidth',1.5)
set(gca,'Fontsize',14);
legend('BCPLE','ML','CRLB');
xlabel('Bearing Noise Standard Deviation (degree)');
ylabel('Location Error (m)');
grid on 

subplot(2,1,2)
plot(Sigma,HBIAS,'b*--', Sigma, MHBIAS,'rs--', Sigma, CRLB_HB,'g+--','linewidth',1.5)
set(gca,'Fontsize',14)
legend('BCPLE','ML','CRLB');
xlabel('Bearing Noise Standard Deviation (degree)');
ylabel('Orienation Error (degree)');
grid on 
