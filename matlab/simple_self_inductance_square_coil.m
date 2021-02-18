function [L,rho] = simple_self_inductance_square_coil(d_out,number_of_layers,N_total,spacing,width)
%SIMPLE_SELF_INDUCTANCE_SQUARE_COIL Summary of this function goes here
%   Detailed explanation goes here
d_in=d_out-2*floor(N_total/number_of_layers)*(spacing+width);
d_avg=(d_out+d_in)/2;
rho=(d_out-d_in)/(d_out+d_in);
K1=2.34;
K2=2.75;
u0=4*pi*1e-7;
L=K1*u0*(N_total^2)*d_avg/(1+K2*rho);
end

