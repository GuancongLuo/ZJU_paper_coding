clc,clear;                 %��Ԫ��������������ĸ��ص���----��ٷ�
tic
format short               %���Թ滮����
% %%%%%%ת����ʱ%%%%%%%%%%%
% Pr1=[20.70 87.9 15.75;17.44 87.9 15.13;12.87 87.9 13.58;8.20 87.9 17.13;10.41 87.9 20.38;19.15 87.9	21.36;20.86 87.9 23.04;23.47 87.9 23.9;23.25 87.9 23.58;...
%     24.4 89 25;24.74 87.9 26.73;25.17 87.9 28.61;24.85 87.9 33.88;26.05 87.9 44.96;23.89 87.9 60.75;23.43 87.9 33.6;21.43 87.9 28.1;22.02 87.9 25.82;...
%     22.74 87.9 24.87;22.98 87.9 23.78;28.51 87.9 21.61;27.54 87.9 18.81;27.01 87.9 18.28;23.87 87.9 16.41];       % ��ʾ���input
Pr1=[34.8 33.2 28 25.6 25 24.6 22.8 24.8 27.2 31.85 33.4 35.2 36.2 36.2 36.8 37.2 38.5 40.4 41 42.4 41.7 47.1 45.2 36.6;...
74.73 74.73 74.73 74.73	74.73 74.73 74.73 74.73	74.73 74.73	74.73 74.73	74.73 74.73	74.73 74.73 74.73 74.73 74.73 74.73 74.73 74.73 74.73 74.73;...
19.35 18.2 17.87 17.99 20.54 21.95 25.79 29.22 34.38 36.58 38.23 37.93 39.5 49.94 55.45	50.93 42.49	36.91 36.73	36.09 30.4 27.14 25.73 21.03]';

%%%%%%ת����ʱ%%%%%%%%%%%
DL1=[1.5 1 2 2.5 3 3.3 3.2 2 2.5 2.1 3.2 4.5 2.5 2.1 2 2 2.1 2.3 2.4 3 5.3 2 2 1.9;58 55 53 60 66 70 75 80 90 95 96 90 89 88 76 77 82 85 89 96 78 65 55 56;...
     35 32 30 40 50 55 60 72 78 82 87 89 82 75 64 65 62 67 88 75 55 48 44 35;52 56 50 46 54 61 68 70 76 85 90 95 88 84 77 76 74 76 78 86 72 65 60 57]/1000;
DL2=[58 55 53 60 66 70 75 80 90 95 96 90 89 88 76 77 82 85 89 96 78 65 55 56;2.5 1.8 2 2.3 2.5 2.8 2.7 3.2 3.4 3.6 3.8 4.4 3.5 3.2 2.4 2 2.2 2.5 2.9 2.8 3.6 1.5 1 1;...
     26 24 23 25 29 32 40 53 62 68 74 78 73 72 70 66 64 66 68 71 75 64 45 35;8 6 6.5 6 8 12 16 20 25 27 30 32 26 25 22 21 19 19 20 29 25 20 18 13]/1000;
DL3=[35 32 30 40 50 55 60 72 78 82 87 89 82 75 64 65 62 67 88 75 55 48 44 35;26 24 23 25 29 32 40 53 62 68 74 78 73 72 70 66 64 66 68 71 75 64 45 35;...
    1.1 1.2 1.5 2 2.4 2.8 2.5 3 3.6 3.7 2.9 2.8 2.7 2.6 2.1 2 2 2.5 3.4 1.5 1.6 1.5 1.1 1;38 38 36 37 35 46 56 65 73 75 78 75 72 74 70 64 67 69	78 73 64 55 46 40]/1000;
L1=30000*ones(1,24);
L2=40000*ones(1,24);
L3=40000*ones(1,24);
L4=30000*ones(1,24);
Fva=[];
for nj=1:24 %1,2,4
    u=20; 
    M=[5000 4000 4000];        %�������ķ����������Ŀ  
    Pr=Pr1(nj,:);            %���
    L=[L1(nj) L2(nj) L3(nj) L4(nj)];          %input
    n=length(M);                              %��ʾ�������ĵĸ���
    cc=length(L);                              %��ʾǰ�˷�����
    D=80/1000;                                    %��ʱ�Ͻ� 
    Tt=[DL1(:,nj)';DL2(:,nj)';DL3(:,nj)'];
    Tty=Tt;
    upr=unique(Pr);            %�жϵ���Ƿ���ͬ
    %DL=M*u;                    %���������������
    Po=133.99/10^6;                     %����
    Aq1=[];
    Bq1=[];
    RU=inf;
    XH1=[];
    ki=0;
    %%%%%��ʱ����%%%%%%
    for i=1:n
        for j=1:cc
            if Tt(i,j)>=D
                ki=ki+1;
                Aq1(ki,:)=zeros(1,n+cc*n);
                Tt(i,j)=0;
                ij=(j-1)*n+i;
                XH1(ki)=ij;
                Aq1(ki,ij+n)=1;
                Bq1(ki)=0;
            end
        end
    end         %ѡ���������ص�������·
    T1=Tt(1,:);
    T2=Tt(2,:);
    T3=Tt(3,:);
    TT=Tt';
    Smt=Tt;
    YTT=Tt;
    f1=Pr*Po;               %Ŀ�꺯������ʽϵ��
    RU=f1*M';
    FMin=RU;
    FU=RU;
    %%%%%%%%%%%%%��ʱ�������%%%%%%%%%%%
    for t1=1:cc
        for t2=1:cc
            for t3=1:cc
            StX=[];
            SUb=[];
            SLb=[];
            StF=[];
            Aeq=[];
            Beq=[];
            XR=[];   
            STm=[];
            A=[];
            B=[];
            A1=[];
            B1=[];
            A2=[];
            XH=[];
            Aqt=[];
            Bqt=[];
            AQ=[];
            BQ=[];
            XH2=[]; 
            M=[5000 4000 4000];        %�������ķ����������Ŀ 
            L=[L1(nj) L2(nj) L3(nj) L4(nj)];          %input
            n=length(Pr);
            c=cc;
            Aqt=zeros(1,n+c*n);
            Bqt=0;
            jt=0;
            kt=0;
            for k1=1:c
               if T1(t1)<T1(k1)
                   jt=jt+1;
                   kt=kt+1;
                   kk=(k1-1)*n+1;  %k1��ʾǰ�˷���������������1
                   XH2(kt)=kk;
                   Aqt(jt,kk+n)=1;%2n has been changed as n
                   Bqt(jt)=0;
               end
            end
            for k2=1:c
               if T2(t2)<T2(k2)
                   jt=jt+1;
                   kt=kt+1;
                   kk=(k2-1)*n+2;  %k2��ʾǰ�˷�����
                   XH2(kt)=kk;
                   Aqt(jt,kk+n)=1;
                   Bqt(jt)=0;
               end
            end
            for k3=1:c
               if T3(t3)<T3(k3)
                   jt=jt+1;
                   kt=kt+1;
                   kk=(k3-1)*n+3;  %k3��ʾǰ�˷���������������3
                   XH2(kt)=kk;
                   Aqt(jt,kk+n)=1;
                   Bqt(jt)=0;
               end
            end
            XH=[XH1,XH2];
            AQ=[Aq1;Aqt];
            BQ=[Bq1,Bqt];
            XH=sort(XH,2);
            Tm=[];
            Tm=[T1(t1),T2(t2),T3(t3)]; %ѡ���ʱ��洢
            it=0;
            sg=0;
            ka=[];
            sm=[];
            H1=[];
            H2=[];
            H3=[];
            DM=[];
            for xj=1:c       %Ψһ����Ķ˿�ѡ��
                 y1=0;
                 gy=0;
                 SX=[];
                for xi=1:length(XH)
                   if XH(xi)<=n*xj && XH(xi)>n*(xj-1)
                      y1=y1+1;
                      SX(y1)=XH(xi);%���ز��������
                   end
                end
                if y1==(n-1)   %��Ψһ�����
                    it=it+1;
                    for d=((xj-1)*n+1):n*xj
                        gy=0;
                        for y2=1:y1
                           if SX(y2)==d
                               gy=1;
                           end
                        end
                        if gy==0
                           dd=d;
                           dj=dd-(xj-1)*n;
                           H1(it)=dj;  %������������j
                           H2(it)=xj;  %�˿�
                           H3(it)=(xj-1)*n+1+n;
                       end
                    end
                    ka=[ka,xj];            %��Ҫɾ���Ķ˿�i
                    Lm(it)=L(xj);          %���ش洢
                    sg=1;
                end
            end
              LZ=zeros(n,1);
              for i=1:n
                  for j=1:length(H1)
                      if i==H1(j)
                         LZ(i)=LZ(i)+L(H2(j));  %ͬһ�˿ڸ��ش洢
                      end
                  end     
              end  
              UH=unique(H1);
              for zi=1:length(UH)
                   zx=H1(zi);                                %��������
%                  dt=D-max(Smt(zx,:));
                   dt=D-Tm(zx); %%%%                        %������ʱ ΪʲôҪ���ÿ��ѭ��ѡ���ʱ���е����dt=D-max(Smt(zx,:));
                   Ms=ceil((LZ(zx)+1/dt)/u);                 %�򿪵ķ�������Ŀ
                   M(zx)=M(zx)-Ms;
                   DM(zi,:)=[zx,Ms];                        % �Ѿ�ʹ�õ������洢
              end
              L([ka])=[];
             for hi=1:length(H3)
               hj=H3(hi)-(hi-1)*n;                           %ɾ���˿�i���������ĵĸ�����
               AQ(:,[hj:hj+n-1])=[];
             end
             ai=0;
             Sq=[];
             if isempty(AQ)==1
                la=0;
             else
                la=length(AQ(:,1));
             end
             for i=1:la
                if ~all(AQ(i,:)==0)
                    ai=ai+1;
                    Sq(ai,:)=AQ(i,:);     %%error
                end
             end
             AQ=Sq;
             if ai>=1
               BQ=zeros(1,ai);
               else BQ=[];
             end   
    Aeq=[];
    Beq=[];  
    Tm=[];
    Tm=[T1(t1),T2(t2),T3(t3)];
    Tmm=Tm;
    if isempty(DM)==0
       Mb=unique(DM(:,1));
       for hn=1:length(Mb)  %�Ѿ���������
           Tm(hn)=-inf;
       end     
    end
    n=length(M);
    c=length(L);
    LL=[];
    for i=1:c
        Lp(1:n)=L(i);
        LL=[LL,Lp];
    end
    NM=find(M<0);
    if isempty(NM)==0
        c=-1;
    end
    if c>=1
    DL=M*u;
    f1=Pr*Po;               %Ŀ�꺯������ʽϵ��
    f2=zeros(1,c*n);
    f=[f1,f2];
    MOF=zeros(c,n);       
    Rmd1=[];
    xs=ones(1,n);           %����n��1 
    for i1=1:c
        ZL=zeros(c,n);      %ȫ��0����
        ZL(i1,:)=xs;    
        Rmd1=[Rmd1,ZL];
    end
    Aeq=[AQ;MOF,Rmd1];     %��һ��Լ������: �����غ�
    Beq=[BQ';L'];

    Dy=(D-Tm)';              %%%%%��ʱ����
    Rm2=eye(n,n);            %rmd ��ϵ��
    Rmd2=[];
    for i=1:c
        Rmd2=[Rmd2,Rm2];
    end
    m2=-u*eye(n,n);          %m��ϵ��
%     OF1=diag(1./Dy);         %ON/OFF��ϵ��
%     A1=[m2,OF1,Rmd2];        %�ڶ���Լ����������ʱ����
      A=[m2,Rmd2];

%     OF2=-diag(DL);           %ON/OFF��ϵ��
%     m3=zeros(n,n);
%     A2=[m3,OF2,Rmd2];        %������Լ������������Լ��

    %A=[A1;A2];
    %B=zeros(2*n,1);          %����ʽ�ұ�
    D_bd=[];
    D_bd=1./Dy;               %delay constraint ����ʽ�ұ�
    B=-D_bd;                 %����ʽ�ұ�
    nl=c*n+n;
    Lb=[];
    Ub=[];
    Lb=zeros(nl,1);           %δ֪�����½�

    %OF3=ones(1,n);            %ON/OFFϵ��
    Ub=[M,LL]';
    nc=min(n,c);               %�����ͬ���ط������
    [x,fval,exitflag,ouput,lambda]=linprog(f,A,B,Aeq,Beq,Lb,Ub);
    else if c==0
        XR=zeros(n,1);
        c=cc;
        for i=1:n
            for j=1:length(DM(:,1)) 
                MD=DM(j,:);
                if i==MD(1)             %�����������
                    XR(i)=XR(i)+MD(2);  %�������ķ�������
                end
            end
        end
        %XR(n+1:n)=ones(n,1);% what does it mean?
        XR(n+1:n*c+n)=0;
        for ij=1:length(H1)
            i=H2(ij);                   %�˿ں�
            j=H1(ij);                   %Data center
            nt=n+(i-1)*n+j;
            XR(nt)=Lm(ij);
        end
        XRS=XR;
        RU=Pr*XR(1:n)*Po;
        sg=0;
        exitflag=-1;
        else
            RU=inf;
            exitflag=-1;
        end
    end
    if  exitflag>0
        RL=fval;
        fp=fval;
        MRU=RU;
        k=1;
        ki=0;
        ni=0;
        StF(k)=MRU;
        [flag,S,H]=fNull(x,n);  
        hfg=1;
        SS=[];
        SH=[];
        SH=H;       %�洢�������ĸ���
        SS=S;       %�洢�ڵ��ֵ
        UP=Ub;
        LP=Lb;
        if flag==0
            XRS=x;
            hfg=0;
        end
        if RL>=FMin;
            flag=0; hfg=0;
        end
     else flag=0; hfg=0;
    end
 while (flag|| hfg)
     UbP=[];
     LbP=[];
     UbP=Ub;                        %�洢��һ��
     LbP=Lb;
     BB=[];
     nh=length(H);  %%%%Srong Branch
     %fh=0;
%     for ih=1:nh
%         m=H(ih);                   % ȷ���ڼ�����
%         if m>=4 & m<=6
%            m=H(ih);
%            fh=1;
%            nh=0;
%            break;
%         end
%     end
    %if fh==0
       m=H(1);
       ih=1;
    %end
%      m=H(1);
%      ih=1;
     if hfg==1    %ɾ���ڵ�
       SH(ih)=[];
       SS(ih)=[];
     end
    for T=1:2                      %��֦���
        if T==1
           Ub(m)=floor(S(ih));        %�Ͻ� 
           BB(:,T)=Ub;
        else if T==2
          Lb(m)=floor(S(ih))+1;        %δ֪�����½�
          BB(:,T)=Lb;
        end
        end
    end
    
    for T=1:2
        if T==1
            Ub=BB(:,T);             %�ı��Ͻ�
            Lb=LbP;                 %�½粻��
            [x,fval,exitflag,ouput,lambda]=linprog(f,A,B,Aeq,Beq,Lb,Ub);
            if exitflag>0
               x1=x;
               FF1=fval;
               [flag,S,H]=fNull(x1,n);
               n1=length(S);
               if (flag==0 && FF1<RU)
                   RU=floor(FF1*1000)/1000;
                   XR=x1;
               end
            else
               FF1=inf;
               n1=c*n+n;
               x1=[];
            end
        else if T==2
             Ub=UbP;
             Lb=BB(:,T);            %�½�
             [x,fval,exitflag,ouput,lambda]=linprog(f,A,B,Aeq,Beq,Lb,Ub);
             if exitflag>0
               x2=x;
               FF2=fval;
               [flag,S,H]=fNull(x2,n);
               n2=length(S);
               if (flag==0 && FF2<RU)
                   RU=floor(FF2*1000)/1000;
                   XR=x2;
               end
             else
               FF2=inf;
               n2=c*n+n;
               x2=[];
             end
            end
        end
    end
    %% ��ȡ��������
    if n1==0 && n2==0
        fz=0; flag=0;
     else fz=1;
    end
    F1=floor(FF1*1000)/1000;
    F2=floor(FF2*1000)/1000;
    Fmin=min(F1,F2);  %%%
    Fmax=max(F1,F2);
    %%%%%����ʽ����
   if fz==1
   if (Fmin<RU && Fmin<FMin)
       fa=F1/(F1+F2);  %��һ��
       fb=F2/(F1+F2);
       na=n1/(n1+n2);
       nb=n2/(n1+n2);
     if (fa+na)<(fb+nb)    %���ۺ���
        x=x1;
        Ub=BB(:,1);        %��֧��ѡ��
        Lb=LbP;
       if F2<RU
        StX(:,k)=x2;
        StF(k)=F2;         %ԭʼ�ڵ��ֵ
        SUb(:,k)=UbP;
        SLb(:,k)=BB(:,2);
        k=k+1;
       end
     else   
        x=x2;              %�½�
        Lb=BB(:,2);
        Ub=UbP;
        if F1<RU
          StX(:,k)=x1;
          StF(k)=F1;
          SUb(:,k)=BB(:,1);
          SLb(:,k)=LbP;
          k=k+1;
        end
      end
    [flag,S,H]=fNull(x,n);
      else flag=0;
    end
   end
    if (flag==0)          %������н�
      [minF,ni]=min(StF);
       if (length(minF)>=1) && (RU>minF) && (minF<MRU)
          x=StX(:,ni);
          Ub=SUb(:,ni);
          Lb=SLb(:,ni);
          fp=minF;
          StF(ni)=[];
          StX(:,ni)=[];
          SUb(:,ni)=[];
          SLb(:,ni)=[];
          k=k-1;
       else x=[];
       end
    end
    [flag,S,H]=fNull(x,n);
    if (isempty(SH)~=1) && (isempty(XR)==1) && (isempty(x)==1)
        hfg=1;                         %�жϽڵ������Ƿ���Ч
        H=SH;
        S=SS;
        Ub=UP;
        Lb=LP;
      else hfg=0;
    end
    display('-----one------');
 end
   %%%%�洢ÿ�ν��%%%%%ERROR
        display('----OK-----')
        FRU=0;
        if sg==1
          for ir=1:length(DM(:,1))
             Dm=DM(ir,:);   %��������ź���Ŀ��С
             FRU=Dm(2)*Po*Pr(Dm(1))+FRU;
          end
        end
        RU=RU+FRU;
        if RU<FMin && (isempty(XR)~=1)
               rmd=XR(n+1:n+c*n);
               SXR=XR;
               rx=[];
               rxt=[];
               for jt=0:(c-1)
                  for it=1:n
                    k2=jt*n+it;
                    rx(jt+1,it)=rmd(k2);
                  end
               end
%                 rxt=rx';
%                 FRU=0;
                if sg==1    %�����и��ص���������������
%                     for ir=1:length(DM(:,1))
%                         Dm=DM(ir,:);   %��������ź���Ŀ��С
%                         FRU=Dm(2)*Po*Pr(Dm(1))+FRU;
%                         XR(Dm(1))=Dm(2)+XR(Dm(1));
%                     end 
           %%%%%%%%%��ԭ���ط������%%%%%%%%%%%
                    for kr=1:length(H1)   
                        jr=H2(kr);  %�˿ں�
                        tr=H1(kr);  %Data center
                        Fz=zeros(1,n);
                        Fz(tr)=Lm(kr);
                        r=length(rx(:,1));
                        if jr<=r
                           rxj=rx([1:jr-1],:);
                           rxc=rx([jr:r],:);
                           rx=[rxj;Fz;rxc];
                           r=r+1;
                        else rx=[rx;Fz];
                        end
                    end
                  
                end
                rxt=rx';
             %% ����ʱ
                 fg=1;
                 Smt=YTT;
                 Tm=[];
                 for i=1:n
                     while (fg)
                          [tm,ri]=max(Smt');      %ĳһ���������������ʱ�Ĵ�С��λ��
                          kk=ri(i);
                          if rxt(i,kk)>0.1  %���ֵ��Ӧ��rmd
                            Tm(i)=tm(i);       
                            fg=0;
                          else 
                              Smt(i,kk)=0;  %%%%
                               Ty=Smt(i,:);
                               if all(Ty<=0)
                                   Tm(i)=0;
                                   fg=0;
                               end
                          end     
                      end
                     fg=1;
                 end
                SMD=[];
                SMD=sum(rx);               %��ĳһ���������ĵĸ�����Ŀ
                for j=1:n
                    if SMD(j)>=1
                       Load(j)=SMD(j)+1./(D-Tm(j));
                    else Load(j)=0;
                    end
                end
               %%%%��򿪵ķ�������Ŀ%%%%%%%%
                Load=round(Load*100)/100;
                Server=ceil(Load/u);          %��������Ŀ
                RU=Server*Pr'*Po;
                if RU<FMin
                   Stm=Tmm;                    %�洢ʱ�� 
                   FMin=RU;                
                   SSTm=Tm;                   %������ʱ�洢 
                   S_M=Server;                %��������Ŀ
                   RX=rxt;
                end

                
                    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                     FRU=FRU+RU;
%                   if FRU<FMin
%                       UH=unique(H1);
%                      for i=1:length(UH);
%                          t_m=max(Smt(UH(i),:));
%                          dt1=(1/(D-t_m))/u; %tm��ʼ��ʱ������󣻳�����������
%                          dt2=(1/(D-Tmm(UH(i))))/u; %�����Ժ��tm
%                          dxr=ceil(dt2)-ceil(dt1);  %���
%                          XR(UH(i))=XR(UH(i))+dxr;
%                      end
%                    FMin=FRU;                    
%                    SXR=XR;
%                    Stm=Tmm;
%                    RX=rx;
%                    Trx=rx';
%                   end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                 end sg==1;
%                 if RU<FMin && (sg==0)
%                    FMin=RU;               
%                    Stm=Tmm;   %�洢ʱ�� 
%                    SXR=XR;
%                    RX=rx;
%                    Trx=rx'; 
%                    display('-------Cong Get it-----');
%                 end

        end
              RU=FMin;    %�ǳ���Ҫ�� important
              %%%����ռ�%%%%
              XR=[];
              StX=[];
              SUb=[];
              SLb=[];
              StF=[]; 
          end
      end
   end

    %% �洢���
    SPTM(nj,:)=SSTm;  %����ʱ����
    Tms(nj,:)=Stm;
    Fva=[Fva,FMin]; %����ֵ
    STM(nj,:)=S_M;  %��������Ŀ
 end
xlswrite('OPServer',STM);%%%server numbers
xlswrite('OPVal',Fva);  %optimal cost
xlswrite('OPTime',Tms);
xlswrite('SPtm',SPTM);  %optimal time
display('------*******the running is OK Now********---');
toc