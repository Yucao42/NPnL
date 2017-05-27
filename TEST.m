% Author : Yu Cao, Beihang University 5/23/2017
% Compose random lines to do experiments on accuracy. 
%% Parameter tuning for random lines.
    NLINES = 10;                                                           % Number of lines
    theta = rand(3, 1) * pi / 180;                                         % Roll Pitch & Yaw
    R=angle2dcm(theta(1), theta(2), theta(3));                             % Rotation Matrix
    %  t = [  -1.8904 ;-11.3585 ; -14.7920];
    t =10 * [rand rand rand]';                                             % Translation vector
    sig = 0;                                                               % Gaussian error siga

%% Compute errors of translation and rotation in our method and Bronislav method respectively.
    [er1, et1, er2, et2] = Comparative_exp( NLINES, R, t, sig );
    
%% Print out the errors.
    fprintf('Error of rotation in rad of our method is %d.\n' ,er1);
    fprintf('Error of transformation in meter of our method is %d.\n' ,et1);
    fprintf('Error of rotation in rad of Bronislav method is %d.\n' ,er2);
    fprintf('Error of transformation in meter of Bronislav method is %d.\n' ,et2);
