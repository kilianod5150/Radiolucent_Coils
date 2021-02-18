clc
clear
close all

load('nist_xray_data.mat');

cu_kev=cu_table(:,1)*1000;
cu_mhu_m=8.96*cu_table(:,2)*100;

al_kev=al_table(:,1)*1000;
al_mhu_m=2.7*al_table(:,2)*100;


figure
plot(al_kev,al_mhu_m);
hold on
plot(cu_kev,cu_mhu_m,'r');
plot([20 20],[1,1e7],'k--')
plot([150 150],[1,1e7],'k--')


set(gca, 'XScale', 'log')
set(gca, 'YScale', 'log')

legend('Aluminium','Copper','Diagnostic imaging range')
xlabel('Photon Energy [kEv]')
ylabel('Absorption Coefficient [m^{-1}]')
grid on
xlim([1 1e4])


al_mhu_m(al_kev==80)
cu_mhu_m(cu_kev==80)

cu_x=50e-6;
al_x=50e-6;

cu_absorption=exp(-cu_mhu_m(cu_kev==80)*cu_x)
al_absorption=exp(-al_mhu_m(al_kev==80)*al_x)

(1-cu_absorption)./(1-al_absorption)


x_test=[10e-6 100e-6 1000e-6];



figure
hold on
grid on
for i=1:length(x_test);


cu_absorption_x=exp(-cu_mhu_m(16:23)*x_test(i));
al_absorption_x=exp(-al_mhu_m(13:20)*x_test(i));

gamma=(1-cu_absorption_x)./(1-al_absorption_x);

plot(al_kev(13:20),gamma)

end
xlim([20 150])
legend('10 \mum','100 \mum','1000 \mum')
xlabel('Photon Energy [kEv]')
ylabel('\gamma Relative attenuation ')
