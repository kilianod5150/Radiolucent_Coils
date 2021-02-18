function Mp = spiralCoilFieldCalcFilaments(A,B,a,b)

%%%%% "AB" vectors (emitter filaments)
% x_points: horizontal vector of end points (x-component) of the filaments
% generating the field
% y_points and z_points: the same
% 
%%%%% "ab" vector (receiver filaments)
% Wx: 2 end points (horizontal) of the filament where the field is induced
% Wy and Wz: the y and z coordinates
% 
% 
% 
% 
% NOTE: receiver filament is only 1. In the future seek if it's possible to
% optimize having multiple receivers and using matrix for results

% A = A*1e6;
% B = B*1e6;
% a = a*1e6;
% b = b*1e6;


% Function Euclidean distance 2 points
Dist = @(p1,p2) sqrt( sum((p1-p2).^2) ); % rows of p1 and p2 are x, y, z

num_AB = size(A,2);
Ax = A(1,:);
Ay = A(2,:);
Az = A(3,:);
% Bx = B(1,:);
% By = B(2,:);
% Bz = B(3,:);
D = B-A;
Dx = D(1,:);
Dy = D(2,:);
Dz = D(3,:);
ll = vecnorm(D); % length of emitter filaments


num_ab = size(a,2);
Mp = zeros(1,num_AB);
for ww = 1:num_ab%[1:51 53:num_ab]    
a_ww = a(:,ww);
b_ww = b(:,ww);

ax = a_ww(1,:);
ay = a_ww(2,:);
az = a_ww(3,:);

d = b_ww-a_ww;
% dx = d(1,:);
% dy = d(2,:);
% dz = d(3,:);
mm = vecnorm(d); % length of receiver filament


%% calculus of new coordinates XYZ
dd = repmat(d,1,size(D,2));
u_Z = cross(D,dd);
u_Z = u_Z./vecnorm(u_Z);
u_X = dd/mm;
u_Y = cross(u_Z,u_X);

% from xyz to XYZ
AX = u_X(1,1).*Ax + u_X(2,1).*Ay + u_X(3,1).*Az;
AY = u_Y(1,:).*Ax + u_Y(2,:).*Ay + u_Y(3,:).*Az;
AZ = u_Z(1,:).*Ax + u_Z(2,:).*Ay + u_Z(3,:).*Az;

DX = u_X(1,1).*Dx + u_X(2,1).*Dy + u_X(3,1).*Dz;
DY = u_Y(1,:).*Dx + u_Y(2,:).*Dy + u_Y(3,:).*Dz;

aX = u_X(1,1)*ax + u_X(2,1)*ay + u_X(3,1)*az;
aY = u_Y(1,:)*ax + u_Y(2,:)*ay + u_Y(3,:)*az;
aZ = u_Z(1,:)*ax + u_Z(2,:)*ay + u_Z(3,:)*az;

ss = abs(AZ-aZ);

cosTheta = DX./ll;
sinTheta = DY./ll;

P = zeros(2,num_AB);
P(1,:) = DX./DY.*(aY-AY) + AX ;
P(2,:) = aY;

R1 = Dist(B,b_ww);
R2 = Dist(B,a_ww);
R3 = Dist(A,a_ww);
R4 = Dist(A,b_ww);

alpha_vec = [AX; AY]-P;
alpha = (alpha_vec(1,:).*DX+alpha_vec(2,:).*DY)./ll;
beta = aX - P(1,:);

%% Solid Angle
Omega =  atan( (ss.^2.*cosTheta + (beta+mm).*(alpha+ll).*sinTheta.^2)./(ss.*R1.*sinTheta) ) + ...
       - atan( (ss.^2.*cosTheta +  beta.*    (alpha+ll).*sinTheta.^2)./(ss.*R2.*sinTheta) ) + ...
       + atan( (ss.^2.*cosTheta +  beta.*     alpha    .*sinTheta.^2)./(ss.*R3.*sinTheta) ) + ...
       - atan( (ss.^2.*cosTheta + (beta+mm).* alpha    .*sinTheta.^2)./(ss.*R4.*sinTheta) );

%% Mutual inductance
% u0/2/pi is missing! just multiply for 0.2 externally and obtain mutual in uH
Mp_ww = cosTheta.*( (alpha+ll).*atanh(mm./(R1+R2)) + ...
                            -(alpha).*atanh(mm./(R3+R4)) +...
                            +(beta+mm).*atanh(ll./(R1+R4)) + ...
                            -(beta).*atanh(ll./(R2+R3)) - .5*(Omega.*ss)./sinTheta );
                        
if find(isnan(Mp_ww) == 1)    
    fprintf("NaN values, probably there are parallel filaments")
end
    
Mp = Mp + Mp_ww;


end
Mp = reshape(Mp, [], 1);
Mp = - sum(Mp,1);

end