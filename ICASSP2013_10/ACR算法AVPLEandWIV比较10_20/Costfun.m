function J = Costfun(x,Lca,Agl)
% �����Ȼ���ƵĴ��ۺ���
% x�������ƵĲ�����1x3
% Lca����Դ���ű�ڵ��λ��nx2
% Agl����õ�DOAֵ��1xn
    J = 0;
    for i = 1 : length(Agl)
        ARCTAN = atan2(Lca(i,2)-x(2),Lca(i,1)-x(1));
        if ARCTAN < 0
           ARCTAN =ARCTAN +2*pi;
        end
        Ct = Agl(i)-ARCTAN + x(3);  %���ȼ���
        J = J + Ct^2;
    end