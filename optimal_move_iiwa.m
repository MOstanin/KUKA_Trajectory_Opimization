function [ q_final ] = optimal_move_iiwa( q0, goal_T)
%optimal_move_iiwa calc optima delta q for inv_kin_iiwa
%   Calculated delta q by SNS algorithm with diffrent qN(speed in null
%   space


del_Q=0;
del_Q_min(1)=2*pi*7;
q_final(1:7)=0;
for q3=-0.2:0.05:0.2
    
    qN=[0 0 q3 0 0 0 0];
    
Tq=forward_kin_iiwa(q0);
eps=calc_error(Tq,goal_T);

diff=sum(sqrt(eps.^2));
diff_old=diff;
c=1;
q=q0;
while diff>10^-2
    
    Jac = jac_iiwa(q);

    Jinv = Jac'*inv(Jac*Jac');
     
    qt=inv_kin_iiwa_del_qSNS(q,eps,qN);
    
    q=q+0.01*qt';
    
    % error
    Tq=forward_kin_iiwa(q);
    eps=calc_error(Tq,goal_T);
    diff=sum(sqrt(eps.^2));

    if diff>diff_old
        disp(['limit exceeded',' diff=',num2str(diff)]); 
        disp(q3);
        break; 
    end
    
    diff_old=diff;
    c=c+1;
end
    
    del_Q=sum(sqrt((q0-q).^2));
    
    if del_Q<del_Q_min(1);  del_Q_min(1)=del_Q; del_Q_min(2)=q3; q_final=q; end;
    
    disp(q3);   
    disp(num2str(q));
end


    disp(['optimal:',num2str(del_Q_min(2))]);


end