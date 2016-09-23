clc;  %%%���þ�̬��Դ����ʵ�ֵ���δ֪�ڵ㶨λWLS
clear all
format short
close all

%% �趨ȫ�ֱ���
global SIGMA
global M
%% �趨�����Ĳ������������ؿ���ĸ�����DOA��Χ����Դ�����Ȳ���
M =2000;                         %Monte Caro times
%Beacon=[45,55;30,70;95,50;100,50;85,35;40,40;50,15;60,40;20,30;75,60];
%Beacon=round(rand(5,2)*100);
%Unodes=[100,90,pi/3];             %δ֪�ڵ��λ����ϢUnodes=[170,120,pi/3]; 
R=300;                            %��֪�뾶
threshold =150;
err=10;
%% �ڲ�ͬ��Դ��Ŀ�½��ж�λ
z=0;
 for SIGMA = 1: err
        num=0;
        nm=0;
        for i=1:M    
            kk=1;
            ei=0;
            pi1=0;
            SPbias=[];
            Beacon=round(rand(10,2)*100);
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
                [P_Bias, H_Bias] = TRI_TWO(SBStore,DOA,Unodes(1:2),Unodes(3));%ʹ��Psedo-Linear Least Squares.
                if  P_Bias< threshold && H_Bias<threshold
                    num= num + 1;
                    PLS_PBias(num) = P_Bias;  %�洢��������д���num
                    PLS_HBias(num) = H_Bias;
                end
            end
            DOA=[];
            SBStore=[];
        end
        display('------the programming is running now-----');
        z=z+1;
        PBIAS(z) = mean(PLS_PBias); %λ�����
        HBIAS(z)= mean(PLS_HBias);
        PLS_PBias=[];
        PLS_HBias=[];
 end
Sigma=1: err;
%% ���ݴ洢
xlswrite('TR_PE10',PBIAS);%λ������
xlswrite('TR_HE10',HBIAS);%�Ƕ�����

%% ͼ����ʾ2  �ڵ㷽��
figure(1)
subplot(2,1,1)
plot(Sigma,PBIAS,'b*--','linewidth',1.5)
set(gca,'Fontsize',14);
xlabel('AOA Noise Standard Deviation (degree)');
ylabel('Location Error (m)');
grid on 

subplot(2,1,2)
plot(Sigma,HBIAS,'b*--','linewidth',1.5)
set(gca,'Fontsize',14)
xlabel('AOA Noise Standard Deviation (degree)');
ylabel('Orienation Error (degree)');
grid on 
