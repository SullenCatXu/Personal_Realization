% LuGre_Friction
% LuGre摩擦力模型
%% 
clc;
clear;
%% Columb-库伦摩擦-Fc
mu_c = 0.10;%动摩擦系数
Fn = 1;%法向力,N
Fc = mu_c*Fn;%库伦摩擦,N
%% Viscous-粘性摩擦-Fv
% deta_v = 17.9e-6;%粘性系数，N*m^2/s
deta_v = 8e-3;%粘性系数，N*s/m 8e-1
v = 0:-1e-5:-2e-1;%速度，m/s
Fv = deta_v*v;
%% brk-临界摩擦-Fbrk
mu_b = 0.15;%临界(静)摩擦系数
Fbrk = mu_b*Fn;%临界摩擦,N
%% Stribeck-斯特里贝克摩擦-Fs
cv = 100;
for i = 1:length(v)
    Fs(i) = (Fbrk-Fc)*exp(-1*cv*abs(v(i)))*sign(v(i));
end
%% 总摩擦力-Ff
Ff = Fc+Fv+Fs;
%% 总摩擦力-Ff
v_TH = 1e-4;% 速度阈值，m/s
for i = 1:length(v)
    if(abs(v(i))<v_TH)
        Ff_TH(i) = v(i)*(Fc+(Fbrk-Fc)*exp(-1*cv*v_TH))/v_TH;
    else
        Ff_TH(i) = Fc+((Fbrk-Fc)*exp(-1*cv*abs(v(i)))*sign(v(i)))+Fv(i);
    end
end
%%
f1 = figure(1);
hold on;
plot(v,Ff);
plot(v,Ff_TH);
%% 基于刚毛挠度的计算方法，但需要积分计算，依赖于ts
function [Ff,z] = Lugref(z,v,Fc,Fs,vs,sigma_0,sigma_1,sigma_2,ts)
    r = (v/vs).^2;
    g_v = Fc+(Fs-Fc)*exp(-1*r)./sigma_0;
    z_dot = v-abs(v).*z./g_v;
    z = z+z_dot.*ts;
    Ff = sigma_0*z+sigma_1*z_dot+sigma_2*v;
end























