% clc
clear;
close all;

load('new_data.mat');

% start point from previos step
x1=0.26; y1=-0.205; z1=1.63;

% end point
x2=-0.25;
y2=-0.21;
z2=1.54;


hold on
grid on
% title('');
xlabel('X, m');
ylabel('Y, m');
zlabel('Z, m');

% for i=1:N(1)
%     
%     plot3(track(i,1:track_num_of_points(i),1),track(i,1:track_num_of_points(i),2),track(i,1:track_num_of_points(i),3),'LineWidth',2)
% % end
% plot3(x1,y1,z1,'o','LineWidth',3)
% plot3(x2,y2,z2,'o','LineWidth',3)

% N=size(track);
N=[4,69,3];

num_of_segments=max([10 round(min(track_num_of_points(1:N(1))))]);
track_norm=zeros(N(1),num_of_segments,3);
track_norm_ori=zeros(N(1),num_of_segments,3);

for i=1:N(1)
%     L=sqrt((x1-track(i,1,1))^2+(y1-track(i,1,2))^2+(z1-track(i,1,3))^2);
    L=0;
    for j=1:track_num_of_points(i)-1
        L=L+sqrt((track(i,j,1)-track(i,j+1,1))^2+...
            (track(i,j,1)-track(i,j+1,2))^2+...
            (track(i,j,1)-track(i,j+1,3))^2);
    end
    L=L+sqrt((x2-track(i,track_num_of_points(i),1))^2+...
        (y2-track(i,track_num_of_points(i),2))^2+...
        (z2-track(i,track_num_of_points(i),3))^2);
    
    del=L/num_of_segments;
    old_j=1;
%     L2=sqrt((x1-track(i,1,1))^2+(y1-track(i,1,2))^2+(z1-track(i,1,3))^2);
    L2=0;
    for k=1:num_of_segments
        bondary_L=k*del;
        j=old_j;
        while L2<bondary_L-1
            L2=L2+sqrt((track(i,j,1)-track(i,j+1,1))^2+...
            (track(i,j,1)-track(i,j+1,2))^2+...
            (track(i,j,1)-track(i,j+1,3))^2); 
            j=j+1;
        end
        track_norm(i,k,1)=mean(track(i,old_j:j,1));
        track_norm(i,k,2)=mean(track(i,old_j:j,2));
        track_norm(i,k,3)=mean(track(i,old_j:j,3));
        
        track_norm_ori(i,k,1)=mean(track_orientation(i,old_j:j,1));
        track_norm_ori(i,k,2)=mean(track_orientation(i,old_j:j,2));
        track_norm_ori(i,k,3)=mean(track_orientation(i,old_j:j,3));
        
        
        old_j=j;
    end
end

for i=1:N(1)
    a=plot3(track_norm(i,:,3),...
        track_norm(i,:,1),...
        track_norm(i,:,2),'b','LineWidth',1);
end
       
% 
% track_opt(1,:)=[x1, y1, z1];
% deviation(1)=0;
for i=1:num_of_segments
     x=mean(track_norm(:,i,1));
     y=mean(track_norm(:,i,2));
     z=mean(track_norm(:,i,3));
     track_opt(i,:)=[x, y, z];
     sum_of_d=0;
     for j=1:N(1)
         sum_of_d=sum_of_d+((x-track_norm(j,i,1))^2+(y-track_norm(j,i,2))^2+(z-track_norm(j,i,3))^2);
     end
     deviation(i)=sqrt(sum_of_d/N(1));
     
     A=mean(track_norm_ori(:,i,1));
     B=mean(track_norm_ori(:,i,2));
     C=mean(track_norm_ori(:,i,3));
     track_opt_ori(i,:)=[A, B, C];
     
end
% track_opt(num_of_segments+2,:)=[x2, y2, z2];
% deviation(num_of_segments+2)=0;
% 
% track_opt_ori(1,:)=track_opt_ori(2,:);
% track_opt_ori(num_of_segments+2,:)=track_opt_ori(num_of_segments+1,:);

p=plot3(track_opt(:,3),track_opt(:,1),track_opt(:,2),'-ok','LineWidth',2);

% k=plot3(0,0,0,'*','LineWidth',2);

legend([a p],'Paths','Average trajectory')
set(gca,'FontSize',12);

f=figure();
hold on
xlabel('X, m');
ylabel('Y, m');
zlabel('Z, m');
set(gca,'FontSize',12);
for i=1:N(1)
    
    plot3(track_norm(i,:,3),track_norm(i,:,1),track_norm(i,:,2))
    
end
legend('Path 1', 'Path 2', 'Path 3', 'Path 4')
hold off
