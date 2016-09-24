clc;  %%%���þ�̬��Դ����ʵ�ֵ���δ֪�ڵ㶨λ
clear all
format long
close all

%% �趨ȫ�ֱ���
display('----start now-----');
global SIGMA
global M
%% �趨�����Ĳ������������ؿ���ĸ�����DOA��Χ����Դ�����Ȳ���
M = 1000;                %Monte Caro times
NumSource =50;            %��Դ�ĸ���
NumB=30;                  %�ű�ڵ�
R=100;                    %��֪�뾶
threshold = 150;
err=4;
%% �ڲ�ͬ��Դ��Ŀ�½��ж�λ
 for ii=1:length(NumSource)
    ASource=NumSource(ii);
    z=0;
    for SIGMA = 3: 1 : 3
        num=0;
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
            jj=1;
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
                       %DOA(kk)=XITA+BBeacon(3); 
                       Beacon_use(kk,:)= BBeacon;          %�ܹ��⵽���ű�ڵ�
                       kk=kk+1;
                    end
                end
     %% �ű�ڵ�Ծ�̬��Դ���ж�λ
                 if (kk-1)>=3
                    %Spt = TLS_Single(DOA,Beacon_use(:,1:2));    %��Դ����λ�ô洢
                    [SPT,pc]=PLS1(Beacon_use(:,1:2),XXITA,SSource(1:2),SSource(3));
                    %pcer=sqrt((SSource(1)-Spt(1))^2+(SSource(2)-Spt(2))^2) %λ��ƫ��
                    if pc(1)<threshold  %�趨��ֵ
                       ei=ei+1;
                       pi1=pi1+1;
                       SPbias(pi1)=pc(1);
                       S_Source(ei,:)=SPT;  %�Ѿ���λ����Դ�洢
                       A_Source(ei,:)=SSource(1:2);%%׼ȷλ��
                       cnt=cnt+1;
                       num= num + 1;
                       PLS_PBias(num) = pc(1);  %�洢��������д���num
                       PLS_HBias(num) = pc(2);
                    else Unode(jj,:)=SSource; jj=jj+1;
                    end
                 else
                     Unode(jj,:)=SSource;
                     jj=jj+1;
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
            if isempty(Unode)==1
                NumU=0;
            else
               NumU=length(Unode(:,1));
            end
%             for ij=1:NumU
%                 ku=0;
%                 for iu=1:length(B_Source(:,1))
%                      Unodes=[];
%                      BSL=AB_Source(iu,:);           %�Ѷ�λ����Դ���ű�
%                      E_BSL=B_Source(iu,:);          %����λ��
%                      Unodes=Unode(ij,:);
%                      if sqrt((BSL(1)-Unodes(1))^2+(BSL(2)-Unodes(2))^2)<=R                       
%                            ku=ku+1;
%                            DOA(ku)= DOAMeasure(BSL,Unodes);   % ��õĴ�������DOAֵ
%                            SBStore(ku,:)=E_BSL;    %��Դ����λ�ô洢
%                      end
%                 end
%                 if ku>=3                                
%       %% %%%%%%%%%%%%%%%%%����֪����Դ��δ֪�ڵ���ж�λBML   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                     [P_Bias, H_Bias] = PLS(SBStore,DOA,Unodes(1:2),Unodes(3));%ʹ��Psedo-Linear Least Squares.
%                     if  P_Bias< threshold 
%                         num= num + 1;
%                         PLS_PBias(num) = P_Bias;  %�洢��������д���num
%                         PLS_HBias(num) = H_Bias;
%                         Snum(num)=ku;
%                         cnt=cnt+1;
%                     end
%                 end  
%                 DOA=[];
%                 SBStore=[];
%                 S_Source=[];  %һ�ν���
%             end
            PI(i)=cnt/NumSource*100;
        end
        display('---------the programing is running now-----------------');
        S_Error=[];
        z=z+1;
%         Num(ii,z)=mean(Snum); %���붨λ����
        Prt(ii,z)=mean(PI);  %δ֪�ڵ㶨λ�ٷֱȸ�����
        xlswrite('Port',Prt);
        PBIAS(ii,z) = mean(PLS_PBias); %λ�����
        xlswrite('PBIAS',PBIAS);
        PVAR(ii,z) =std(PLS_PBias);    %λ�÷���
        HBIAS(ii,z)= mean(PLS_HBias);
        HVAR(ii,z) =std(PLS_HBias);    %�Ƕȷ���
        xlswrite('HBIAS',HBIAS);
        SBIAs(ii,z)=mean(SPavg);       %��Դƽ��ƫ��
        SPavg=[];
        PLS_PBias=[];
        PLS_HBias=[];
        Snum=[];
        PI=[];
    end
    
 end
Sigma=1:err;
%% ���ݴ洢
xlswrite('TwohopPLE_PE32',PBIAS);%λ������
xlswrite('TwohopPLE_HE32',HBIAS);%�Ƕ�����
xlswrite('TwohopPLE_PRT32',Prt);

%% ͼ����ʾ1  λ�ýڵ�ƽ�����
% figure(1)
% subplot(2,1,1)
% %plot(Sigma,PBIAS(1,:),'b*--', Sigma,PBIAS(2,:),'kd--', Sigma,PBIAS(3,:),'r^--',Sigma,PBIAS(4,:),'go--','linewidth',1.5)
% plot(Sigma,PBIAS(1,:),'b*--','linewidth',1.5)
% set(gca,'Fontsize',14)
% %legend('K=9','K=13','K=15','K=17','K=18');
% %legend('K=30','K=40','K=50');
% xlabel('Bearing Noise Standard Deviation (degree)');
% ylabel('Location Error (m)');
% xlim([1 err])
% grid on 
% % 
% subplot(2,1,2)
% %plot(Sigma, HBIAS(1,:),'b*--', Sigma, HBIAS(2,:),'kd--', Sigma, HBIAS(3,:),'r^--',Sigma, HBIAS(4,:),'go--','linewidth',1.5)
% plot(Sigma, HBIAS(1,:),'b*--','linewidth',1.5)
% set(gca,'Fontsize',14)
% %legend('K=9','K=13','K=15','K=17','K=18');
% %legend('K=30','K=40','K=50');
% xlabel('Bearing Noise Standard Deviation (degree)');
% ylabel('Orienation Angle Error (degree)')
% xlim([1 err])
% grid on 
display('-----OK***********NOW----')
% %%
% figure(2)
% plot(Sigma,Num(1,:),'b*--','linewidth',1.5)
% set(gca,'Fontsize',14)
% %legend('K=10','K=20','K=50');
% xlabel('Bearing Noise Standard Deviation (degree)');
% ylabel('The Number of Beacons and Nodes ');
% xlim([1 err])
% grid on 
% 
% %% δ֪�ڵ㸲�Ǳ���
% figure(3)
% plot(Sigma,Prt(1,:),'b*--','linewidth',1.5)
% set(gca,'Fontsize',14)
% %legend('K=10','K=20','K=50');
% xlabel('Bearing Noise Standard Deviation (degree)');
% ylabel('The Proportion of Effective Self_localization (%)');
% xlim([1 err])
% grid on 
% %%  ��Դ��ƽ�����
% figure(3)
% plot(Sigma, SBIAs(1,:),'b*--','linewidth',1.6)
% set(gca,'Fontsize',17)
% xlabel('DOA����λ����')
% ylabel('λ������λ��m')
% xlim([1 err])
% grid on 
display('-----OK***********NOW----')


