clc;  %%%���þ�̬��Դ����ʵ�ֵ���δ֪�ڵ㶨λ
clear all
format long
close all

%% �趨ȫ�ֱ���
global SIGMA
global M
%% �趨�����Ĳ������������ؿ���ĸ�����DOA��Χ����Դ�����Ȳ���
M = 1000;                        %Monte Caro times
NB1=[20 30 20 30];                           %�ű�ڵ�
SS=[40 40 60 60];
R=100;                           %��֪�뾶
threshold = 100;
err=3;
SIGMA=2;
%% �ڲ�ͬ��Դ��Ŀ�½��ж�λ
 for ii=1:length(NB1)
    NB=NB1(ii);
    ASource=SS(ii);
    z=0;
    for Ss=20:10:80
        NU=Ss;
        num=0;
        nm=0;
        for i=1:M           
            SLocation=round(rand(ASource,2)*500); %�����Դλ�÷ֲ�500*500
            BL=round(rand(NB,2)*500);
            BA=round(rand(NB,1)*pi*10)/10;
            Beacon=[BL,BA];
            UL=round(rand(NU,2)*500);
            UA=round(rand(NU,1)*pi*10)/10;  
            Unode=[UL,UA];
            kk=1;
            ei=0;
            pi1=0;
            SPbias=[];
            S_Source=[];
            A_Source=[];
     %% �ű궨λ��̬��Դ��δ֪�ڵ�%%%%%%%%
            for j=1: ASource
                for k=1:NB
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
            for ij=1:NU
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
                    if  P_Bias< threshold && H_Bias<20
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
        PBIAS(ii,z) = mean(PLS_PBias); %λ�����
        HBIAS(ii,z)= mean(PLS_HBias);
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
Sigma=20:10:80;
%% ���ݴ洢
xlswrite('Beacon_PE',PBIAS);%λ������
xlswrite('Beacon_HE',HBIAS);%�Ƕ�����

%% ͼ����ʾ1  λ�ýڵ�ƽ�����
%% ͼ����ʾ2  �ڵ㷽��
figure(1)
subplot(2,1,1)
plot(Sigma,PBIAS(1,:),'b*--', Sigma,PBIAS(2,:),'kd--', Sigma,PBIAS(3,:),'r^--',Sigma,PBIAS(4,:),'go--','linewidth',1.5)
%plot(Sigma,PBIAS(1,:),'b*--', Sigma,PBIAS(2,:),'rd--',Sigma,PBIAS(3,:),'go--','linewidth',1.5)
set(gca,'Fontsize',13)
%legend('K=9','K=13','K=15','K=17','K=18');
legend('N=20,K=40','N=30,K=40','N=20,K=60','N=30,K=60');
xlabel('The Number of Unknown Nodes');
ylabel('Location Error (m)');
grid on 

subplot(2,1,2)
plot(Sigma, HBIAS(1,:),'b*--', Sigma, HBIAS(2,:),'kd--', Sigma, HBIAS(3,:),'r^--',Sigma, HBIAS(4,:),'go--','linewidth',1.5)
%plot(Sigma, HBIAS(1,:),'b*--', Sigma, HBIAS(2,:),'rd--',Sigma, HBIAS(3,:),'go--','linewidth',1.5)
set(gca,'Fontsize',13)
%legend('K=9','K=13','K=15','K=17','K=18');
legend('N=20,K=40','N=30,K=40','N=20,K=60','N=30,K=60');
xlabel('The Number of Unknown Nodes');
ylabel('Orienation Error (degrees)')
grid on 



