function [x_points_out,y_points_out,z_points_out]=two_layer_points_with_angles(N,length,width,spacing,thickness,angle);

%New improved function that now allows the angles of the coil to be added
%and zeros the center point

%N is odd

z_thick=thickness; %pcb board thickness

theta_rot=angle; %default value is pi/2
%Define dimensions
l=length; %define side length of outer square
w=width; %define width of each track
s=spacing; %define spaceing between tracks

ll_s=w+s; %line to line spacing


%Start point is bottom left corner of spiral, define this as the origin
%(0,0)

N_desired=N; %define the required number of turns, %keep as an odd number

%Note: each turn requires 5 points, the next square starts at the last
%point of the previous
%Total number of points equals 4*N_desired+1
Points_total=4*N_desired+1;


x_points=zeros(1,Points_total);
y_points=zeros(1,Points_total);
z_points=zeros(1,Points_total);

z_points((2*N_desired+2):Points_total)=-z_thick;

%now define an array that contains the length of each segment, this follows
%a pattern after the first two, there are N_desired*4 line segments

line_segs=zeros(1,4*N_desired);
line_segs(1:3)=l;

i=1; %increment the decrease in length
for seg_move=4:2:(2*N_desired);
    line_segs(seg_move:(seg_move+1))=(l-i*ll_s);
    i=1+i;
end

i_smaller=i-1;

for seg_move=2*N_desired:2:(4*N_desired)-1;
    line_segs(seg_move:(seg_move+1))=(l-i_smaller*ll_s);
    i=1+i;
    i_smaller=i_smaller-1;
end

line_segs((4*N_desired-2):(4*N_desired-1))=l;
line_segs(4*N_desired)=l-ll_s;
%now make an array of trajectories that shows the direction to travel from
%one point to another this repeats for every square
%varies r(x,y)=cos(theta)x_hat+sin(theta)y_hat, moving through
%"up,left,down,right" or 90 180 270 0

%x_traj=[0 -1 0 1];
%y_traj=[1 0 -1 0];

x_traj=cos([theta_rot theta_rot+.5*pi theta_rot+pi theta_rot+1.5*pi]);
y_traj=sin([theta_rot theta_rot+.5*pi theta_rot+pi theta_rot+1.5*pi]);

q=1;
for p=2:Points_total; %proceed through each point
    
    
    x_points(p)=x_traj(q)*line_segs(p-1)+x_points(p-1);
    y_points(p)=y_traj(q)*line_segs(p-1)+y_points(p-1);
    q=q+1;
    if q==5;
        q=1;
    end
    
    
end




% %now add actual z offset


x_points_new(1:2*N_desired+1)=x_points(1:2*N_desired+1);
x_points_new(2*N_desired+2)=x_points(2*N_desired+1);
x_points_new(2*N_desired+3:Points_total+1)=x_points(2*N_desired+2:Points_total);

y_points_new(1:2*N_desired+1)=y_points(1:2*N_desired+1);
y_points_new(2*N_desired+2)=y_points(2*N_desired+1);
y_points_new(2*N_desired+3:Points_total+1)=y_points(2*N_desired+2:Points_total);

z_points_new(1:2*N_desired+2)=z_points(1:2*N_desired+2);
z_points_new(2*N_desired+3)=z_points(2*N_desired+2);
z_points_new(2*N_desired+4:Points_total+1)=z_points(2*N_desired+3:Points_total);


x_points_out=x_points_new;
y_points_out=y_points_new;
z_points_out=z_points_new;

%Now offset back to centre

if angle==pi/2;
    x_points_out=x_points_out+length/2;
    y_points_out=y_points_out-length/2;
    
else
    
    y_points_out=y_points_out-length/(sqrt(2));
end
  %  plot3(x_points(1:(2)),y_points(1:(2)),z_points(1:(2)));


