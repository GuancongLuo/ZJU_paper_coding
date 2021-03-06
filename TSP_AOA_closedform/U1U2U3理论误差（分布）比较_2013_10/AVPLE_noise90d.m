clc;  %%%利用静态声源辅助实现单个未知节点定位WLS
clear all
format long
close all

%% 设定全局变量
global SIGMA
global M
%% 设定基本的参数，比如蒙特卡洛的个数，DOA误差范围，声源个数等参数
M = 10000;                         %Monte Caro times
R=150;                            %感知半径
threshold = 250;
err=90;
%% 在不同声源数目下进行定位
z=0;
SIGMA=2;
for Hd = err: 2: err
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
                num=num+1;
                U1(num) = U_Err(1);  %存储结果，运行次数num
                U2(num) = U_Err(2);
                U3(num)= U_Err(3); 
            end
            DOA=[];
            SBStore=[];
        end
        display('------the programming is running now-----');
 end
Sigma=1:num;
%Uerror=[PBIAS;HBIAS;TPBIAS];
%% 数据存储
%xlswrite('Uerror',Uerror);%位置误差保存
% xlswrite('PLE_PE',PBIAS);%位置误差保存
% xlswrite('PLE_HE',HBIAS);%角度误差保存
% xlswrite('TPBIAS',TPBIAS);%位置误差保存
% xlswrite('THBIAS',THBIAS);%角度误差保存
figure(1)
[a1,b1]=hist(U1);
b1=round(b1/10^15)*10^15;
bar(b1(1:end),a1(1:end));
set(gca,'Fontsize',12);
ylabel('Error Distribution of u1');


figure(2)
[a2,b2]=hist(U2);
b2=round(b2/10^15)*10^15;
bar(b2(1:end),a2(1:end));
set(gca,'Fontsize',12);
ylabel('Error Distribution of u2');


figure(3)
[a3,b3]=hist(U3);
b3=round(b3/10^14)*10^14;
bar(b3(1:end),a3(1:end));
set(gca,'Fontsize',12);
ylabel('Error Distribution of u3');
%% 图形显示2  节点方差
% figure(2)
% plot(Sigma,U1,'b+--',Sigma, U2,'r--',Sigma,  U3,'g*--','linewidth',1.5)
% set(gca,'Fontsize',13);
% legend('u1','u2','u3');
% xlabel('AOA Noise Standard Deviation (degree)');
% ylabel('Error Distribution of u=[u1,u2,u3]');
% %set(gca,'XTick',0:20:180);
% grid on 

% subplot(2,1,2)
% plot(Sigma,HBIAS,'b+--', Sigma, THBIAS,'r--','linewidth',1.5)
% set(gca,'Fontsize',13)
% legend('AVPLE Real Error','AVPLE Throretical Error');
% xlabel('AOA Noise Standard Deviation (degree)');
% ylabel('Orienation Error (degree)');
% axis([0 180 0 40]);
% set(gca,'XTick',0:20:180);
% grid on 
