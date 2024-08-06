% VCA
% 音圈电磁力模型
%% 
clc;
clear;
%% Pg-气隙磁导
% 默认音圈的永磁铁为圆柱形式
mu_0 = pi*4e-7;%磁导率，N*A^-2
r1 = 12e-3;%极片半径，m
r2 = 20e-3;%外壳半径，m
h = 10e-3;%极片高度，m
%Ag = (r2-r1)*h;%气隙磁路横截面，m^2
Ag = 2*pi*(r2+r1)*h;%气隙面积，m^2
Lg = 2*pi*(r1+r2)/2;%气隙长度，m
Pg = mu_0*Ag/Lg;%气隙磁导,H/m
%%  气隙外总泄露磁导-Ptl
Dp = r1*2;%极片直径，m
Dy = r2*2;%扼片直径，m
Dm = 10e-3*2;%磁铁直径，m
Lm = 10e-3;%磁铁长度，m
Pf1 = 0.264*pi*mu_0*(Dp+Lg);
Pf2 = mu_0*(Dp+Lg)*log(1+Dp/Lg);
Pf3 = mu_0*(Dp+Lg)*log(1+(Dp-Dm)/Lg);
Pi = pi*mu_0*Lm*(Dm+Dy)/(4*(Dy-Dm));
Pl = pi*mu_0*sqrt(Dm*Lm/2);
P_ex = max(Pi,Pl);
Ptl = Pf1+Pf2+Pf3+P_ex;%气隙外总泄露磁导
%% 磁导泄露系数-sigma
Pt = Pg+Ptl;%电路的总磁导
sigma = Pt/Pg;%磁导泄露系数
%% 实际磁导-Pc
Am = 2*pi*(Dm/2)^2+2*pi*(Dm/2)*Lm;%磁铁面积，m^2
Pc = mu_0*(Ag*Lm/(Am*Lg))*sigma;
%% 工作点的磁通密度-Bd
Br = 20;%最大磁通密度，H，不确定
mu_rec = 1*mu_0;%相对磁导率，不确定
Bd = Br/(1+mu_rec/Pc);
%% 气隙的磁通密度-Bg
Bg = Am*Bd/(Ag*sigma);%气隙的磁通密度
%% 气隙外磁通密度的归一化函数-Bnorm
ks = 20;%优化参数，针对不同的音圈需要调整
syms x;
Bnorm = Lg/(ks*pi*x+Lg);
%% 气隙上下的磁通密度-Ba,Bb
Ba = Bg*Bnorm;
Bb = Ba;
%% 电磁力系数-Bl
x_det_max = 9e-3;%线圈最大位移，m
x_init = 0e-3;%线圈初始位移，m
xi = 5e-3;%内部线圈长度，m，小于Lm
xg = h/2;%气隙线圈长度，m
xo = 10e-4;%外部线圈长度，m
Number_Of_CoilTurns = 10e3;% 线圈匝数5e3,20e3
length_of_coil = 2e-3;% 线圈宽度，m
x_det = x_init:5e-4:x_init+x_det_max;
for i = 1:length(x_det)
    i;
    % x = x_init+x_det(i);
    % if(x<xi)
    %     if((x+length_of_coil)<xi)
    %         li = (length_of_coil)*2*pi*r1;
    %         lg = 0*2*pi*r1;
    %     else
    %         li = (length_of_coil-((x+length_of_coil)-xi))*2*pi*r1;
    %         lg = ((x+length_of_coil)-xi)*2*pi*r1;
    %     end
    %     lo = 0*2*pi*r1;
    % elseif(x<(xi+xg))
    %     li = 0*2*pi*r1;
    %     if((x+length_of_coil)<(xi+xg))
    %         lg = length_of_coil*2*pi*r1;
    %         lo = 0*2*pi*r1;
    %     else
    %         lg = (length_of_coil-((x+length_of_coil)-(xi+xg)))*2*pi*r1;
    %         lo = ((x+length_of_coil)-(xi+xg))*2*pi*r1;
    %     end
    % else
    %     li = 0*2*pi*r1;
    %     lg = 0*2*pi*r1;
    %     lo = length_of_coil*2*pi*r1;
    % end
    % B_li(i) = eval(int(Ba,x,x+li));
    % B_lg(i) = Bg*lg;
    % B_lo(i) = eval(int(Bb,x,x+lo));
    li = (xi-x_det(i))*2*pi*r1;
    lg = xg*2*pi*r1;
    lo = (xo+x_det(i))*2*pi*r1;
    % B_li(i) = eval(int(Ba,0,li));
    % B_lg(i) = Bg*lg;
    % B_lo(i) = eval(int(Bb,0,lo));
    B_li(i) = Bg*Lg*log(Lg+pi*ks*li)/(ks*pi)-Bg*Lg*log(Lg+pi*ks*0)/(ks*pi);
    B_lg(i) = Bg*lg;
    B_lo(i) = Bg*Lg*log(Lg+pi*ks*lo)/(ks*pi)-Bg*Lg*log(Lg+pi*ks*0)/(ks*pi);
    B_t(i) = (B_li(i)+B_lg(i)+B_lo(i))*Number_Of_CoilTurns;
end
% f1 = figure(1);
plot(x_det,B_t);
%% 三部分的磁通密度显示
position = 0:1e-4:(xi+xg+xo);
for  i = 1:length(position)
    if(position(i)<=xi)
        x = xi-position(i);
        B(i) = eval(Ba);
    elseif(position(i)<=(xi+xg))
        B(i) = Bg;
    else
        x = position(i)-((xi+xg));
        B(i) = eval(Ba);
    end
end
% f2 = figure(2);
plot(position,B);
%% 电磁力-F
I = 1;%线圈电流，A
F = B_t * I;
plot(x_det,F);











