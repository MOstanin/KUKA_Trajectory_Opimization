clear 
close all

lbr = importrobot('iiwa14.urdf');
lbr.DataFormat = 'row';
% Set the gravity 
lbr.Gravity = [0 0 -9.80];

% wpfilename = fullfile(fileparts(which('LBRTorqueControlExample')), 'data', 'lbr_waypoints.mat');
% load(wpfilename);
% 
% cdt = 0.001;
% tt = 0:cdt:5;

tt=[0 0.15 0.3];
tWaypoints=[0 0.3];
qWaypoints=[1.39 2.10 -1.87 1.77 1.35 -0.16 -1.93;
            1.3 2.09 -1.86 1.78 1.34 -0.15 -1.92];

[qDesired, qdotDesired, qddotDesired, tt] = exampleHelperJointTrajectoryGeneration(tWaypoints, qWaypoints, tt);

n = size(qDesired,1);
tau = zeros(n,7);
for i = 1:n
    tau(i,:) = inverseDynamics(lbr, qDesired(i,:), qdotDesired(i,:), qddotDesired(i,:));
end

Energy=sum(sum(abs(tau(:,:))))

