% clear
% close all
hold on
% load('track_opt_with_d_and_ori2.mat');
% % load('track_opt_example.mat');
% 
% N=size(track_opt);
% 
% % --- zero
% trans_lvl_x=round((track_opt(1,3)+track_opt(N(1),3))*1000/2+550);
% trans_lvl_y=0;
% trans_lvl_z=round(100-(track_opt(1,2)+track_opt(N(1),2))*1000/2);
% 
% 
% for i=1:N(1)
%     point(i,:)=[trans_lvl_x-track_opt(i,3)*1000, trans_lvl_y-track_opt(i,1)*1000,...
%         trans_lvl_z+track_opt(i,2)*1000];
% end


load('testCloudFusion.mat'); N=size(point);

for i=1:N(1)
    ori(i,:)=[track_opt_ori(i,1), -track_opt_ori(i,2), track_opt_ori(i,3)];
end


sigma=10;
k=500;
kn=100;
dt=0.1;  %0.1~sigma=20 

num_p_in_cloud(1)=1;
pn=N(1);
cloud(1,1,1:3)=point(1,:);
ori_in_cloud(1,:)=ori(1,:);
c_cloud=2;

for p=1:pn-1
    lenth=sqrt(sum((point(p,:)-point(p+1,:)).^2));
    n_del=round(lenth/(sigma));
    %     n_del=10;
    del=lenth/n_del;
    %    Ax+By+Cz+D=0 plane equation
    vect=point(p+1,:)-point(p,:);
    vect_ori=ori(p+1,:)-ori(p,:);
    del_ori=sqrt(sum(vect_ori.^2))/n_del;
    
    % cloud fusion
    if p<=pn-2
    %     next section
    next_vect=point(p+2,:)-point(p+1,:);
    next_d=-sum(next_vect*point(p+1,:)');
    end
    if p>=2
    %     previos section
    prev_vect=point(p,:)-point(p-1,:);
    prev_d=-sum(prev_vect*point(p,:)');
    end
    %------
    
    if p==1; start_n=1; else; start_n=0; end
    if p==pn-1; finish_n=n_del-1; else; finish_n=n_del; end
    for t=start_n:finish_n
        if vect_ori==0
            orientation=ori(p,:);
        else
            orientation=ori(p,:)+vect_ori*(del_ori*t/sqrt(sum(vect_ori.^2)));
        end
        pon=point(p,:)+vect*(del*t/lenth);
        d=-sum(vect*pon');
        angl=find_angles(point(p,1),point(p,2),point(p,3),point(p+1,1),point(p+1,2),point(p+1,3));
        M=makehgtform('translate',pon);
        Rz=makehgtform('zrotate',angl(1));
        Ry=makehgtform('yrotate',angl(2));
        T=M*Rz*Ry;
        %        forward
        %        ponABC=inv(T)*[-500 -350 650 1]';
        %        invers
        %        p2=T*[0 5 0 1]';
        
        c=1;
        p2=T*[0, 0, 0, 1]';
        cloud(c_cloud,c,:)=p2(1:3,1);
        c=c+1;
        if p==1
            dev=deviation(2);
        else
            dev=deviation(p);
        end
        num=round(dev,2)*kn;
          
%         for i=36:36:360
%             start=1;
%             if num > 3; start=2;  end
%             if num > 6; start=3; end
%             if num > 9; start=4; end    
%             for j=start:num
% %                distant from center to point
% %                l=exp(j*(log(deviation(p)*200)/num));
% %                 if p==1
% %                     l=exp(j*(log(deviation(2)*200)/num));
% %                 end
%                 
%                 if mod(i/36,2)==0
%                     l=exp(j*(log(deviation(p)*k/1.4)/num));
%                 else
%                     l=exp(j*(log(deviation(p)*k)/num));
%                 end
%                 if p==1
%                     if mod(i/36,2)==0
%                         l=exp(j*(log(deviation(2)*k/1.4)/num));
%                     else
%                         l=exp(j*(log(deviation(2)*k)/num));
%                     end
%                 end
%                 x=cos(i*pi/180)*l;
%                 y=sin(i*pi/180)*l;
%                 p2=T*[x, y, 0, 1]';
%                 cloud(c_cloud,c,:)=p2(1:3,1);
%                 c=c+1;
%                 if (p2(1:3,1)'*vect'+d)>1
%                     disp('point not in plane');
%                 end
%             end
%         end
        
        del2=dev*k/num;
        for i=-num:num
           for j=-num:num
               if ~(i==0 && j==0)
                   x=del2*i;
                   y=del2*j;
                   if x^2+y^2<=(dev*k)^2
                       p2=T*[x, y, 0, 1]';
                       cloud(c_cloud,c,:)=p2(1:3,1);
                       c=c+1;
                   end
               end
           end
        end
        
        
        % cloud fusion
        
        if p<=pn-2
        %     find lines
        line_vect=cross(vect,next_vect);
        A=[vect;next_vect; 0 0 1];
        B=[-d -next_d 1];
        line_point=inv(A)*B';

%     calc distance from section's points to line
        sect_point=point(p+1,:);
        dist_vect1=line_point-sect_point';
        v=cross(dist_vect1,line_vect);
        distance=sqrt(sum(v.^2))/sqrt(sum(line_vect.^2));
        
        if distance<=dev*k+1
%             fusion
            plot3(pon(1),pon(2),pon(3),'*k');
            fusionFlag(c_cloud)=true;
            fusionPoint(c_cloud)=p+1;
        end
        
        end
        
        if p>=2
%     find lines
        line_vect=cross(vect,prev_vect);
        A=[vect;prev_vect; 0 0 1];
        B=[-d -prev_d 1];
        line_point=inv(A)*B';

%     calc distance from section's points to line
        sect_point=point(p,:);
        dist_vect=line_point-sect_point';
        v=cross(dist_vect,line_vect);
        distance=sqrt(sum(v.^2))/sqrt(sum(line_vect.^2));
        
        if distance<=dev*k+1
%             fusion
            plot3(pon(1),pon(2),pon(3),'*k');
            fusionFlag(c_cloud)=true;
            fusionPoint(c_cloud)=p;
        end
        
        end
        %----
        
        ori_in_cloud(c_cloud,:)=orientation;
        num_p_in_cloud(c_cloud)=c-1;
        c_cloud=c_cloud+1;
        
    end
    
    
end
fusionFlag(c_cloud)=false;
fusionPoint(c_cloud)=0;

cloud(c_cloud,1,:)=point(N(1),:);
num_p_in_cloud(c_cloud)=1;
ori_in_cloud(c_cloud,:)=ori(N(1),:);


% Clouds Fusion

c=0;
n=0;
pont=-1;
for i=1:c_cloud
    if fusionPoint(i)==pont && fusionFlag(i)==true
        for j=1:num_p_in_cloud(i)
            cloud2(c,n+j,:)=cloud(i,j,:);
        end
        n=n+num_p_in_cloud(i);
        new_num_p_in_cloud(c)=n;
        new_ori_in_cloud(c,:)=ori_in_cloud(i,:);
        pont=fusionPoint(i);
    else
        c=c+1;
        for j=1:num_p_in_cloud(i)
            cloud2(c,j,:)=cloud(i,j,:);
        end
        new_num_p_in_cloud(c)=num_p_in_cloud(i);
        new_ori_in_cloud(c,:)=ori_in_cloud(i,:);
        n=num_p_in_cloud(i);
        pont=fusionPoint(i);
    end
end

clear num_p_in_cloud ori_in_cloud cloud

cloud=cloud2;
num_p_in_cloud=new_num_p_in_cloud;
ori_in_cloud=new_ori_in_cloud;



c_cloud=c;

p=plot3(point(:,1),point(:,2),point(:,3),'g','LineWidth',2);

for i=1:c_cloud
    a=plot3(cloud(i,1:num_p_in_cloud(i),1),cloud(i,1:num_p_in_cloud(i),2),...
        cloud(i,1:num_p_in_cloud(i),3),'o','LineWidth',0.5);
end

xlabel('X, mm');
ylabel('Y, mm');
zlabel('Z, mm');
% legend([a p],'Graph points','Trajectory')
set(gca,'FontSize',16);


grid on

% plot3(0,0, 0,'*r','LineWidth',3)
c=1;
for i=1:c_cloud
    
    P(c:(c+num_p_in_cloud(i)-1),:)= cloud(i,1:num_p_in_cloud(i),:);
    c=c+num_p_in_cloud(i);
end

% f=figure();
% hold on
%
% plot3(P(:,1),P(:,2),P(:,3),'o')

kk = boundary(P,0.8);

trisurf(kk,P(:,1),P(:,2),P(:,3),'Facecolor','red','FaceAlpha',0.2,'LineStyle','none')



% 

