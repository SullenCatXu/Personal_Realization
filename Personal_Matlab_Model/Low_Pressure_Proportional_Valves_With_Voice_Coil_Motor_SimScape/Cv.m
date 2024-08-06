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
x_det_max = 5e-3;%线圈最大位移，m
x_det = 0:1e-3:(x_det_max);%线圈位移，即阀口位移，m
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
Q_lmin = Q*1e3*60;
% plot(x_det,Q_lmin);

%% Cv计算
t=0;
z = 0.8872;
Q_m3h = Q*60*60;%m3s to m3h
p_in_kPa = p_in*1e-3;
p_0_kPa = p_0*1e-3;
% Kv = Q_m3h/(2.9*p_in_kPa)*power(rho_air*(273+t),0.5);
Kv = Q_m3h/3.34*power(rho_air*(273+t)/((p_in_kPa-p_0_kPa)*(p_in_kPa+p_0_kPa)),0.5);
cv = Kv/1.167;
plot(x_det,cv)
%% 
Cv_valve = [5.96e-7,0.1162,0.3466,0.5513,0.7492,0.9454,1.1418,1.3383,...
            1.5338,1.7263,1.9134,2.0926,2.2614,2.4180,2.5610,2.6894,...
            2.8033,2.9031,2.9897,3.0644,3.1283];
Open_vector = [0,0.05,0.10,0.15,0.20,0.25,0.30,0.35,0.40,0.45,0.50,0.55,...
                0.60,0.65,0.70,0.75,0.80,0.85,0.90,0.95,1.0];








