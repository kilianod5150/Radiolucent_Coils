function [plot_handle] = quiver_plot_coil(x_points,y_points,z_points)
%QUIVER_PLOT_COIL Summary of this function goes here
%   Detailed explanation goes here


quiver_vec_x=diff(x_points);
quiver_vec_y=diff(y_points);
quiver_vec_z=diff(z_points);

quiver_pos_x=(x_points(1:end-1))+.5*quiver_vec_x;
quiver_pos_y=(y_points(1:end-1))+.5*quiver_vec_y;
quiver_pos_z=(z_points(1:end-1))+.5*quiver_vec_z;


figure
plot3(x_points,y_points,z_points)
hold on
quiver3(quiver_pos_x,quiver_pos_y,quiver_pos_z,quiver_vec_x,quiver_vec_y,quiver_vec_z,'r')
axis equal


xlabel('x')
ylabel('y')
zlabel('z')

plot_handle=gcf;


end

