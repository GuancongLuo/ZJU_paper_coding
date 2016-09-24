clc;  %%%���þ�̬��Դ����ʵ�ֵ���δ֪�ڵ㶨λ
clear all
format long
close all

%% �趨ȫ�ֱ���
global SIGMA
global M
%% �趨�����Ĳ������������ؿ���ĸ�����DOA��Χ����Դ�����Ȳ���
M = 40;                         %Monte Caro times
%NumSource =[20 60 100];            %��Դ�ĸ���
NumU=60;                           %�ű�ڵ�
%Bl=length(Beacon(:,1));            %�ű���� Beacon=[10,20,pi/3;0,160,pi/6;170,190,pi/5;130,10,pi/4;60,100,pi/5];
NB=30;                   %δ֪�ڵ���� 
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
            BL=round(rand(NumB,2)*500);
            BA=round(rand(NumB,1)*pi*10)/10;
            Beacon=[BL,BA];
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
            AB_Source=[A_Source;S_Bcon];      %׼ȷλ��  
            %nm=length(AB_Source(:,1))
            cn1=0;
            cn2=0;
            cn3=0;
            cn4=0;
            um1=0;
            um2=0;
            um3=0;
            um4=0;
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
                        if P_Bias<40
                           um1=um1+1;
                        end
                        if P_Bias<30
                           um2=um2+1;
                        end
                        if P_Bias<20
                           um3=um3+1;
                        end
                        if P_Bias<10
                           um4=um4+1;
                        end
                    end
                end
                if ku>=3
                    cn1=cn1+1;
                    %Sk1(i,cn1)=ku;
                end
                if ku>=4
                  cn2=cn2+1;
                  %Sk2(i,cn2)=ku;
                end
                if ku>=5
                   cn3=cn3+1;
                   %Sk3(i,cn3)=ku;
                end
                if ku>=6
                   cn4=cn4+1;
                   %Sk4(i,cn4)=ku;
                end
                DOA=[];
                SBStore=[];
                S_Source=[];  %һ�ν���
            end
            Sk1(i)=cn1;
            Sk2(i)=cn2;
            Sk3(i)=cn3;
            Sk4(i)=cn4;
            Rat1(i)=um1/NumU*100;
            Rat2(i)=um2/NumU*100;
            Rat3(i)=um3/NumU*100;
            Rat4(i)=um4/NumU*100;       
        end
        display('---------the programing is running now-----------------');
        S_Error=[];
        z=z+1;
        ND1(z)=mean(Sk1)/NumU*100; %�ڵ��
        ND2(z)=mean(Sk2)/NumU*100; 
        ND3(z)=mean(Sk3)/NumU*100; 
        ND4(z)=mean(Sk4)/NumU*100; 
        RT1(z)=mean(Rat1);
        RT2(z)=mean(Rat2);
        RT3(z)=mean(Rat3);
        RT4(z)=mean(Rat4);
        %Prt(z)=mean(PI);  %δ֪�ڵ㶨λ�ٷֱȸ�����
        PBIAS(ii,z) = mean(PLS_PBias); %λ�����
        HBIAS(ii,z)= mean(PLS_HBias);
%         PE_P(ii,z)=mean(PLE_P);
%         PE_H(ii,z)=mean(PLE_H);
        SBIAs(ii,z)=mean(SPavg);       %��Դƽ��ƫ��
        Sk1=[];
        Sk2=[];
        Sk3=[];
        Sk4=[];
        Rat1=[];
        Rat2=[];
        Rat3=[];
        Rat4=[];
        SPavg=[];
        PLS_PBias=[];
        PLS_HBias=[];
        PLE_P=[];
        PLE_H=[];
        Snum=[];
    end   
 end
NDE=[ND1;ND2;ND3;ND4];
Prt=[RT1;RT2;RT3;RT4];
Sigma=20:20:160;
%% ���ݴ洢
xlswrite('NodeDegree',NDE);%λ������
xlswrite('Ration',Prt);%�Ƕ�����
% xlswrite('AVPLE_PE',PE_P);%λ������
% xlswrite('AVPLE_HE',PE_H);%�Ƕ�����


%% ͼ����ʾ2  �ڵ㷽��
% figure(1)
% subplot(2,1,1)
% plot(Sigma,PBIAS(1,:),'b*--', Sigma,PBIAS(2,:),'kd--', Sigma,PBIAS(3,:),'r^--',Sigma,PBIAS(4,:),'go--','linewidth',1.5)
% %plot(Sigma,PBIAS(1,:),'b*--', Sigma,PBIAS(2,:),'rd--',Sigma,PBIAS(3,:),'go--','linewidth',1.5)
% set(gca,'Fontsize',14)
% %legend('K=9','K=13','K=15','K=17','K=18');
% legend('N=20','N=30','N=40','N=50');
% xlabel('The Number of Sound Sources');
% ylabel('Location Error (m)');
% grid on 
% 
% subplot(2,1,2)
% plot(Sigma, HBIAS(1,:),'b*--', Sigma, HBIAS(2,:),'kd--', Sigma, HBIAS(3,:),'r^--',Sigma, HBIAS(4,:),'go--','linewidth',1.5)
% %plot(Sigma, HBIAS(1,:),'b*--', Sigma, HBIAS(2,:),'rd--',Sigma, HBIAS(3,:),'go--','linewidth',1.5)
% set(gca,'Fontsize',14)
% %legend('K=9','K=13','K=15','K=17','K=18');
% legend('N=20','N=30','N=40','N=50');
% xlabel('The Number of Sound Sources');
% ylabel('Orienation Error (degrees)')
% grid on 

%%
figure(2)
plot(Sigma,NDE(1,:),'b*--', Sigma,NDE(2,:),'rs--',Sigma,NDE(3,:),'go--',Sigma,NDE(4,:),'md--','linewidth',1.5)
set(gca,'Fontsize',14)
legend('Node Degree>=3','Node Degree>=4','Node Degree>=5','Node Degree>=6');
xlabel('Number of Sound Sources');
ylabel('Probability Distribution of Node Degree (%)');
%xlim([1 err])
grid on 
% 
% % δ֪�ڵ㸲�Ǳ���
figure(3)
plot(Sigma,Prt(1,:),'bo--', Sigma,Prt(2,:),'m*--',Sigma,Prt(3,:),'rd--',Sigma,Prt(4,:),'gs--','linewidth',1.5)
set(gca,'Fontsize',13)
legend('Threshold=30','Threshold=25','Threshold=20','Threshold=15');
xlabel('Number of Sound Sources');
ylabel('Proportion of Effective Node localization (%)');
%xlim([1 err])
grid on 
display('------OK now-----');


