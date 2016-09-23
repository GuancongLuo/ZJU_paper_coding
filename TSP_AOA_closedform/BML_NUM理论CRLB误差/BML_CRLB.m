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
threshold = 150;
err=3.5;
%% �ڲ�ͬ��Դ��Ŀ�½��ж�λ
z=0;
nm=0;
SIGMA=2;
 for i=1:M 
        num=0;
        nm=nm+1;
        node=round(rand(1,2)*100);
        Hdr=round(rand(1,1)*10*pi/2)/10;
        Unodes=[node,Hdr];
        for NUM = 10: 50: 410  
            kk=1;
            ei=0;
            pi1=0;
            SPbias=[];
            Beacon=round(rand(NUM,2)*100);
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
                    BCPLS_PBias(nm,num) = BP_Bias;  %�洢��������д���num
                    BCPLS_HBias(nm,num) = BH_Bias;
                    ML_PBias(nm,num) = MP;
                    ML_HBias(nm,num) = MH; 
                    CRLB_Pbias(nm,num)= TP_Bias;
                    CRLB_Hbias(nm,num)= TH_Bias;
                else nm=nm-1;
                    break;
                end
            end
            DOA=[];
            SBStore=[];
        end
        display('------the programming is running now-----');
%         z=z+1;
%         PBIAS(z) = mean(BCPLS_PBias); %λ�����
%         HBIAS(z)= mean(BCPLS_HBias);
%         MPBIAS(z) =mean(ML_PBias); %λ�����
%         MHBIAS(z)= mean(ML_HBias);
%         CRLB_PB(z)=mean(CRLB_Pbias);
%         CRLB_HB(z)=mean(CRLB_Hbias);
%         BCPLS_PBias=[];
%         BCPLS_HBias=[];
%         ML_PBias=[];
%         ML_HBias=[];
%         WIV_Pbias=[];
%         WIV_Hbias=[];
 end
PBIAS = mean(BCPLS_PBias); %λ�����
HBIAS= mean(BCPLS_HBias);
MPBIAS=mean(ML_PBias); %λ�����
MHBIAS= mean(ML_HBias);
CRLB_PB=mean(CRLB_Pbias);
CRLB_HB=mean(CRLB_Hbias);
 NUM = 10: 50: 410 ;
%% ���ݴ洢
xlswrite('CRLB_PB410',CRLB_PB);%MLλ������
xlswrite('CRLB_HB410',CRLB_HB);%ML�Ƕ�����


%% ͼ����ʾ2  �ڵ㷽��
figure(1)
subplot(2,1,1)
plot(NUM,CRLB_PB,'b*--','linewidth',1.5)
set(gca,'Fontsize',14);
% legend('BCPLE','ML','CRLB');
xlabel('Bearing Noise Standard Deviation (degree)');
ylabel('Location Error (m)');
grid on 

subplot(2,1,2)
plot(NUM,CRLB_PB,'b*--','linewidth',1.5)
set(gca,'Fontsize',14)
% legend('BCPLE','ML','CRLB');
xlabel('Bearing Noise Standard Deviation (degree)');
ylabel('Orienation Error (degree)');
grid on 
