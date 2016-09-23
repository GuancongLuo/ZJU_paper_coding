clc,clear
global SIGMA
M = 1000;                        %Monte Caro times
NumSource =6;                    %��Դ�ĸ���
%Beacon=[10,10,pi/6;170,40,pi/5;90,110,pi/3;15,180,pi/4]; %Beacon=[10,10,pi/6;170,40,pi/5;90,110,pi/3;15,180,pi/4];
Beacon1=round(rand(100,2)*200);
Beacon2=round(rand(100,1)*pi*10)/10;
Beacon=[Beacon1 Beacon2];
Bl=length(Beacon(:,1));         %�ű���� Beacon=[10,20,pi/3;0,160,pi/6;170,190,pi/5;130,10,pi/4;60,100,pi/5];
Unodes=[170,120,pi/3];            %δ֪�ڵ��λ����ϢUnodes=[170,120,pi/3]; 
R=100;                            %��֪�뾶
threshold = 150;
err=6;
%% �ڲ�ͬ��Դ��Ŀ�½��ж�λ
for ii=1:length(NumSource)
    ASource=NumSource(ii);
    z=0;
    for SIGMA = 1: 1 : err
        num=0;
        nm=0;
        for i=1:M    
            SLocation=round(rand(ASource,2)*200); %�����Դλ�÷ֲ�200*200
            kk=1;
            ei=0;
            pi1=0;
            SPbias=[];
            Th_Err=[];
            S_Source=[];
            A_Source=[];
     %% �ű궨λ��̬��Դ��δ֪�ڵ�%%%%%%%%
            for j=1: ASource
                for k=1:Bl
                    BBeacon=Beacon(k,:);      %�ű���Ϣ
                    SSource=SLocation(j,:);        %��Դ��Ϣ
                    if sqrt((SSource(1)-BBeacon(1))^2+(SSource(2)-BBeacon(2))^2)<=R   %��֪�뾶��Χ֮��
                       [XITA,Accu_Ang]= Current_Radian(SSource,BBeacon); % ����Դ��DOAֵ�Ӻ���
                       XXITA(kk)=XITA+BBeacon(3);         %��������ϵ�µĽǶ�
                       AXXITA(kk)=Accu_Ang;                   %׼ȷ�ĽǶ�
                       Beacon_use(kk,:)= BBeacon;             %�ܹ��⵽���ű�ڵ�λ��
                       kk=kk+1;
                    end
                end
     %% �ű�ڵ�Ծ�̬��Դ���ж�λ
                if (kk-1)>=2
                    Spt = TLS_Single(XXITA,Beacon_use(:,1:2));            %��Դλ�ù����Ӻ���   %��Դ����λ�ô洢
                    pc=sqrt((SSource(1)-Spt(1))^2+(SSource(2)-Spt(2))^2); %λ��ƫ��
                    if all(Spt==0)~=1 && pc<threshold  %�趨��ֵ
                       ei=ei+1;
                       pi1=pi1+1;
                       SPbias(pi1)=pc;
                       TErr= Expect_Err(AXXITA,Beacon_use(:,1:2),SSource);   %�������
                       Th_Err(pi1)=TErr;
                       S_Source(ei,:)=Spt;  %�Ѿ���λ����Դ�洢
                       A_Source(ei,:)=SSource;%%׼ȷλ��
                    end
                end
                XXITA=[];
                AXXITA=[];
                Beacon_use=[];   
                kk=1;             
            end
            if isempty(SPbias)~=1
                nm=nm+1;
                SPavg(nm)=mean(SPbias);  %һ�β�����Դƽ��ƫ��   
                STErr(nm)=mean(TErr);
            end
               
        end
        display('----the programing is running now------');
        z=z+1;
        Real_Err(z)=mean(SPavg);
        Theo_Err(z)=mean(STErr);   
    end 
end
 Sig=1:err;
 xlswrite('Real_E',Real_Err);
 xlswrite('Theo_E',Theo_Err);
 figure(1)
 plot(Sig,Real_Err,'b*--', Sig,Theo_Err,'r^--','linewidth',1.5)
 set(gca,'Fontsize',14)
 legend('Real Error','Theory Error');
 xlabel('Bearing Noise Standard Deviation (degree)');
 ylabel('Location Error (m)');
 xlim([1 err])
 grid on 
 display('----OK Now------');
 
 