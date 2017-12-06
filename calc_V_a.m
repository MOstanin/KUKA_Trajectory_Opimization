
% clear; close all;
% 
% load('new_data_track2.mat')

% q_opt_track=q_mean_track;
% q_opt_track=q_short_track;

T1=forward_kin_iiwa(q_opt_track(1,:));
T2=forward_kin_iiwa(q_opt_track(2,:));

del=sqrt(sum((T2(1:3,4)-T1(1:3,4)).^2));

dt=del/200; %200mm/s  

N=size(q_opt_track);

sum_joints=0;
for i=1:(N(1)-1)
    sum_joints=sum_joints+sqrt((q_opt_track(i,:)-q_opt_track(i+1,:)).^2);
end

sum_=sum(sum_joints)
max_joints=max(sum_joints)


% for i=1:N(2)
%     V(i,:)=diff(q_opt_track(:,i))./dt;
%     ac(i,:)=diff(V(i,:))./dt;
%     
%     V_max(i)=max(V(i,:));
%     a_max(i)=max(ac(i,:));
%     
% end
% q=q_opt_track;
% disp([sum_,max_joints,max(V_max),max(a_max)])

% save('q_data_5','q', 'V', 'a')