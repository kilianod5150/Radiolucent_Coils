clc
clear 
close all

 ideal_x=repmat(31.75*[-3 -2 -1 0 1 2 3],[1 7]);
 ideal_y=[-3*31.75*ones(1,7) -2*31.75*ones(1,7) -31.75*ones(1,7) 0*31.75*ones(1,7) 1*31.75*ones(1,7) 2*31.75*ones(1,7) 3*31.75*ones(1,7) ];
 ideal_z=0*ideal_x;
%  ideal_x=repmat(31.75*[-2 -1 0 1 2 3],[1 6]);
%  ideal_y=[2*31.75*ones(1,6) 1*31.75*ones(1,6) 0*31.75*ones(1,6) -1*31.75*ones(1,6) -2*31.75*ones(1,6) -3*31.75*ones(1,6)];
%  ideal_z=0*ideal_x;
%  figure
%  scatter3(ideal_x,ideal_y,ideal_z,'g')

 data_ideal=[ideal_x' ideal_y' ideal_z'];

 
 
 Folder_Cell{1,1}='\alu_coils.fcsv'; 
 Folder_Cell{2,1}='\standard_coils.fcsv'; 
 


scaling_factor=1;
icp_max_iterations=250;
monte_carlo_iterations=1;

% 
[num_sets blah]=size(Folder_Cell);

figure

for i=1:num_sets;
    subplot(1,2,i)
    clear r_error data_mag data_mag_carm
   [data_mag] = read_CSV_or_FCSV(strcat(cd,Folder_Cell{i,1}));

   [data_out,minimum_error(i),best_transform{i}] = global_icp(data_mag,data_ideal,icp_max_iterations,monte_carlo_iterations,scaling_factor);
   minimum_error(i)
    
    hold on
    scatter3(data_out(:,1),data_out(:,2),data_out(:,3))
     scatter3(data_ideal(:,1),data_ideal(:,2),data_ideal(:,3))
    legend('Magnetic measurement','True Position')
    xlabel('x [mm]')
    ylabel('y [mm]')
    axis square
    grid on
    
    data_error{i}=data_out-data_ideal;
    
    mean_store(i)=mean(vecnorm(data_error{i}'));
    std_store(i)=mean(vecnorm(data_error{i}'));

end


