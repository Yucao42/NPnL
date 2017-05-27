function [ E_theta, E_t, P_theta, P_t ] = Comparative_exp( NLINES, R, t, sig )
%COMPARATIVE_EXP 
% Author : Yu Cao, Beihang University 5/23/2017
% We make comparative experiments to compare the error by our proposed
% method (prefixed E) with the BMVC 2015 method (prefixed P).
% Several random lines are generated to calculate the pose from different
% method.

%         INPUT
%  NLINES -- Number of lines.
%    R    -- Groundtruth rotation matrix.
%    t    -- Groundtruth translation matrix.
%   sig   -- Image noise in 0-mean gaussian distribution of variance sig.
%         OUTPUT
% E_theta -- our mehtod's rotation error in degree.
%   E_t   -- our mehtod's translation error in meter.
% P_theta -- Pribyl's mehtod's rotation error in degree.
%   P_t   -- Pribyl's mehtod's translation error in meter.
%

%% First we generate random 2N 3D points to compose N lines
    i = 0;
    End_points_3D = zeros(4,2*NLINES);
    len = 2 * NLINES;
while(i < len)
    i = i + 1;
    point = 10*[rand rand rand 0.1]';
    End_points_3D(:,i) = point;
end

%% 3D lines in plucker coordinates
    Lines=pluckerLines_eric(End_points_3D);

%% 3D transform to end points in camera coordinates    
    T = [R skew3(t) * R];
    T_motion = [R t];
    End_points_2D = T_motion * End_points_3D;
  
%% Pose estimation Czech
    [R_estim, t_estim] = linePoseEstim( End_points_3D, End_points_2D,true );
    t_estim = - R_estim * t_estim;

%% Pose estimation in our method
    lines_ = T * Lines;
    lines = lines_ + normrnd(0, sig, size(lines_,1),size(lines_,2));
    R1=eye(3);  %% initial guess from whatever
    t1=[0;0;0 ];   
    [R_, T_]= LBA_se3(lines, Lines,R1,t1 );
    
%% Display the pose parameters.
    disp('Real pose [R|t]');
    disp([R t]);

    disp('Estimated pose [R|t]');
    disp([R_estim t_estim]);

    disp('Optimized pose [R|t]');
    disp([R_  T_]);

%% Calculate the error terms.
    E_theta = getAngle_error(R_, R);
    E_t = getTrans_error(t,T_);
    P_theta = getAngle_error(R_estim, R);
    P_t = getTrans_error(t,t_estim);
end

