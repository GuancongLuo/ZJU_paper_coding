function Ubt=Fub(S,H,T,Lb,Ub)
% %global M;
% global LL
% global n;
% Lb=zeros(3*n,1);                %λ�ò����½�
% OF3=ones(1,n);                  %ON/OFFϵ��
% Ub=[M,OF3,LL]';
if (isempty(S)~=1&&(T==1))
    m=H(1);
    Ub(m)=floor(S(1));             %С��
    Ubt=Ub;
else if (isempty(S)~=1&&(T==2))
      m=H(1);
      Lb(m)=floor(S(1))+1;        %λ�ò����½�
      Ubt=Lb;
       else Ubt=Ub;
    end
end