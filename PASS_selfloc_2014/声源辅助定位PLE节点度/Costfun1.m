function J = Costfun1(x,Lca,ADOA)
% �����Ȼ���ƵĴ��ۺ���
% x�������ƵĲ�����1x3
% Lca����Դ���ű�ڵ��λ��nx2
% ADOA����õ�DOAֵ��1xn
  J = 0;
  for i = 1 : length(ADOA)
      ARCTAN = atan2(x(2)-Lca(i,2),x(1)-Lca(i,1));
      C = ADOA(i)-ARCTAN;  %���ȼ���
      J = J + C^2;
  end