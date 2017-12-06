% clear
% close all;
% 
% sigma=20;
% k=500;
% kn=100;
% dt=0.1;  %0.1~sigma=20 
% 
% create_points_graph;
% save('data_1.mat')

clear
close all;

sigma=20;
k=250;
kn=50;
dt=0.1;  %0.1~sigma=20 

create_points_graph;
save('data_2.mat')

clear
close all;

sigma=20;
k=125;
kn=50;
dt=0.1;  %0.1~sigma=20 

create_points_graph;
save('data_3.mat')

clear
close all;

sigma=10;
k=500;
kn=50;
dt=0.2;  %0.1~sigma=20 

create_points_graph;
save('data_4.mat')

clear
close all;

sigma=10;
k=250;
kn=50;
dt=0.2;  %0.1~sigma=20 

create_points_graph;
save('data_5.mat')