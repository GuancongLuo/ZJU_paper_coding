%% 生成n个阵列观测到的m个声源的角度
function XITA = Current_Radian(BArray, Array)  %source 
    global SIGMA
    xita = atan2(BArray(2)-Array(2), BArray(1)-Array(1)); %绝对坐标系的值在[-180，180]之间根据象限确定
    Sigma =normrnd(0, SIGMA)*pi/180+rand(1)*2*pi/180;
    XITA = xita - Array(3)+ Sigma;
