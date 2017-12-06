
clear all;
close all;


% задаём начальные условия
    goal_q= [0 0 -pi/2 -pi/2 0 0 pi/10];
    goal_T=forward_kin_iiwa(goal_q);
    goal_T(1:3,4)=[500 0 500]';
    

q=[0 0 0 -0.7853981 0 0 0];

q=inv_kin_iiwa_NS(q,goal_T);
        
        