
tic
gen_points3;

lbr = importrobot('iiwa14.urdf');
lbr.DataFormat = 'row';
% Set the gravity 
lbr.Gravity = [0 0 -9.80];

M=makehgtform('translate',point(1,:));
Rz=makehgtform('zrotate',ori_in_cloud(1,1));
Ry=makehgtform('yrotate',ori_in_cloud(1,2));
T=M*Ry*Rz;

q0=[0 -pi/4 0 -pi/2 0 0 0];

q0=inv_kin_iiwa_NS(q0,T);

T=forward_kin_iiwa(q0);

q_mean_track(1,:)=q0;
for i=2:pn
    M=makehgtform('translate',point(i,:));
    Rz=makehgtform('zrotate',ori_in_cloud(i,1));
    Ry=makehgtform('yrotate',ori_in_cloud(i,2));
    T=M*Ry*Rz;
    
    q_mean_track(i,:)=inv_kin_iiwa_NS(q_mean_track(i-1,:),T);
end


G1 = digraph;
G2 = digraph;
GE = digraph;

num_of_points=sum(num_p_in_cloud)
table_of_points=zeros(num_of_points,3);
cloud_size=size(cloud);
cloud_n=cloud_size(1);


table_of_points(1,:)=point(1,:);
for i=1:cloud_n-2
    c1=sum(num_p_in_cloud(1:i))+1;
    c2=c1+num_p_in_cloud(i+1)-1;
    table_of_points(c1:c2,:)=cloud(i+1,1:num_p_in_cloud(i+1),:);
end
table_of_points(num_of_points,:)=point(pn,:);
table_of_q=zeros(num_of_points,7);
table_of_q(1,:)=q0;

N=size(num_p_in_cloud);

W=eye(7);
% create graph
for i=1:(N(2)-1)
    
    n1=num_p_in_cloud(i);
    n2=num_p_in_cloud(i+1);
    %     start number of 1 cloud
    c1=sum(num_p_in_cloud(1:(i-1)))+1;
    %     start number of 2 cloud
    c2=c1+num_p_in_cloud(i);
    
    Rz=makehgtform('zrotate',ori_in_cloud(i,1));
    Ry=makehgtform('yrotate',ori_in_cloud(i,2));
    T=Ry*Rz;
    
    for j=c1:(c1+n1-1)
        vec_from(1:n2)=j;
        vec_to(1:n2)=c2:(c2+n2-1);
        vec_w1(1:n2)=pi*7;
        vec_w2(1:n2)=pi*7;
        vec_wE(1:n2)=1000;
        for k=1:n2
            T(1:3,4)=table_of_points(c2+k-1,:);
            table_of_q(c2+k-1,:)=inv_kin_iiwa_NS(table_of_q(j,:),T);
            del_q=table_of_q(c2+k-1,:)-table_of_q(j,:);
            vec_w1(k)=sqrt(sum((W*del_q').^2));
            vec_w2(k)=sqrt((table_of_points(c2+k-1,1)-table_of_points(j,1))^2+...
                (table_of_points(c2+k-1,2)-table_of_points(j,2))^2+...
                (table_of_points(c2+k-1,3)-table_of_points(j,3))^2);
            vec_wE(k)=calc_energy(lbr, [table_of_q(j,:); table_of_q(c2+k-1,:)], dt);
        end
        
        G1=addedge(G1,vec_from,vec_to,vec_w1);
        G2=addedge(G2,vec_from,vec_to,vec_w2);
        GE=addedge(GE,vec_from,vec_to,vec_wE);
        
        clear vec_from vec_to vec_w1 vec_w2 vec_wE
    end
    
end

% find path
path1 = shortestpath(G1,1,num_of_points);

toc
N=size(path1);

for i=1:N(2)
    
    new_opt_track(i,:)=[table_of_points(path1(i),1), table_of_points(path1(i),2),...
        table_of_points(path1(i),3)];
    q_opt_track(i,:)=table_of_q(path1(i),:);
    
end
new_opt_track(:,1)=smooth(new_opt_track(:,1));
new_opt_track(:,2)=smooth(new_opt_track(:,2));
new_opt_track(:,3)=smooth(new_opt_track(:,3));
a2=plot3(new_opt_track(:,1),new_opt_track(:,2),new_opt_track(:,3),'r','LineWidth',2);


path2 = shortestpath(G2,1,num_of_points);
N=size(path2);

for i=1:N(2)
    
    new_short_track(i,:)=[table_of_points(path2(i),1), table_of_points(path2(i),2),...
        table_of_points(path2(i),3)];
    
    q_short_track(i,:)=table_of_q(path2(i),:);
    
end

a3=plot3(new_short_track(:,1),new_short_track(:,2),new_short_track(:,3),'b','LineWidth',2);

% legend([p a2 a3],'Optimal Trajectory','Intial Trajectory','Shortest Trajectory')
% plot3(0,0, 0,'*r','LineWidth',3)
% calc_V_a