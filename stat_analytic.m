clc
clear;
close all;

load('data.mat');

% start point

x1=mean(track(:,1,1));
y1=mean(track(:,1,2));
z1=mean(track(:,1,3));

% end point
x2=0; y2=0; z2=0;
num=0;
for i=1:30 
    x2=x2+track(i,track_num_of_points(i),1);
    y2=y2+track(i,track_num_of_points(i),2);
    z2=z2+track(i,track_num_of_points(i),3);
    num=num+track_num_of_points(i);
end

x2=x2/30; y2=y2/30; z2=z2/30;

hold on
for i=1:10
    plot3(track(i,1:track_num_of_points(i),1),track(i,1:track_num_of_points(i),2),track(i,1:track_num_of_points(i),3),'LineWidth',2)
end
% plot3(x1,y1,z1,'o','LineWidth',4)
% plot3(x2,y2,z2,'o','LineWidth',4)


a=x2-x1;
b=y2-y1;
c=z2-z1;

l=sqrt(a^2+b^2+c^2);
del=l/10;

point_map=zeros(num,3);
point_projection=zeros(num,3);
dist=zeros(num,1);
count=1;
for i = 1:30
    n=track_num_of_points(i);
    for j =1:n
        
        point_map(count,:)=track(i,j,:);
        xp=track(i,j,1);
        yp=track(i,j,2);
        zp=track(i,j,3);
        t=-(a*x1 - a*xp + b*y1 - b*yp + c*z1 - c*zp)/(a^2 + b^2 + c^2);
%         t=solve('a*(x1+a*t)+b*(y1+b*t)+c*(z1+c*t)-(a*xp+b*yp+c*zp)==0','t');
        
        point_projection(count,:)=[x1+a*t,y1+b*t,z1+c*t];
        dist(count)= t*sqrt(a^2+b^2+c^2);
        count=count+1;
    end
end

track_opt=zeros(10,3);
track_opt(1,:)=[x1, y1, z1];
count2=2;

for r= 0 : del : (l-del)
    
    x_mean=0;
    y_mean=0;
    z_mean=0;
    count=0;
    for i = 1: num
        
        if dist(i)>r && dist(i)<(r+del)
            
            x_mean=x_mean+point_map(i,1);
            y_mean=y_mean+point_map(i,2);
            z_mean=z_mean+point_map(i,3);
            
            count=count+1;
        end
    end
       
    x_mean=x_mean/count;
    y_mean=y_mean/count;
    z_mean=z_mean/count;
    
    track_opt(count2,:)=[x_mean, y_mean, z_mean];
    
    count2=count2+1;
end
track_opt(count2,:)=[x2, y2, z2];

% plot3(track_opt(:,1),track_opt(:,2),track_opt(:,3),'o','LineWidth',4)











