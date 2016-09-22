clc;  %%%���þ�̬��Դ����ʵ�ֵ���δ֪�ڵ㶨λWLS
clear all
format long
close all

%% �趨ȫ�ֱ���
global SIGMA
global M
%% �趨�����Ĳ������������ؿ���ĸ�����DOA��Χ����Դ�����Ȳ���
M = 2000;                         %Monte Caro times
R=200;                            %��֪�뾶
threshold = 200;
err=180;
SIGMA=4;
%% �ڲ�ͬ��Դ��Ŀ�½��ж�λ
z=0;
 for Hd = 0: 2: err
        Hede=Hd*pi/180;
        %Unodes=[Unodep,Hede];
        num=0;
        nm=0;
        for i=1:M    
            kk=1;
            ei=0;
            pi1=0;
            SPbias=[];
            Beacon=round(rand(8,2)*100);
            node=round(rand(1,2)*100);
%             Hdr=round(rand(1,1)*100*pi/2)/100;
            Unodes=[node,Hede];
 %% %%%%%%%%%%% δ֪�ڵ����Դ���ű�ڵ��DOA����ֵ%%%%%%%%%%%%%%%%%%%%
           S_Bcon=Beacon; 
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
                [OV,PLE_PBias, PLE_HBias] = PLS(SBStore,DOA,Unodes(1:2),Unodes(3)); %PLE
                [OV2,P_Bias, H_Bias] = AVTLS(SBStore,DOA,Unodes(1:2),Unodes(3));%ʹ��BCPLE
%                 [WP_Bias, WH_Bias] = WIV(SBStore,DOA,Unodes(1:2),Unodes(3),U);%%%BCAVPLEWIV
%                 [PLE_WP, PLE_WH] = WIV2(SBStore,DOA,Unodes(1:2),Unodes(3),UT);%AVPLE_WIV
                [TP_Bias, TH_Bias] = TRI_TWO(SBStore,DOA,Unodes(1:2),Unodes(3));
                [MP, MH]=BMLF(SBStore,DOA,Unodes(1:2),Unodes(3),OV2);
                if  PLE_PBias< threshold && P_Bias< threshold && MP<threshold && TP_Bias<threshold
                    num= num + 1;
                    TP_B(num)=TP_Bias;
                    TH_B(num)=TH_Bias;
                    PE_Pbias(num)=PLE_PBias;
                    PE_Hbias(num)=PLE_HBias;
                    BC_PBias(num) = P_Bias;  %�洢��������д���num
                    BC_HBias(num) = H_Bias;
                    ML_PBias(num) = MP;
                    ML_HBias(num) = MH; 
                end
            end
            DOA=[];
            SBStore=[];
        end
        display('------the programming is running now-----');
        z=z+1;
        TP(z)=mean(TP_B);
        TH(z)=mean(TH_B);
        PLE_P(z)=mean(PE_Pbias);
        PLE_H(z)=mean(PE_Hbias);
        PBIAS(z) = mean(BC_PBias); %λ�����
        HBIAS(z)= mean(BC_HBias);
        MPBIAS(z) =mean(ML_PBias); %λ�����
        MHBIAS(z)= mean(ML_HBias);
        BC_PBias=[];
        BC_HBias=[];
        ML_PBias=[];
        ML_HBias=[];
        WIV_Pbias=[];
        WIV_Hbias=[];
        PE_Pbias=[];
        PE_Hbias=[];
        PLE_WPbias=[];
        PLE_WHbias=[];
 end
Sigma = 0: 2 : err;
PB=[PLE_P;PBIAS;MPBIAS];%ple, bcple,ML. avplewiv, bcplvwiv
HB=[PLE_H;HBIAS;MHBIAS];
xlswrite('PB_90dg', PB);        %λ������
xlswrite('PH_90dg', HB);        %�Ƕ�����

%% ͼ����ʾ2  �ڵ㷽��
figure(1)
subplot(2,1,1)
plot(Sigma,TP,'kx--',Sigma,PLE_P,'m+-',Sigma,PBIAS,'b.--', Sigma, MPBIAS,'g.--','linewidth',1.5)
%plot(Sigma,PLE_P,'m--',Sigma,PBIAS,'b-.', Sigma, MPBIAS,'r*--', Sigma, WIV_PB,'g+--','linewidth',1.5)
set(gca,'Fontsize',13);
h=legend('Triangulation','AVPLE','AVTLS','ML');
set(h,'Fontsize',12)
xlabel('Orientation of Unknown Node (degrees)');
ylabel('Location Error (m)');
axis([0 180 0 40]);
set(gca,'XTick',0:20:180);
grid on 

subplot(2,1,2)
plot(Sigma,TH,'kx--',Sigma,PLE_H,'m+-',Sigma,HBIAS,'b.--',Sigma, MHBIAS,'g.--','linewidth',1.5)
%plot(Sigma,PLE_H,'m>--',Sigma,HBIAS,'b*--', Sigma, WIV_HB,'g+--',Sigma, PLE_WIVH,'k^--','linewidth',1.5)
set(gca,'Fontsize',13)
h=legend('Triangulation','AVPLE','AVTLS','ML');
set(h,'Fontsize',12)
xlabel('Orientation of Unknown Node (degrees)');
ylabel('Orienation Error (degrees)');
axis([0 180 0 50]);
set(gca,'XTick',0:20:180);
grid on 
