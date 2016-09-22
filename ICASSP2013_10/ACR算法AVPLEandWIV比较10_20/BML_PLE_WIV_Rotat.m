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
err=10;
%SIGMA=2;
%% �ڲ�ͬ��Դ��Ŀ�½��ж�λ
z=0;
%Beacon=round(rand(8,2)*100);
 for SIGMA =1: 1: err
        num=0;
        nm=0;
        for i=1:M    
            kk=1;
            ei=0;
            pi1=0;
            SPbias=[];
            Beacon=round(rand(8,2)*100);
            node=round(rand(1,2)*100);
            Hdr=round(rand(1,1)*100*pi/2)/100;
            Unode=[node,Hdr];
 %% %%%%%%%%%%% δ֪�ڵ����Դ���ű�ڵ��DOA����ֵ%%%%%%%%%%%%%%%%%%%%
            S_Bcon=Beacon(:,1:2); 
            %ku=0;
            for j=1:length(Unode(:,1))
               Unodes=Unode(j,:);
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
                [OV1,RD1,PLE_PBias, PLE_HBias] = PLS(SBStore,DOA,Unodes(1:2),Unodes(3)); %PLE
                %[OV2,RD2,TLS_P,TLS_H] = RPLS(SBStore,DOA,Unodes(1:2),Unodes(3));
                [TP_Bias, TH_Bias] = TRI_TWO(SBStore,DOA,Unodes(1:2),Unodes(3));
                [TX,TLS_P, TLS_H] = AVTLS(SBStore,DOA,Unodes(1:2),Unodes(3));
                [MP, MH]=BMLF(SBStore,DOA,Unodes(1:2),Unodes(3),OV1);
%                 k1=0; 
%                 k2=0;
%                 for kj=1:length(RD1)
%                     k1=(RD1(kj))^2+k1;
%                     k2=(RD2(kj))^2+k2;
%                 end
%                 flg=0;
%                 if k1>k2 %&& zg==0;% not 180 degree
%                     fg=1;
%                 else
%                     fg=0;
%                 end
%                 if fg==1
%                     PLE_PBias=PLE_PBias2;
%                     PLE_HBias=PLE_HBias2;
%                     [P_Bias, H_Bias] = AVTLS(SBStore,DOA,Unodes(1:2),Unodes(3));%ʹ��BCPLE
%                     [MP, MH]=BMLF(SBStore,DOA,Unodes(1:2),Unodes(3),OV2);
%                 else
%                     PLE_PBias=PLE_PBias1;
%                     PLE_HBias=PLE_HBias1;
%                     [P_Bias, H_Bias] = RAVTLS(SBStore,DOA,Unodes(1:2),Unodes(3));%ʹ��BCPLE
%                     [MP, MH]=BMLF(SBStore,DOA,Unodes(1:2),Unodes(3),OV1);
%                 end
                if  PLE_PBias<threshold && MP<threshold && TLS_P<threshold && TP_Bias<threshold
                    num= num + 1;
                    TP_B(num)=TP_Bias;
                    TH_B(num)=TH_Bias;
                    PE_Pbias(num)=PLE_PBias;
                    PE_Hbias(num)=PLE_HBias;
                    BC_PBias(num) = TLS_P;  %�洢��������д���num
                    BC_HBias(num) = TLS_H;
                    ML_PBias(num) = MP;
                    ML_HBias(num) = MH; 
                end
             end
              DOA=[];
              SBStore=[];
            end
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
        PE_Pbias=[];
        PE_Hbias=[];
        TP_B=[];
        TH_B=[];
 end
Sigma = 1:err;
PB=[TP;PLE_P;PBIAS;MPBIAS];%ple, bcple,ML. avplewiv, bcplvwiv
HB=[TH;PLE_H;HBIAS;MHBIAS];
xlswrite('PB_rot', PB);        %λ������
xlswrite('PH_rot', HB);        %�Ƕ�����


%% ͼ����ʾ2  �ڵ㷽��
figure(1)
subplot(2,1,1)
plot(Sigma,TP,'k>--',Sigma,PLE_P,'m+-',Sigma,PBIAS,'b*--', Sigma, MPBIAS,'g.--','linewidth',1.5)
%plot(Sigma,PLE_P,'m--',Sigma,PBIAS,'b-.', Sigma, MPBIAS,'r*--', Sigma, WIV_PB,'g+--','linewidth',1.5)
set(gca,'Fontsize',13);
h=legend('Triangulation','AVPLE','AVTLS','ML');
set(h,'Fontsize',12)
xlabel('AOA Noise Standard Deviation (degrees)');
ylabel('Location Error (m)');
axis([1 10 0 30]);
set(gca,'XTick',1:10);
grid on 

subplot(2,1,2)
plot(Sigma,TH,'k>--',Sigma,PLE_H,'m+-',Sigma,HBIAS,'b*--', Sigma, MHBIAS,'g.--','linewidth',1.5)
%plot(Sigma,PLE_H,'m>--',Sigma,HBIAS,'b*--', Sigma, WIV_HB,'g+--',Sigma, PLE_WIVH,'k^--','linewidth',1.5)
set(gca,'Fontsize',13)
h=legend('Triangulation','AVPLE','AVTLS','ML');
set(h,'Fontsize',12)
xlabel('AOA Noise Standard Deviation (degrees)');
ylabel('Orienation Error (degrees)');
axis([1 10 0 30]);
set(gca,'XTick',1:10);
grid on 
