%kinect initialization
addpath('Mex');
clear all
close all
clc

k2 = Kin2('color','depth','body');

traect=zeros(3,25);

% start point

x1=285; y1=-250; z1=1560;

% end point
x2=-375; y2=-215; z2=1530;

sens_lim=60;

track_num=1;
tracking_flag=0;

track7=zeros(3,40,10);
track6=zeros(3,40,10);
track_n=[0 0 0];
c=1;
tic
while track_num<11
    
    
    validData = k2.updateData;
    
    if (toc>2)
    if validData
        [bodies, fcp, timeStamp] = k2.getBodies('Quat');   
        
        % Number of bodies detected
        numBodies = size(bodies,2);
       
       if numBodies > 0
           traect(:,:)=bodies(1).Position(:,:);
           
           x7=traect(1,7)*1000;
           y7=traect(2,7)*1000;
           z7=traect(3,7)*1000;
           
           x6=traect(1,6)*1000;
           y6=traect(2,6)*1000;
           z6=traect(3,6)*1000;
           
           if tracking_flag==1
               track7(:,c,track_num)=[x7 y7 z7];
               track6(:,c,track_num)=[x6 y6 z6];
               c=c+1;
           end
                 
           if (x7-x1)^2+(y7-y1)^2+(z7-z1)^2<sens_lim^2 && tracking_flag==0
               tracking_flag=1;
               c=1;
               track7(:,c,track_num)=[x7 y7 z7];
               track6(:,c,track_num)=[x6 y6 z6];
               c=c+1;
               disp(track_num)
           end
           
           if (x7-x2)^2+(y7-y2)^2+(z7-z2)^2<sens_lim^2 && tracking_flag==1
               tracking_flag=0;
               track_n(track_num)=c-1;
               track_num=track_num+1;
               userInput = input('end', 's');
           end
       end
    end
    end
end
k2.delete;

% statics analysis of kinect data
a=x2-x1;
b=y2-y1;
c=z2-z1;

l=sqrt(a^2+b^2+c^2);
del=l/10;

hold on
num=0;
for i=1:10
    
    track7(1,:,i)=smooth(track7(1,:,i),'sgolay');
    track7(2,:,i)=smooth(track7(2,:,i),'sgolay');
    track7(3,:,i)=smooth(track7(3,:,i),'sgolay');
    
    track6(1,:,i)=smooth(track6(1,:,i),'sgolay');
    track6(2,:,i)=smooth(track6(2,:,i),'sgolay');
    track6(3,:,i)=smooth(track6(3,:,i),'sgolay');
    num=num+track_n(i);
    plot3(track7(1,:,i),track7(2,:,i),track7(3,:,i))
end

point_map7=zeros(num,3);
point_map6=zeros(num,3);
point_projection=zeros(num,3);
dist=zeros(num,1);
count=1;
for i = 1:10
    n=track_n(i)-1;
    for j =1:n
        
        point_map7(count,:)=track7(:,j,i);
        point_map6(count,:)=track6(:,j,i);
        xp=track7(1,j,i);
        yp=track7(2,j,i);
        zp=track7(3,j,i);
        t=-(a*x1 - a*xp + b*y1 - b*yp + c*z1 - c*zp)/(a^2 + b^2 + c^2);

        point_projection(count,:)=[x1+a*t,y1+b*t,z1+c*t];
        dist(count)= t*sqrt(a^2+b^2+c^2);
        count=count+1;
    end
end

track_opt=zeros(12,3);
track_opt6=zeros(12,3);
count2=2;


track_opt(1,:)=[x1 y1 z1];


for r= 0 : del : (l-del)
    
    x_mean=0;
    y_mean=0;
    z_mean=0;
    
    x_mean6=0;
    y_mean6=0;
    z_mean6=0;
    count=0;
    for i = 1: num
        
        if dist(i)>r && dist(i)<(r+del)
            
            x_mean=x_mean+point_map7(i,1);
            y_mean=y_mean+point_map7(i,2);
            z_mean=z_mean+point_map7(i,3);
            
            x_mean6=x_mean6+point_map6(i,1);
            y_mean6=y_mean6+point_map6(i,2);
            z_mean6=z_mean6+point_map6(i,3);
            
            count=count+1;
        end
    end
       
    x_mean=x_mean/count;
    y_mean=y_mean/count;
    z_mean=z_mean/count;
    
    x_mean6=x_mean6/count;
    y_mean6=y_mean6/count;
    z_mean6=z_mean6/count;
    
    track_opt(count2,:)=[x_mean, y_mean, z_mean];
    track_opt6(count2,:)=[x_mean6, y_mean6, z_mean6];
    
    count2=count2+1;
end
count2=12;
track_opt(12,:)=[x2 y2 z2];
track_opt6(1,:)=track_opt6(2,:);
track_opt6(12,:)=track_opt6(11,:);

plot3(track_opt(:,1),track_opt(:,2),track_opt(:,3),'o')



%initialization of client
import java.io.*;
import java.net.*;

%# connect to server
try
    socket = Socket('172.31.1.147',30001);
    sin = socket.getInputStream();
    sout = socket.getOutputStream();
    in = DataInputStream(sin);
    out = DataOutputStream(sout);
    
catch ME
    error(ME.identifier, 'Connection Error: %s', ME.message)
end

load('calib_points.mat');
global Points
for asd=1:3
for i=1:count2
    
    trans_lvl_x=round((Points(3,1)+Points(3,2))/2+(550+575)/2);     
    trans_lvl_y=round((Points(1,3)+Points(1,4))/2+10);
    trans_lvl_z=round(120-min(Points(2,:)));
 
    
%     coordinate of end
    kuka_x=trans_lvl_x-track_opt(i,3);
    kuka_y=trans_lvl_y-track_opt(i,1);
    kuka_z=trans_lvl_z+track_opt(i,2);
    
%     coordinate of start
    kuka_x2=trans_lvl_x-track_opt6(i,3);
    kuka_y2=trans_lvl_y-track_opt6(i,1);
    kuka_z2=trans_lvl_z+track_opt6(i,2);


    if (kuka_z<120) 
        kuka_z=120;
    end     
    angles = find_angles(kuka_x2, kuka_y2, kuka_z2, kuka_x, kuka_y, kuka_z);
    
     S=['lin ',num2str(kuka_x),' ',num2str(kuka_y),' ',num2str(kuka_z),' '...
         ,num2str(angles(1)),' ',num2str(angles(2)),' ',num2str(angles(3))];
     out.writeUTF(S);
     pause(0.02)
end

for j=1:count2
    
    i=13-j;
    trans_lvl_x=round((Points(3,1)+Points(3,2))/2+(550+575)/2);     
    trans_lvl_y=round((Points(1,3)+Points(1,4))/2+10);
    trans_lvl_z=round(120-min(Points(2,:)));
 
    
%     coordinate of end
    kuka_x=trans_lvl_x-track_opt(i,3);
    kuka_y=trans_lvl_y-track_opt(i,1);
    kuka_z=trans_lvl_z+track_opt(i,2);
    
%     coordinate of start
    kuka_x2=trans_lvl_x-track_opt6(i,3);
    kuka_y2=trans_lvl_y-track_opt6(i,1);
    kuka_z2=trans_lvl_z+track_opt6(i,2);


    if (kuka_z<120) 
        kuka_z=120;
    end     
    angles = find_angles(kuka_x2, kuka_y2, kuka_z2, kuka_x, kuka_y, kuka_z);
    
     S=['lin ',num2str(kuka_x),' ',num2str(kuka_y),' ',num2str(kuka_z),' '...
         ,num2str(angles(1)),' ',num2str(angles(2)),' ',num2str(angles(3))];
     out.writeUTF(S);
     pause(0.02)
end
pause(1)
end

userInput = input('end', 's');



%# cleanup
out.close();
in.close();
socket.close();


