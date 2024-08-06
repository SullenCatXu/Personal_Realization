%% 
clc;
clear;
%%
data = readtable("开度-压差-流量曲线 - 竞品.xlsx");
t=0;
z = 0.8872;
rho_air = 1.248;%空气密度，kg/m^3
p_0 = 101e3;%阀外出口压力，Pa,(默认为标准大气压)
p_0_kPa = p_0*1e-3;
%% x-1mm
p_in_kPa = table2array(data(1:6,3))*1e-3;
Q_m3h = table2array(data(1:6,4))*60*60;
p_in_kPa = p_in_kPa+p_0_kPa;
Kv = Q_m3h/3.34.*power(rho_air*(273+t)./((p_in_kPa-p_0_kPa).*(p_in_kPa+p_0_kPa)),0.5);
Cv = Kv/1.167;
valve{1,1} = 1;
valve{1,2} = Cv;
%% x-2mm
p_in_kPa = table2array(data(7:12,3))*1e-3;
Q_m3h = table2array(data(7:12,4))*60*60;
p_in_kPa = p_in_kPa+p_0_kPa;
Kv = Q_m3h/3.34.*power(rho_air*(273+t)./((p_in_kPa-p_0_kPa).*(p_in_kPa+p_0_kPa)),0.5);
Cv = Kv/1.167;
valve{2,1} = 2;
valve{2,2} = Cv;
%% x-3mm
p_in_kPa = table2array(data(13:18,3))*1e-3;
Q_m3h = table2array(data(13:18,4))*60*60;
p_in_kPa = p_in_kPa+p_0_kPa;
Kv = Q_m3h/3.34.*power(rho_air*(273+t)./((p_in_kPa-p_0_kPa).*(p_in_kPa+p_0_kPa)),0.5);
Cv = Kv/1.167;
valve{3,1} = 3;
valve{3,2} = Cv;
%% x-4mm
p_in_kPa = table2array(data(19:24,3))*1e-3;
Q_m3h = table2array(data(19:24,4))*60*60;
p_in_kPa = p_in_kPa+p_0_kPa;
Kv = Q_m3h/3.34.*power(rho_air*(273+t)./((p_in_kPa-p_0_kPa).*(p_in_kPa+p_0_kPa)),0.5);
Cv = Kv/1.167;
valve{4,1} = 4;
valve{4,2} = Cv;
%% x-5mm
p_in_kPa = table2array(data(25:30,3))*1e-3;
Q_m3h = table2array(data(25:30,4))*60*60;
p_in_kPa = p_in_kPa+p_0_kPa;
Kv = Q_m3h/3.34.*power(rho_air*(273+t)./((p_in_kPa-p_0_kPa).*(p_in_kPa+p_0_kPa)),0.5);
d = 1./power(rho_air*(273+t)./((p_in_kPa-p_0_kPa).*(p_in_kPa+p_0_kPa)),0.5);
Cv = Kv/1.167;
valve{5,1} = 5;
valve{5,2} = Cv;
%%
figure(1);
hold on;
number = 1:1:6;
for i = 1:5
    plot(number,valve{i,2});
end



