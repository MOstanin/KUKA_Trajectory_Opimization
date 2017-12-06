function [ q ] = inv_kin_iiwa_NS( q0, goal_T)
%inv_kin_iiwa_NS Calculate invers kinematic for KUKA iiwa LBR 14
%   Calcurations in mm
   
 
Tq=forward_kin_iiwa2(q0);
eps=calc_error(Tq,goal_T);
diff=sum(sqrt(eps.^2));
diff_old=diff;
c=1;
q=q0;

pos_diff=sum(sqrt(eps(1:3).^2));
ori_diff=sum(sqrt(eps(4:6).^2));
t=0;
while pos_diff>1 || ori_diff>0.1 %diff>10^-1
    
%     Jac = jac_iiwa2(q);
% 
%     Jinv = Jac'*inv(Jac*Jac');
%      
%     a=0.1;
%     qt=Jinv*eps';
%     qt=qt*a;
%     qt=inv(Jac'*Jac+a^2 * eye(7))*Jac'*eps';
%     qt=qn'+Jinv*(eps'-Jac*qn');
%     q=q+a*qt';
    
    dt=0.1;
    qt=inv_kin_iiwa_del_qSNS(q,eps);
    q=q+qt'*dt;
    
%     q=q+[a*qt(1) -a*qt(2) a*qt(3) a*qt(4) a*qt(5) -a*qt(6) a*qt(7)];

    
    % error
    Tq=forward_kin_iiwa2(q);
    
    eps=calc_error(Tq,goal_T);
    
    diff=sum(sqrt(eps.^2));
    
    pos_diff=sum(sqrt(eps(1:3).^2));
    ori_diff=sum(sqrt(eps(4:6).^2));
%     eps
    if diff>diff_old 
        t=t+1;
        if t>10; disp(['min pos error',num2str(pos_diff)]);  break; end 
    end
    
    diff_old=diff;
    c=c+1;
end

end

