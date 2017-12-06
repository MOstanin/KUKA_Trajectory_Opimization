f=figure();
hold on
grid on

xlabel('X, mm');
ylabel('Y, mm');
zlabel('Z, mm');
set(gca,'FontSize',14);

load('track_1_2_data.mat')
N=size(path1);

for i=1:N(2)
    
    new_opt_track(i,:)=[table_of_points(path1(i),1), table_of_points(path1(i),2),...
        table_of_points(path1(i),3)];
    
end

a2=plot3(new_opt_track(:,1),new_opt_track(:,2),new_opt_track(:,3),'g','LineWidth',2);


path2 = shortestpath(G2,1,num_of_points);


N=size(path2);

for i=1:N(2)
    
    new_opt_track(i,:)=[table_of_points(path2(i),1), table_of_points(path2(i),2),...
        table_of_points(path2(i),3)];
    
end

a5=plot3(new_opt_track(:,1),new_opt_track(:,2),new_opt_track(:,3),'b','LineWidth',2);

trisurf(kk,P(:,1),P(:,2),P(:,3),'Facecolor','red','FaceAlpha',0.2,'LineStyle','none')

load('track_3_data.mat')
N=size(path1);

for i=1:N(2)
    
    new_opt_track(i,:)=[table_of_points(path1(i),1), table_of_points(path1(i),2),...
        table_of_points(path1(i),3)];
    
end

a3=plot3(new_opt_track(:,1),new_opt_track(:,2),new_opt_track(:,3),'k','LineWidth',2);

load('track_6_data.mat')
N=size(path1);

for i=1:N(2)
    
    new_opt_track(i,:)=[table_of_points(path1(i),1), table_of_points(path1(i),2),...
        table_of_points(path1(i),3)];
    
end

a6=plot3(new_opt_track(:,1),new_opt_track(:,2),new_opt_track(:,3),'c','LineWidth',2);

s=plot3(0,0, 0,'*r','LineWidth',3);
a1=plot3(point(:,1),point(:,2),point(:,3),'y','LineWidth',2);
legend([s a1 a2 a3 a5 a6],'KUKA IIWA base','Mean trajectory','Optimal trajectory','Optimal trajectory del=1/2',...
    'Shortest path in Cartesian', 'Optimal trajectory des =10');