%%
clear all;
%% OxyValve
r = 1e-2;%m
OxyValve.Cv_vector = [2.6930e-4,0.0031,0.0081,0.0128,0.0184,0.0251,...
    0.0321,0.0390,0.0460,0.0529,0.0604,0.0686,0.0742,0.0820,0.0861,0.0918,0.0975,0.1032,0.1129,0.1156,0.1165];% 1 
OxyValve.opening_vector = [0.5078,0.5334,0.5590,0.5846,0.6102,0.6358,0.6614,0.6870,0.7127,...
    0.7383,0.7639,0.7895,0.8151,0.8407,0.8663,0.8919,0.9175,0.9431,0.9688,0.9944,1];
OxyValve.Cross_Area = pi*r^2;%m^2
OxyValve.Pressure_Source = 500e3;%Pa
clear r;
%% FanHousing
r = 1e-2;%m
FanHousing.resistance = 1;%cmH2O/(L/s)
FanHousing.pressure_drop = FanHousing.resistance;%cmH2O
FanHousing.flow_rate = 1;%L/s
FanHousing.Crosss_Area = pi*r^2;
FanHousing.Chamber_volume = 1e-4;%m^3
FanHousing.A_area = pi*r^2;%m^2
FanHousing.B_area = pi*r^2;%m^2
FanHousing.C_area = pi*r^2;%m^2
clear r;
%% OxygenSensor
OxygenSensor.Air_oxygen_concentration = 0.209;
OxygenSensor.K = 1-OxygenSensor.Air_oxygen_concentration;
%% Turbo
load("FanParam.mat");
r = 1e-2;%m
Fan.shaftspeed = shaftspeed;%rpm
Fan.presstable = presstable;%kPa
Fan.flowvector = flowvector;%lpm
Fan.efficiency = efficiency;% 1 
Fan.Inlerarea_A = pi*r^2;%m
Fan.Inlerarea_B = pi*r^2;%m
percentage_to_rpm = 6e4/100;%涡轮最高转速60000rpm
clear r Turbo shaftspeed presstable flowvector efficiency;
%% Pipe between turbo and inspvalve
r = 1e-2;%m
Pipe_1.r = r;%m
Pipe_1.longlength = 0.1;%m
Pipe_1.area = pi*r^2;%m^2
Pipe_1.diameter = 2*r;%m
clear r;
%% InspValveModel
r = 1e-2;%m
Percent_to_Unit = 1/100;
Pa_to_cmH2O = 1/98.0638;
InspValve.opening_vector = [0,0.052,0.105,0.157,0.210,0.263,0.315,0.368,0.421,0.473,0.526,0.578,0.631,0.684,0.736,0.789,0.842,0.894,0.947,1];% 1 
InspValve.Cv_vector = [1e-4,0.810,1.114,1.723,3.218,3.547,4.603,5.2063,6.069,6.57,6.974,7.226,7.563,7.856,7.997,8.565,8.84,9.267,9.621,10.487];
Detpress_to_Vavle.detpress = [1.45,1.55,1.6,1.65,1.7,1.75,1.8,1.85,1.9,1.95,2.0,2.05,5,7,26,42,60,78,99,112];%cmH2O
Detpress_to_Vavle.vavle = [0.999,0.94,0.89,0.84,0.78,0.73,0.68,0.63,0.57,0.52,0.47,0.42,0.36,0.31,0.25,0.21,0.15,0.10,0.05,0];% 1 
InspValve.threshold = 0.0011;% 1 
InspValve.zerovalue = 0; % 1
InspValve.Cross_Area = pi*r^2;%m^2
clear r;
%% Pipe between inspvalve and mask
r = 1e-2;%m
Pipe_2.r = r;%m
Pipe_2.longlength = 0.1;%m
Pipe_2.area = pi*r^2;%m^2
Pipe_2.diameter = 2*r;%m
clear r;
%% Flow Resistance between inspvalve and mask
cmH2O_to_kPa = 98.1e-3;
Air_density = 1.29;%kg/m^3
r = 1e-2;%m
Flow_Resistance_1.resistance = 0.1;%cmH2O/(L/s)
Flow_Resistance_1.pressure_drop = Flow_Resistance_1.resistance;%cmH2O
Flow_Resistance_1.flow_rate = 1;%L/s
Flow_Resistance_1.Crosss_Area = pi*r^2;
clear r;
%% safevalve
r = 1e-2;%m
safevalve.Valve_Maximum_Cv = 4;
safevalve.Valve_xT_Pressure = 0.7;
safevalve.Valve_Leakage_flow = 1e-6;
safevalve.Valve_opening_fraction_offset = 0.95;
safevalve.Valve_Cross_Area = pi*r^2;%m^2
safevalve.Zero = 0;
safevalve.Valve_Threshold = 0.5;
safevalve.Safe_Pressure = 12e3;% Pa
safevalve.Gain = 1/safevalve.Safe_Pressure*safevalve.Valve_opening_fraction_offset;% 1/Pa
clear r;
%% Mask
r = 1e-2;%m
Mask.Chamber_volume = 2e-4;%m^3
Mask.A_area = pi*r^2;%m^2
Mask.B_area = pi*r^2;%m^2
Mask.C_area = pi*r^2;%m^2
clear r;
%% Lung
L_to_m3 = 1e-3;
cmH2O_to_Pa = 98.0638;
r = 1e-2;%m
% Trachea
Trachea.Pipe_length = 0.15;%m
Trachea.area = pi*r^2;%m^2
Trachea.Hydraulic_diameter = 2*r;%m
%lung
FRC = 2;%L
Body_Temperature = 37;%degC
% lung.Initial_displacement = FRC*L_to_m3;%m
lung.Interface_area = 1;%m2,注意这里必须是单位面积
lung.Dead_volume = 1e-6;%m3
lung.Cross_area = pi*r^2;%m^2
%Elastance
E_respriatory = 10;%cmH2O/L
%Elastance.Spring_rate = E_respriatory*(lung.Interface_area^2)*(cmH2O_to_Pa/L_to_m3);%N/m
%Resistance
R_respiratory = 2;%cmH2O/(L/s)
% Resistance.Damping_coefficient = R_respiratory*(lung.Interface_area^2)*(cmH2O_to_Pa/L_to_m3);%N/(m/s)
%HardStop
Volume_Max = 900e-3;%L
% Hard_Stop.Upper_bound = 200e-3*L_to_m3/lung.Interface_area;%m
Hard_Stop.Lower_bound = -1*lung.Dead_volume/lung.Interface_area;%m
clear r;
%% Pipe between between mask and expvalve
r = 1e-2;%m
Pipe_3.r = r;%m
Pipe_3.longlength = 0.1;%m
Pipe_3.area = pi*r^2;%m^2
Pipe_3.diameter = 2*r;%m

%% Flow Resistance between mask and expvalve
r = 1e-2;%m
Flow_Resistance_2.resistance = 0.1;%cmH2O/(L/s)
Flow_Resistance_2.pressure_drop = Flow_Resistance_1.resistance;%cmH2O
Flow_Resistance_2.flow_rate = 1;%L/s
Flow_Resistance_2.Crosss_Area = pi*r^2;
clear r;
%% ExpValveModel
r = 1e-2;%m
ExpValve.opening_vector = [0,0.052,0.105,0.157,0.210,0.263,0.315,0.368,0.421,0.473,0.526,0.578,0.631,0.684,0.736,0.789,0.842,0.894,0.947,1];% 1 
ExpValve.Cv_vector = [1e-4,0.810,1.114,1.723,3.218,3.547,4.603,5.2063,6.069,6.57,6.974,7.226,7.563,7.856,7.997,8.565,8.84,9.267,9.621,10.487];
Detpress_to_Vavle.detpress = [1.45,1.55,1.6,1.65,1.7,1.75,1.8,1.85,1.9,1.95,2.0,2.05,5,7,26,42,60,78,99,112];%cmH2O
Detpress_to_Vavle.vavle = [0.999,0.94,0.89,0.84,0.78,0.73,0.68,0.63,0.57,0.52,0.47,0.42,0.36,0.31,0.25,0.21,0.15,0.10,0.05,0];% 1 
ExpValve.threshold = 0.0011;% 1 
ExpValve.zerovalue = 0; % 1
ExpValve.Cross_Area = pi*r^2;%m^2
ExpValve.fullValue = 1;
clear r;
%% InletReservoir and OutletReservoir and Pressure Sensor
r = 1e-2;%m
Reservoir.Cross_area = pi*r^2;%m^2
clear r;
%% CtrlData
CtrlData_Max = 100;
CtrlData_Min = 0;
%% 
clear out;
