function [ eps ] = calc_error( T, goal_T )
%calc_error Calculate error of end-effector
%   eps(x,y,z,A,B,C)

eps(1:6)=0;

Tq=T;
goal_point=goal_T(1:3,4);

end_effector_pos=Tq(1:3,4);

eps(1:3)=goal_point-end_effector_pos;

tf = atan2(goal_T(3,2),sqrt(1-goal_T(3,2)^2));
ts = atan2(-goal_T(1,2),goal_T(2,2));
tt = atan2(-goal_T(3,1),goal_T(3,3));
tf_temp = atan2(Tq(3,2),sqrt(1-Tq(3,2)^2));
ts_temp = atan2(-Tq(1,2),Tq(2,2));
tt_temp = atan2(-Tq(3,1),Tq(3,3));

dtf = tf - tf_temp;
dts = ts - ts_temp;
dtt = tt - tt_temp;

Rn = [0 cos(ts) -sin(ts)*cos(tf);
    0 sin(ts)  cos(ts)*cos(tf);
    1 0           sin(tf)];

eps(4:6) = ( Rn * [dts; dtf; dtt])';


end

