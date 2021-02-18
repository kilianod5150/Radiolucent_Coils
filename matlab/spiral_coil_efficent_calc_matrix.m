function [Hx,Hy,Hz]= spiral_coil_efficent_calc_matrix(I,x_points,y_points,z_points,Px,Py,Pz)

%I=Filament current
%a_start=x,y,z coor of start of filament
%a_end=x,y,z coord ofned of filament
%P=x,y,z,obseration point

%Function to calculate the magnetic field due a straight currrent filament
%at an arbitary orientation relative to an origin

%Based on "Accurate magnetic field intensity calculations for contactless
%energy transfer coils" - Sonntag, Spree, et al
num_p=length(x_points);

ax=x_points(:,2:num_p)-x_points(:,1:(num_p-1));
ay=y_points(:,2:num_p)-y_points(:,1:(num_p-1));
az=z_points(:,2:num_p)-z_points(:,1:(num_p-1));

bx=x_points(:,2:num_p)-Px;
by=y_points(:,2:num_p)-Py;
bz=z_points(:,2:num_p)-Pz;

cx=x_points(:,1:(num_p-1))-Px;
cy=y_points(:,1:(num_p-1))-Py;
cz=z_points(:,1:(num_p-1))-Pz;

mag_c=sqrt(cx.^2+cy.^2+cz.^2);

mag_b=sqrt(bx.^2+by.^2+bz.^2);

a_dot_b=ax.*bx+ay.*by+az.*bz;

a_dot_c=ax.*cx+ay.*cy+az.*cz;

c_cross_a_x=az.*cy-ay.*cz;
c_cross_a_y=ax.*cz-az.*cx;
c_cross_a_z=cx.*ay-cy.*ax;

mag_squared_c_cross_a=c_cross_a_x.^2+c_cross_a_y.^2+c_cross_a_z.^2;

scalar_2nd_bit=((a_dot_c./mag_c)-(a_dot_b./mag_b))./mag_squared_c_cross_a;

Hx_dum=(I/(4*pi))*c_cross_a_x.*scalar_2nd_bit;
Hy_dum=(I/(4*pi))*c_cross_a_y.*scalar_2nd_bit;
Hz_dum=(I/(4*pi))*c_cross_a_z.*scalar_2nd_bit;

Hx_dum(isnan(Hx_dum)) = 0 ;
Hy_dum(isnan(Hy_dum)) = 0 ;
Hz_dum(isnan(Hz_dum)) = 0 ;

% 
 Hx=sum(Hx_dum,2);
 Hy=sum(Hy_dum,2);
 Hz=sum(Hz_dum,2);


