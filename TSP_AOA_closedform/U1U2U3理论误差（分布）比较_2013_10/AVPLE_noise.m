clc;  %%%利用静态声源辅助实现单个未知节点定位WLS
clear all
format long
close all

%% 设定全局变量
global SIGMA
global M
%% 设定基本的参数，比如蒙特卡洛的个数，DOA误差范围，声源个数等参数
M = 500;                         %Monte Caro times
R=150;                            %感知半径
threshold = 250;
err=180;
%% 在不同声源数目下进行定位
z=0;
SIGMA=2;
for Hd = 0: 2: err
        Hede=Hd*pi/180;
        num=0;
        nm=0;
        for i=1:M    
            kk=1;
            ei=0;
            pi1=0;
            SPbias=[];
            Beacon=round(rand(10,2)*100);
            node=round(rand(1,2)*100);
            %Hdr=round(rand(1,1)*100*pi/2)/100;
            Unodes=[node,Hede];
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
                U_Err=Thy_Node(SBStore,DOA,Unodes,TE);
                %if TP_Bias<threshold
                num=num+1;
                PLS_PBias(num) = U_Err(1);  %存储结果，运行次数num
                PLS_HBias(num) = U_Err(2);
                TPLS_PBias(num)= U_Err(3); 
                       %TPLS_HBias(num)= TH_Bias;
                %end
            end
            DOA=[];
            SBStore=[];
        end
        display('------the programming is running now-----');
        z=z+1;
        PBIAS(z) = mean(PLS_PBias); %位置误差
        HBIAS(z)= mean(PLS_HBias);
        TPBIAS(z) =mean(TPLS_PBias);   
        %THBIAS(z) =mean(TPLS_HBias);  
        PLS_PBias=[];
        PLS_HBias=[];
        TPLS_PBias=[];
        %PLS_HBias=[];
 end
Sigma=0: 2: err;
Uerror=[PBIAS;HBIAS;TPBIAS];
%% 数据存储
xlswrite('Uerror',Uerror);%位置误差保存
% xlswrite('PLE_PE',PBIAS);%位置误差保存
% xlswrite('PLE_HE',HBIAS);%角度误差保存
% xlswrite('TPBIAS',TPBIAS);%位置误差保存
% xlswrite('THBIAS',THBIAS);%角度误差保存

%% 图形显示2  节点方差
plot(Sigma,PBIAS,'b--',Sigma, HBIAS,'r--',Sigma, TPBIAS,'k+--','linewidth',1.5)
set(gca,'Fontsize',13);
legend('u1','u2','u3');
xlabel('AOA Noise Standard Deviation (degrees)');
ylabel('Error Distribution of u=[u1,u2,u3]');
%set(gca,'XTick',0:20:180);
%axis([0 180 -5*10^17 5*10^17]);
grid on 

% subplot(2,1,2)
% plot(Sigma,HBIAS,'b+--', Sigma, THBIAS,'r--','linewidth',1.5)
% set(gca,'Fontsize',13)
% legend('AVPLE Real Error','AVPLE Throretical Error');
% xlabel('AOA Noise Standard Deviation (degree)');
% ylabel('Orienation Error (degree)');
% axis([0 180 0 40]);
% set(gca,'XTick',0:20:180);
% grid on 
