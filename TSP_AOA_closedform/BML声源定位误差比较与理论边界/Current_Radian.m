%% ����n�����й۲⵽��m����Դ�ĽǶ�
function [XITA,Thta] = Current_Radian(Target, Array)  %source 
    global SIGMA
    xita = atan2(Target(2)-Array(2), Target(1)-Array(1)); %��������ϵ��ֵ��[-180��180]֮���������ȷ��
    Sigma = normrnd(0, SIGMA)*pi/180;  %������׼��ΪSIGMA�ĽǶ����
    XITA = xita - Array(3)+Sigma;
    Thta = xita - Array(3);
