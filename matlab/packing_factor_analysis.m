clc
clear
close all

u0=4*pi*1e-7;
trace_resistivity=2.8e-8;
via_resistance=0;
f_test=4000;

z_max=18;

%standard design
%
layer_count_standard=2;

length_standard=130.5e-3;
spacing_standard=.25e-3;
layer_spacing_standard=2e-3;
trace_thickness_standard=50e-6;
I_standard=.15;


rho_array=[0.25 0.5 0.75];
%rho_array=[0.5 ];
x_test=0;
y_test=0;
z_test=0.5;
w_min=0.25e-3;


for j=1:length(rho_array);
    
    rho=rho_array(j);
    i=1;
for N=3:2:100;
    
%width_standard=1.25e-3;


lin=length_standard*(1-rho)/(1+rho);

window=0.5*(length_standard-lin);
%width=1.1*2*(window-N*spacing_standard)/N;
width=1.2*layer_count_standard*(window+(1-N)*spacing_standard)/N;

if width<w_min;
    width=0;
    I_standard=0;
else
    I_standard=.15;
end

[x_points_standard,y_points_standard,z_points_standard]=Multilayer_Rectangular_Coil(N,layer_count_standard,length_standard,length_standard,width,spacing_standard,layer_spacing_standard);

[R_standard(i,j)] = Coil_Resistance_Calculate(x_points_standard,y_points_standard,z_points_standard,width, trace_thickness_standard, trace_resistivity, via_resistance);
[L_standard(i,j),rho_standard(i,j)] = simple_self_inductance_square_coil(length_standard,layer_count_standard,N,spacing_standard,width);
Z_standard(i,j)=sqrt(R_standard(i,j).^2+(2*pi*L_standard(i,j)*f_test).^2);


[Hx,Hy,Hz]= spiral_coil_efficent_calc_matrix(I_standard,x_points_standard,y_points_standard,z_points_standard,x_test,y_test,z_test);
B_test_standard(i,j)=u0*sqrt(Hx.^2+Hy.^2+Hz.^2);


N_store(i,j)=N;
rho_store(i,j)=rho;
width_store(i,j)=width;
i=i+1;
end

%find z_max
z_min_finder=abs(Z_standard(:,j)-z_max);
index_for_z_min=find(z_min_finder==min(z_min_finder));
Z_standard(index_for_z_min,j)

B_max(j)=B_test_standard(index_for_z_min,j)

end


figure
subplot(3,1,1)
hold on
plot(N_store,Z_standard)

hold on
plot([1 1000],[z_max z_max])
set(gca, 'YScale', 'log')
set(gca, 'XScale', 'log')

xlim([10 max(max(N_store))])
grid on
%xlabel('Total coil turns')
ylabel('Coil impedance [\Omega]')
legend('\rho = 0.25','\rho = 0.5','\rho = 0.75','Max impedance')

subplot(3,1,2)


plot(N_store,1e6*B_test_standard)
xlim([10 max(max(N_store))])
set(gca, 'YScale', 'log')
set(gca, 'XScale', 'log')

grid on
%xlabel('Total coil turns')
ylabel('Magnetic flux density at 50cm [\muT]')
legend('\rho = 0.25','\rho = 0.5','\rho = 0.75')

subplot(3,1,3)

plot(N_store,1000*width_store)
xlim([10 max(max(N_store))])
set(gca, 'YScale', 'log')
set(gca, 'XScale', 'log')

grid on
xlabel('Total coil turns')
ylabel('Trace width [mm]')
legend('\rho = 0.25','\rho = 0.5','\rho = 0.75')



rho_array=0:.01:.95;

for j=1:length(rho_array);
    
    rho=rho_array(j);
    i=1;
for N=3:2:80;
    
%width_standard=1.25e-3;


lin=length_standard*(1-rho)/(1+rho);

window=0.5*(length_standard-lin);
%width=1.1*2*(window-N*spacing_standard)/N;
width=1.2*layer_count_standard*(window+(1-N)*spacing_standard)/N;

if width<w_min;
    width=w_min;
end

[x_points_standard,y_points_standard,z_points_standard]=Multilayer_Rectangular_Coil(N,layer_count_standard,length_standard,length_standard,width,spacing_standard,layer_spacing_standard);

[R_standard(i,j)] = Coil_Resistance_Calculate(x_points_standard,y_points_standard,z_points_standard,width, trace_thickness_standard, trace_resistivity, via_resistance);
[L_standard(i,j),rho_standard(i,j)] = simple_self_inductance_square_coil(length_standard,layer_count_standard,N,spacing_standard,width);
Z_standard(i,j)=sqrt(R_standard(i,j).^2+(2*pi*L_standard(i,j)*f_test).^2);


[Hx,Hy,Hz]= spiral_coil_efficent_calc_matrix(I_standard,x_points_standard,y_points_standard,z_points_standard,x_test,y_test,z_test);
B_test_standard(i,j)=u0*sqrt(Hx.^2+Hy.^2+Hz.^2);


N_store(i,j)=N;
rho_store(i,j)=rho;
width_store(i,j)=width;
i=i+1;
end

%find z_max
z_min_finder=abs(Z_standard(:,j)-z_max);
index_for_z_min=find(z_min_finder==min(z_min_finder));
Z_standard(index_for_z_min,j);

B_max(j)=B_test_standard(index_for_z_min,j);



end

figure
plot(rho_array,B_max)
