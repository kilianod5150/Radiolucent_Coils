clc
clear
close all

%3 al designs
u0=4*pi*1e-7;
trace_resistivity=2.8e-8;
via_resistance=0;
f_test=3000;

%standard design
N_standard=57;
layer_count_standard=2;
width_standard=1.25e-3;
length_standard=130.5e-3;
spacing_standard=.25e-3;
layer_spacing_standard=2e-3;
trace_thickness_standard=50e-6;
I_standard=.2;

%new design
% N_new=300;
% layer_count_new=8;
% width_new=.8e-3;
% length_new=98e-3;
% spacing_new=.25e-3;
% layer_spacing_new=.008/layer_count_new;
% trace_thickness_new=6*35e-6;
% I_new=.2;

%new design
N_new=81;
layer_count_new=2;
width_new=.85e-3;
length_new=130.9e-3;
spacing_new=.25e-3;
layer_spacing_new=2e-3;
trace_thickness_new=50e-6;
I_new=.2;

%aluminium design
N_al=41;
trace_resistivity_al=2.8e-8;
layer_count_al=2;
width_al=.7e-3;
length_al_a=.5*130.5e-3;
length_al_b=2*130.5e-3;
length_al=sqrt(length_al_a*length_al_b);
spacing_al=.25e-3;
%spacing_al=.1778e-3;
layer_spacing_al=.002;
%trace_thickness_al=30e-6;
trace_thickness_al=50e-6;
I_al=.2;



[x_points_standard,y_points_standard,z_points_standard]=Multilayer_Rectangular_Coil(N_standard,layer_count_standard,length_standard,length_standard,width_standard,spacing_standard,layer_spacing_standard);
[x_points_new,y_points_new,z_points_new]=Multilayer_Rectangular_Coil(N_new,layer_count_new,length_new,length_new,width_new,spacing_new,layer_spacing_new);
[x_points_al,y_points_al,z_points_al]=Multilayer_Rectangular_Coil(N_al,layer_count_al,length_al_a,length_al_b,width_al,spacing_al,layer_spacing_al);


quiver_plot_coil(x_points_standard,y_points_standard,z_points_standard);
quiver_plot_coil(x_points_new,y_points_new,z_points_new);
quiver_plot_coil(x_points_al,y_points_al,z_points_al);

[R_standard] = Coil_Resistance_Calculate(x_points_standard,y_points_standard,z_points_standard,width_standard, trace_thickness_standard, trace_resistivity, via_resistance);
[L_standard,rho_standard] = simple_self_inductance_square_coil(length_standard,layer_count_standard,N_standard,spacing_standard,width_standard);
Z_standard=sqrt(R_standard.^2+(2*pi*L_standard*f_test).^2);
V_standard=I_standard*Z_standard;
P_standard=(I_standard^2)*R_standard;
C_res_standard=1./((4*(pi^2)*L_standard)*(f_test^2+(R_standard^2)/(16*(pi^2)*(L_standard^2))));

[R_new] = Coil_Resistance_Calculate(x_points_new,y_points_new,z_points_new,width_new, trace_thickness_new, trace_resistivity, via_resistance);
[L_new,rho_new] = simple_self_inductance_square_coil(length_new,layer_count_new,N_new,spacing_new,width_new);
Z_new=sqrt(R_new.^2+(2*pi*L_new*f_test).^2);
V_new=I_new*Z_new;
P_new=(I_new^2)*R_new;
C_res_new=1./((4*(pi^2)*L_new)*(f_test^2+(R_new^2)/(16*(pi^2)*(L_new^2))));


[R_al] = Coil_Resistance_Calculate(x_points_al,y_points_al,z_points_al,width_al, trace_thickness_al, trace_resistivity_al, via_resistance);
[L_al,rho_al] = simple_self_inductance_square_coil(length_al,layer_count_al,N_al,spacing_al,width_al);
Z_al=sqrt(R_al.^2+(2*pi*L_al*f_test).^2);
V_al=I_al*Z_al;
P_al=(I_al^2)*R_al;
C_res_al=1./((4*(pi^2)*L_al)*(f_test^2+(R_al^2)/(16*(pi^2)*(L_al^2))));




x_test=0;
y_test=0;
z_test=0.15;
[Hx,Hy,Hz]= spiral_coil_efficent_calc_matrix(I_standard,x_points_standard,y_points_standard,z_points_standard,x_test,y_test,z_test);
B_test_standard=u0*sqrt(Hx.^2+Hy.^2+Hz.^2);
[Hx_new,Hy_new,Hz_new]= spiral_coil_efficent_calc_matrix(I_new,x_points_new,y_points_new,z_points_new,x_test,y_test,z_test);
B_test_new=u0*sqrt(Hx_new.^2+Hy_new.^2+Hz_new.^2);
[Hx_al,Hy_al,Hz_al]= spiral_coil_efficent_calc_matrix(I_al,x_points_al,y_points_al,z_points_al,x_test,y_test,z_test);
B_test_al=u0*sqrt(Hx_al.^2+Hy_al.^2+Hz_al.^2);

al_1_values=[R_standard;L_standard;rho_standard;Z_standard;V_standard;P_standard;B_test_standard;C_res_standard,];
al_2_values=[R_new;L_new;rho_new;Z_new;V_new;P_new;B_test_new; C_res_new];
al_3_values=[R_al;L_al;rho_al;Z_al;V_al;P_al;B_test_al; C_res_al];
table_strings={'R [ohms]','L [H]','Rho','Z [Ohms]','V [Volts peak]','P [W]','B Test [T]','C_res [F]'};
T=table(table_strings',al_1_values,al_2_values,al_3_values)
%T=table(table_strings)



Pz=linspace(0,.6,100);
Py=0;
Px=0;
for i=1:length(Pz);
[Hx(i),Hy(i),Hz(i)]= spiral_coil_efficent_calc_matrix(I_standard,x_points_standard,y_points_standard,z_points_standard,Px,Py,Pz(i));
[Hx_new(i),Hy_new(i),Hz_new(i)]= spiral_coil_efficent_calc_matrix(I_new,x_points_new,y_points_new,z_points_new,Px,Py,Pz(i));
[Hx_al(i),Hy_al(i),Hz_al(i)]= spiral_coil_efficent_calc_matrix(I_al,x_points_al,y_points_al,z_points_al,Px,Py,Pz(i));

H_mag(i)=sqrt(Hx(i).^2+Hy(i).^2+Hz(i).^2);
H_mag_new(i)=sqrt(Hx_new(i).^2+Hy_new(i).^2+Hz_new(i).^2);
H_mag_al(i)=sqrt(Hx_al(i).^2+Hy_al(i).^2+Hz_al(i).^2);

end

figure
semilogy(Pz,u0*H_mag*1e6)
hold on
semilogy(Pz,u0*H_mag_new*1e6,'r')
semilogy(Pz,u0*H_mag_al*1e6,'g')

xlabel('z [m]')
ylabel('B Mag [uT]')
legend('Al 1','Al 2','Al 3')


figure
semilogy(Pz,u0*H_mag*1e6)

grid on

xlabel('z [m]')
ylabel('|B|  [\muT]')

hold on
plot([0 1],[100 100])
xlim([0 .3])
legend('Magnetic flux density','ICNIRP Guidelines Limit')

%Mp = spiralCoilFieldCalcFilaments(A,B,a,b)