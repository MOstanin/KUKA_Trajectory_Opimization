path3 = shortestpath(GE,1,num_of_points);
N=size(path3);

for i=1:N(2)
    
    new_short_track2(i,:)=[table_of_points(path3(i),1), table_of_points(path3(i),2),...
        table_of_points(path3(i),3)];
    
    q_short_track2(i,:)=table_of_q(path3(i),:);
    
end

a3=plot3(new_short_track2(:,1),new_short_track2(:,2),new_short_track2(:,3),'k','LineWidth',2);