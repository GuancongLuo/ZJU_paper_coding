%% TLS��Total Least Squares
function XY = TLS_Single(Heading, Array)  %�Ľ���α������С���˽�
% Heading : 1 x n, tʱ�̸������н��յ���������ϵ�µĽǶ���Ϣ;
% Array : n x 2�� tʱ�̸������е�λ��;
A=[];
B=[];
AB=[];
lt=length(Heading);
 if lt==2 &&((rem(abs(Heading(1)-Heading(2)),pi)<=0.35)||(rem(abs(Heading(1)-Heading(2)-pi),pi)<=0.35)) %��ֹ�������
        XY=[0 0];
 else if lt==3&&((rem(abs(Heading(1)-Heading(2)),pi)<=0.3)||(rem(abs(Heading(1)-Heading(2)-pi),pi)<=0.3))&&((rem(abs(Heading(3)-Heading(2)),pi)<=0.3)||(rem(abs(Heading(3)-Heading(2)-pi),pi)<=0.3))
         XY=[0 0];
     else if lt==4&&((rem(abs(Heading(1)-Heading(2)),pi)<=0.2)||(rem(abs(Heading(1)-Heading(2)-pi),pi)<=0.2))&&((rem(abs(Heading(3)-Heading(2)),pi)<=0.2)||(rem(abs(Heading(3)-Heading(2)-pi),pi)<=0.2))&&((rem(abs(Heading(4)-Heading(3)),pi)<=0.2)||(rem(abs(Heading(4)-Heading(3)-pi),pi)<=0.2))
           XY=[0 0];
           display('************the same line+++=========')
         else
              for i=1:lt
                A(i,1) = -sin(Heading(i));
                A(i,2) = cos(Heading(i));
                B(i,1) = -sin(Heading(i))*Array(i,1) + cos(Heading(i))*Array(i,2);
              end
              Xy = inv(A'*A)*A'*B; 
              XY=Xy';
         end
    end
 end