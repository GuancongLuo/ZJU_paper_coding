clc;  %%%���þ�̬��Դ����ʵ�ֵ���δ֪�ڵ㶨λBCPLE
clear all
format long
close all
%% �趨ȫ�ֱ���
global SIGMA
%% �趨�����Ĳ������������ؿ���ĸ�����DOA��Χ����Դ�����Ȳ���
M = 2000;                         %Monte Caro times
%Beacon=[50 60,pi/10;60,30,pi/6;10,10,pi/6;50,40,pi/5;20,60,pi/3;80,90,pi/4]; %Beacon=[10,10,pi/6;170,40,pi/5;90,110,pi/3;15,180,pi/4];
Beacon=rand(10,2)*100;
Bl=length(Beacon(:,1));           %�ű���� Beacon=[10,20,pi/3;0,160,pi/6;170,190,pi/5;130,10,pi/4;60,100,pi/5];
Unodes=[50,80,pi/3];            %δ֪�ڵ��λ����ϢUnodes=[170,120,pi/3]; 
R=300;                            %��֪�뾶
threshold = 200;
err=6;
%% �ڲ�ͬ��Դ��Ŀ�½��ж�λ
z=0;
 for SIGMA = 0.5: 0.5 : 4
        num=0;
        nm=0;
        for i=1:M    
            kk=1;
            ei=0;
            pi1=0;
            SPbias=[];
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
                [P_Bias, H_Bias] = PLS(SBStore,DOA,Unodes(1:2),Unodes(3));%ʹ��Psedo-Linear Least Squares.
                [B_xyz,BP_Bias, BH_Bias] = BCPLS(SBStore,DOA,Unodes(1:2),Unodes(3));%ʹ��Bias Compensated PseudoLinear Least Squares.
                if  P_Bias< threshold
                    num= num + 1;
                    PLS_PBias(num) = P_Bias;  %�洢��������д���num
                    PLS_HBias(num) = H_Bias;
                    BCPL_PBias(num)=BP_Bias;
                    BCPL_HBias(num)=BH_Bias;
                end
            end
            DOA=[];
            SBStore=[];
        end
        display('------the programming is running now-----');
        z=z+1;
        PBIAS(z)= mean(PLS_PBias); %λ�����
        HBIAS(z)= mean(PLS_HBias);
        BC_PBIAS(z)= mean(BCPL_PBias);
        BC_HBIAS(z)= mean(BCPL_HBias);
        PLS_PBias=[];
        PLS_HBias=[];
        BCPL_PBias=[];
        BCPL_HBias=[];
 end

Sigma=0.5: 0.5 : 4;
%% ���ݴ洢
xlswrite('BCPLE_PE',PBIAS);  %λ������
xlswrite('BCPLE_HE',HBIAS);  %�Ƕ�����
xlswrite('BCPLE_PE',BC_PBIAS); %λ������
xlswrite('BCPLE_HE',BC_HBIAS); %�Ƕ�����

%% ͼ����ʾ2  �ڵ㷽��
figure(1)
subplot(2,1,1)
plot(Sigma, PBIAS,'b*--',Sigma, BC_PBIAS,'go--','linewidth',1.5)
set(gca,'Fontsize',14);
legend('PLE','BCPLE');
xlabel('Bearing Noise Standard Deviation (degree)');
ylabel('Location Error (m)');
xlim([0.5 4]);
grid on 

subplot(2,1,2)
plot(Sigma, HBIAS,'b*--',Sigma, BC_HBIAS,'go--','linewidth',1.5)
set(gca,'Fontsize',14)
legend('PLE','BCPLE');
xlabel('Bearing Noise Standard Deviation (degree)');
ylabel('Orienation Error (degree)');
xlim([0.5 4]);
grid on 
