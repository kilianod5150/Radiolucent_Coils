function [R] = Coil_Resistance_Calculate(x_points,y_points,z_points,trace_width, trace_thickness, trace_resistivity, via_resistance)
%COIL_RESISTANCE_CALCULATE Summary of this function goes here
%   Assumes coil is on the xy plane and not rotated in space, vertical z
%   displacements are counted as vias
x_diff=diff(x_points')';
y_diff=diff(y_points')';
z_diff=diff(z_points')';

number_of_vias=sum(z_diff~=0);

trace_length=sum(sqrt(x_diff.^2+y_diff.^2));


R=number_of_vias*via_resistance+trace_resistivity*trace_length./(trace_width*trace_thickness);

end

