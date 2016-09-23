clc;  %%%���þ�̬��Դ����ʵ�ֵ���δ֪�ڵ㶨λWLS
clear all
format long
close all

%% �趨ȫ�ֱ���
global SIGMA
global M
%% �趨�����Ĳ������������ؿ���ĸ�����DOA��Χ����Դ�����Ȳ���
M = 2000;                         %Monte Caro times
%Beacon=[45,55;30,70;95,50;100,50;85,35;40,40;50,15;60,40;20,30;75,60];
%Bl=length(Beacon(:,1));           %�ű����
%node=[80,25];
% plot(Beacon(:,1),Beacon(:,2),'r>');
% plot(Unodes(1),Unodes(2));
R=200;                            %��֪�뾶
threshold = 150;
err=3.5;
SIGMA=2;
%% �ڲ�ͬ��Դ��Ŀ�½��ж�λ
z=0;
 for Hd =0: 2: 180
        Hede=Hd*pi/180;
        %Unodes=[Unodep,Hede];
        num=0;
        nm=0;
        for i=1:M    
            kk=1;
            ei=0;
            pi1=0;
            SPbias=[];
            Beacon=round(rand(10,2)*100);
            node=round(rand(1,2)*100);
%           Hdr=round(rand(1,1)*100*pi/2)/100;
            Unodes=[node,Hede];
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
                [UT,RD1,PLE_PBias1, PLE_HBias1] = PLS(SBStore,DOA,Unodes(1:2),Unodes(3)); %PLE
                [RT,RD2,PLE_PBias2,PLE_HBias2,zg] = RPLS(SBStore,DOA,Unodes(1:2),Unodes(3));
                k1=0; 
                k2=0;
%                 for kj=1:length(RD1)
%                     if abs(RD1(kj))>abs(RD2(kj)) %error
%                         k1=k1+1;
%                     else
%                         k2=k2+1;
%                     end
%                 end
                for kj=1:length(RD1)
                   k1=(RD1(kj))^2+k1;
                   k2=(RD2(kj))^2+k2;
                end
                flg=0;
                if k1>k2 %&& zg==0;% not 180 degree
                    fg=1;
                else
                    fg=0;
                end
                if fg==1
                    PLE_PBias=PLE_PBias2;
                    PLE_HBias=PLE_HBias2;
                    [RU,OV2,P_Bias, H_Bias] = RBCPLS(SBStore,DOA,Unodes(1:2),Unodes(3));%ʹ��BCPLE
                    [WP_Bias, WH_Bias] = RWIV(SBStore,DOA,Unodes(1:2),Unodes(3),RU);%%%BCAVPLEWIV
                    [PLE_WP, PLE_WH] = RWIV2(SBStore,DOA,Unodes(1:2),Unodes(3),RT);%AVPLE_WIV
                    [MP, MH]=BMLF(SBStore,DOA,Unodes(1:2),Unodes(3),OV2);
                else
                    PLE_PBias=PLE_PBias1;
                    PLE_HBias=PLE_HBias1;
                    [U,OV,P_Bias, H_Bias] = BCPLS(SBStore,DOA,Unodes(1:2),Unodes(3));%ʹ��BCPLE
                    [WP_Bias, WH_Bias] = WIV(SBStore,DOA,Unodes(1:2),Unodes(3),U);%%%BCAVPLEWIV
                    [PLE_WP, PLE_WH] = WIV2(SBStore,DOA,Unodes(1:2),Unodes(3),UT);%AVPLE_WIV
                    [MP, MH]=BMLF(SBStore,DOA,Unodes(1:2),Unodes(3),OV);
                end
                if  PLE_PBias< threshold && MP<100 && MH<100
                    num= num + 1;
                    PE_Pbias(num)=PLE_PBias;
                    PE_Hbias(num)=PLE_HBias;
                    BC_PBias(num) = P_Bias;  %�洢��������д���num
                    BC_HBias(num) = H_Bias;
                    ML_PBias(num) = MP;
                    ML_HBias(num) = MH; 
                    PLE_WPbias(num)=PLE_WP;
                    PLE_WHbias(num)=PLE_WH;
                    WIV_Pbias(num)= WP_Bias;
                    WIV_Hbias(num)= WH_Bias;
                end
            end
            DOA=[];
            SBStore=[];
        end
        display('------the programming is running now-----');
        z=z+1;
        PLE_P(z)=mean(PE_Pbias);
        PLE_H(z)=mean(PE_Hbias);
        PBIAS(z) = mean(BC_PBias); %λ�����
        HBIAS(z)= mean(BC_HBias);
        MPBIAS(z) =mean(ML_PBias); %λ�����
        MHBIAS(z)= mean(ML_HBias);
        WIV_PB(z)=mean(WIV_Pbias);
        WIV_HB(z)=mean(WIV_Hbias);
        PLE_WIVP(z)=mean(PLE_WPbias);
        PLE_WIVH(z)=mean(PLE_WHbias);
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
Sigma = 0: 2: 180;
PB=[PLE_P;PBIAS;MPBIAS;PLE_WIVP;WIV_PB];%ple, bcple,ML. avplewiv, bcplvwiv
HB=[PLE_H;HBIAS;MHBIAS;PLE_WIVH;WIV_HB];
xlswrite('PB_rot', PB);        %λ������
xlswrite('PH_rot', HB);        %�Ƕ�����
% ���ݴ洢
% xlswrite('PLE_PE10', PLE_P);        %λ������
% xlswrite('PLE_HE10', PLE_H);        %�Ƕ�����
% xlswrite('BCPLE_PE10',PBIAS);       %λ������
% xlswrite('BCPLE_HE10',HBIAS);       %�Ƕ�����
% xlswrite('MLPB10',MPBIAS);          %MLλ������
% xlswrite('MLHB10',MHBIAS);          %ML�Ƕ�����
% xlswrite('BCPLEWIV_PB10',WIV_PB);   %MLλ������
% xlswrite('BCPLEWIV_HB10',WIV_HB);   %ML�Ƕ�����
% xlswrite('PLEWIV_PB10', PLE_WIVP);   %MLλ������
% xlswrite('PLEWIV_HB10', PLE_WIVH);   %ML�Ƕ�����


%% ͼ����ʾ2  �ڵ㷽��
figure(1)
subplot(2,1,1)
plot(Sigma,PLE_P,'m*-',Sigma,PBIAS,'b-', Sigma, MPBIAS,'r.-', Sigma, WIV_PB,'g+--',Sigma, PLE_WIVP,'k--','linewidth',1.5)
%plot(Sigma,PLE_P,'m--',Sigma,PBIAS,'b-.', Sigma, MPBIAS,'r*--', Sigma, WIV_PB,'g+--','linewidth',1.5)
set(gca,'Fontsize',13);
h=legend('AVPLE','BCAVPLE','ML','BCAVPLE-WIV','AVPLE-WIV');
set(h,'Fontsize',12)
xlabel('Orientation of Unknown Node (degrees)');
ylabel('Location Error (m)');
axis([0 180 0 10]);
set(gca,'XTick',0:20:180);
grid on 

subplot(2,1,2)
plot(Sigma,PLE_H,'m*-',Sigma,HBIAS,'b-', Sigma, MHBIAS,'r.-', Sigma, WIV_HB,'g+--',Sigma, PLE_WIVH,'k--','linewidth',1.5)
%plot(Sigma,PLE_H,'m>--',Sigma,HBIAS,'b*--', Sigma, WIV_HB,'g+--',Sigma, PLE_WIVH,'k^--','linewidth',1.5)
set(gca,'Fontsize',13)
h=legend('AVPLE','BCAVPLE','ML','BCAVPLE-WIV','AVPLE-WIV');
set(h,'Fontsize',12)
xlabel('Orientation of Unknown Node (degrees)');
ylabel('Orienation Error (degrees)');
axis([0 180 0 10]);
set(gca,'XTick',0:20:180);
grid on 
