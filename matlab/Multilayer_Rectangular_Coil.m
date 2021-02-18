function [x_points_out,y_points_out,z_points_out]=Multilayer_Rectangular_Coil(N,layer_count,length_a,length_b,width,spacing,layer_spacing);

%New improved function that now allows the angles of the coil to be added
%and zeros the center point

%single layers, coils can be odd or even
%even numbers of layers must add up to an odd number of turns
%odd numbers of layers must have even
N_per_layer_decimal=N/layer_count;
N_odd=round_odd(2*N_per_layer_decimal);
%find number of even coil groups
even_number_coil_groups=floor(layer_count/2);

N_per_layer=floor(N_per_layer_decimal);
N_max_per_layer=floor((.5*min([length_a length_b])/(width+spacing)))+1;
N_single=N;
if(N_per_layer>N_max_per_layer) %check if there are too many layers
    N_single=N_max_per_layer;
    N_per_layer=N_max_per_layer-1;
    N_per_layer_decimal=N_per_layer;
    N_odd=round_odd(2*N_per_layer_decimal-1);
    even_number_coil_groups=floor(layer_count/2);
end

if layer_count==1
    [x_points_out,y_points_out,z_points_out]=rectangular_single_layer_points(N_single,length_a,length_b,width,spacing);
elseif layer_count==2
    [x_points_out,y_points_out,z_points_out]=rectangular_two_layer_points(N_odd,length_a,length_b,width,spacing,layer_spacing);
else
    
    if mod(layer_count,2)==1 %check if odd
        [x_points_single,y_points_single,z_points_single]=rectangular_single_layer_points(N_per_layer,length_a,length_b,width,spacing);
        [x_points_double,y_points_double,z_points_double]=rectangular_two_layer_points(N_odd,length_a,length_b,width,spacing,layer_spacing);
        
        x_points_even=x_points_double;
        y_points_even=y_points_double;
        z_points_even=z_points_double;
        
        for i=2:even_number_coil_groups;
            x_points_even=[x_points_even x_points_even(end) x_points_double];
            y_points_even=[y_points_even y_points_even(end) y_points_double];
            z_points_even=[z_points_even z_points_even(end) z_points_double-layer_spacing*(2*(i-1))];
        end
        
        x_points_out=[x_points_even x_points_even(end) x_points_single];
        y_points_out=[y_points_even y_points_even(end) y_points_single];
        z_points_out=[z_points_even z_points_even(end) z_points_single-layer_spacing*(2*even_number_coil_groups)];
        
    else %assume even number
        
        [x_points_double,y_points_double,z_points_double]=rectangular_two_layer_points(N_odd,length_a,length_b,width,spacing,layer_spacing);
        
        x_points_even=x_points_double;
        y_points_even=y_points_double;
        z_points_even=z_points_double;
        
        for i=2:even_number_coil_groups;
            x_points_even=[x_points_even x_points_even(end) x_points_double];
            y_points_even=[y_points_even y_points_even(end) y_points_double];
            z_points_even=[z_points_even z_points_even(end) z_points_double-layer_spacing*(2*(i-1))];
        end
        
        x_points_out=x_points_even;
        y_points_out=y_points_even;
        z_points_out=z_points_even;
    end
end

z_points_out=z_points_out+(max(z_points_out)-min(z_points_out))/2;


    function S = round_odd(S)
        % round to nearest odd integer.
        idx = mod(S,2)<1;
        S = floor(S);
        S(idx) = S(idx)+1;
    end

end


