%% ����n�����й۲⵽��m����Դ�ĽǶ�
function XITA = Current_Radian2(BArray, Array)  %source 
    global SIGMA
    xita = atan2(BArray(2)-Array(2), BArray(1)-Array(1)); %��������ϵ��ֵ��[-180��180]֮���������ȷ��
    sgm=rand(1)*5*SIGMA;
    Sigma = normrnd(0, sgm)*pi/180;  %������׼��ΪSIGMA�ĽǶ����
    XITA = xita - Array(3)+ Sigma;
