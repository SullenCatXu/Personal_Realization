% The Extended Smal Model
% 拓展的smal模型，包括流量模型、压力模型
%% 
clc;
clear;
%% 阀座和膜片的几何参数
r_vi= 5e-3;%阀内进气腔半径，m
r_in = 5e-3;%阀外进气口半径，m
r_c = 6e-3;%阀内进气腔末端半径，m
r_m = 2e-3;%膜片半径，m
r_ex = 5e-3;%阀外出气口半径，m
%% 流量模型-Flow Medel
p_0 = 101e3;%阀外出口压力，Pa,(默认为标准大气压)
p_in = 50e2+p_0;%阀外进气口压力,Pa
zeta_in = 1-(r_vi/r_in)^4;%阀进气口的压力损失因子，1
zeta_ex = 1-(r_ex/r_c)^4;%阀出气口的压力损失因子，1
x_det_max = 2e-3;%线圈最大位移，m
x_det = 1e-4:1e-4:(x_det_max);%线圈位移，即阀口位移，m
yr = x_det/(2*r_vi);%
zeta_yr = -6.1*exp(-4.13*yr)+0.497*(yr.^(-1.29))+1;%压力调整系数 
mu_air = 1.7894e-5;%空气粘度系数，Pa*s
rho_air = 1.248;%空气密度，kg/m^3
g1 = pi/(12*mu_air)*(r_c+r_in)/(r_c-r_in);
g2 = rho_air/2*g1*(1/(pi*r_in^2))^2;
g3 = rho_air/2*g1*(1/(pi*r_ex^2))^2;
g4 = rho_air/2*g1*(1/(2*pi*r_in))^2;
for i = 1:length(x_det)
    Q(i) = (-1+sqrt(1+4*((zeta_yr(i)+zeta_in-1)*g2*x_det(i)^3+zeta_ex*g3*x_det(i)^3+g4*x_det(i))*g1*x_det(i)^3*(p_in-p_0)))...
            /(2*((zeta_yr(i)+zeta_in-1)*g2*x_det(i)^3+zeta_ex*g3*x_det(i)^3+g4*x_det(i)));%m^3/s
end
% Q = (-1+siqrt(1+4*((zeta_yr+zeta_in-1)*g2.*x_det.^3+zeta_ex*g3*x_det.^3+g4.*x_det).*g1.*x_det.^3*(p_in-p_0)))...
%     ./2*((zeta_yr+zeta_in-1)*g2.*x_det.^3+zeta_ex*g3.*x_det.^3+g4.*x_det);
Q_lmin = Q*1e3*60;
plot(x_det,Q_lmin);
%% 拓展的smal压力模型
p_vi = p_in - zeta_in*(rho_air/2).*(Q./(pi*r_vi^2)).^2;%阀内进气腔压力，Pa
p_c = p_0 + zeta_ex*(rho_air/2).*(Q./(pi*r_ex^2)).^2;%阀内进气腔末端压力，Pa
%% 压力分布模型
n_yr = -29*exp(-77.2*yr)+27.8*exp(-17.5*yr);%压力分布指数
r = 0:1e-4:r_c;%进气腔在膜片上的半径
p1 = p_vi+rho_air/2*(Q/(pi*(r_vi)^2)).^2;%膜片中心压力
p2 = p1-rho_air/2*(Q./(2*pi*r_vi*x_det)).^2;%进气腔与膜片的交界处的压力
i = 3;
% for j = 1:length(r)
%     if(r(j)<r_in)
%         p(j) = p1(i)+(p2(i)-p1(i))/r_in^(n_yr(i))*r(j)^(n_yr(i));
%         % p(j) = p1(i)+(p2(i)-p1(i))/r_vi^2*r(j)^2;
%     else
%         p(j) = p_c(i)+(p2(i)-p_c(i))/(r_c-r_in)*(r_c-r(j));
%         % p(j) = p_c(i)+(p2(i)-p_c(i))/(r_c-r_vi)*(r_c-r(j));
%     end
% end
% plot(r,p)
%% 压力模型-Press Force Model
% a1 = pi*r_vi^2/2;
% a2 = pi*r_vi^2/2+pi*(pi*r_c^3+2*r_vi^3-3*r_c*r_vi^2)/(3*(r_c-r_vi));
% a1 = n_yr(i)/(n_yr(i)+2)*(pi*r_vi^2);
% a2 = 2/(n_yr(i)+2)*pi*r_vi^2+pi*(pi*r_c^3+2*r_in^3-3*r_c*r_in^2)/(3*(r_c-r_in));
% a3 = -1*pi*(pi*r_c^3+2*r_vi^3-3*r_c*r_vi^2)/(3*(r_c-r_vi))+pi*r_m^2-pi*r_vi^2;
% a4 = pi*r_m^2;
% F_p = a1*p1(i)+a2*p2(i)+a3*p_c(i)-a4*p_0;% 膜片所受压力
a1 = n_yr./(n_yr+2)*(pi*r_vi^2);
a2 = 2./(n_yr+2)*pi*r_vi^2+pi*(pi*r_c^3+2*r_in^3-3*r_c*r_in^2)/(3*(r_c-r_in));
a3 = -1*pi*(pi*r_c^3+2*r_vi^3-3*r_c*r_vi^2)/(3*(r_c-r_vi))+pi*r_m^2-pi*r_vi^2;
a4 = pi*r_m^2;
F_p = a1.*p1+a2.*p2+a3*p_c-a4*p_0;% 膜片所受压力
%% 流量导致的惯性力
F_i = 2*rho_air*Q.^2/(pi*r_in^2);







