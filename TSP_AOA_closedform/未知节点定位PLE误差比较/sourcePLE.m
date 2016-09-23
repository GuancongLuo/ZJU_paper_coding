clc;  %%%利用静态声源辅助实现单个未知节点定位WLS
clear all
format long
close all

%% 设定全局变量
global SIGMA
global M
%% 设定基本的参数，比如蒙特卡洛的个数，DOA误差范围，声源个数等参数
M = 5000;                         %Monte Caro times
Beacon=[10,10,pi/6;50,40,pi/5;20,60,pi/3;80,90,pi/4];
%Beacon=round(rand(200,2)*100);
Bl=length(Beacon(:,1));           %信标个数 Beacon=[10,20,pi/3;0,160,pi/6;170,190,pi/5;130,10,pi/4;60,100,pi/5];
Unodes=[70,80,pi/3];            %未知节点的位置信息Unodes=[170,120,pi/3]; 
R=100;                            %感知半径
threshold = 150;
err=6;
%% 在不同声源数目下进行定位
z=0;
 for SIGMA = 1: 1 : err
        num=0;
        nm=0;
        for i=1:M    
            kk=1;
            ei=0;
            pi1=0;
            SPbias=[];
 %% %%%%%%%%%%% 未知节点对声源和信标节点的DOA测量值%%%%%%%%%%%%%%%%%%%%
           S_Bcon=Beacon(:,1:2); 
            ku=0;
            for ib=1:length(S_Bcon(:,1))
                 BL=S_Bcon(ib,:);           %已定位的声源和信标
                 if sqrt((BL(1)-Unodes(1))^2+(BL(2)-Unodes(2))^2)<=R                       
                       ku=ku+1;
                       DOA(ku)= Current_Radian(BL,Unodes);   % 测得的带有噪声DOA值
                       SBStore(ku,:)=BL;    %声源估计位置存储
                 end
            end
            if ku>=3
  %% 用已知的声源对未知节点进行定位
                [TE,P_Bias, H_Bias] = PLS(SBStore,DOA,Unodes(1:2),Unodes(3));%使用Psedo-Linear Least Squares.
                [TP_Bias, TH_Bias]=Thy_Node(SBStore,DOA,Unodes,TE);
                if  P_Bias< threshold
                    if TP_Bias<threshold
                       num=num+1;
                       PLS_PBias(num) = P_Bias;  %存储结果，运行次数num
                       PLS_HBias(num) = H_Bias;
                       TPLS_PBias(num)= TP_Bias; 
                       TPLS_HBias(num)= TH_Bias;
                    end
                end
            end
            DOA=[];
            SBStore=[];
        end
        display('------the programming is running now-----');
        z=z+1;
        PBIAS(z) = mean(PLS_PBias); %位置误差
        HBIAS(z)= mean(PLS_HBias);
        TPBIAS(z) =mean(TPLS_PBias);   
        THBIAS(z) =mean(TPLS_HBias);  
        PLS_PBias=[];
        PLS_HBias=[];
        TPLS_PBias=[];
        TPLS_HBias=[];
 end
Sigma=1:err;
%% 数据存储
xlswrite('PLE_PE',PBIAS);%位置误差保存
xlswrite('PLE_HE',HBIAS);%角度误差保存
xlswrite('TPBIAS',TPBIAS);%位置误差保存
xlswrite('THBIAS',THBIAS);%角度误差保存

%% 图形显示2  节点方差
figure(1)
subplot(2,1,1)
plot(Sigma,PBIAS,'b*--',Sigma, TPBIAS,'go--','linewidth',1.5)
set(gca,'Fontsize',14);
legend('PLE Real Error','PLE Throretical Error');
xlabel('Bearing Noise Standard Deviation (degree)');
ylabel('Location Error (m)');
xlim([1 err]);
grid on 

subplot(2,1,2)
plot(Sigma,HBIAS,'b*--', Sigma, THBIAS,'go--','linewidth',1.5)
set(gca,'Fontsize',14)
legend('PLE Real Error','PLE Throretical Error');
xlabel('Bearing Noise Standard Deviation (degree)');
ylabel('Orienation Error (degree)');
xlim([1 err])
grid on 
