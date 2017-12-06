clear
close all


x0=560;
y0=-150;
z0=240;

l=50;

point(1,:)=[x0 y0-20 z0];
point(2,:)=[x0+0.1 y0 z0+l];
point(3,:)=[x0 y0+l z0+2*l];
point(4,:)=[x0+0.1 y0+2*l z0+l];
point(5,:)=[x0 y0+2*l z0];

% plot3(point(:,1),point(:,2),point(:,3))

deviation=[0 0.03 0.03 0.03 0];


track_opt_ori=[0.14 -2.45 0;
    0.13 -2.43 0;
    0.40 -2.42 0;
    0.15 -2.39 0;
    0.18 -2.37 0;];


save('testCloudFusion.mat','deviation','track_opt_ori','point')

