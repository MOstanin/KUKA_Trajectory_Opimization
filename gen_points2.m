
q0=[-0.5481   -1.4420    0.0221   -1.6306   -0.5467    1.5004    0.0171];
% point(1,:)=[-500,-350,650];
% point(2,:)=[-550,-230,650];
% point(3,:)=[-450,200,600];
% point(4,:)=[-500,350,650];

load('track_opt1.mat');

% --- zero
    trans_lvl_x=round((1810+1715)/2+(550+575)/2);     
    trans_lvl_y=0;
    trans_lvl_z=100;

N=size(track_opt);
for i=1:N(1)
    point(i,:)=[trans_lvl_x-track_opt(i,3)*1000, trans_lvl_y-track_opt(i,1)*1000,...
        trans_lvl_z+track_opt(i,2)*1000];
end

sigma=10;

num_p_in_cloud(1)=1;
pn=N(1);
cloud(1,1,1:3)=point(1,:);
c_cloud=2;

for p=1:pn-1
   lenth=sqrt(sum((point(p,:)-point(p+1,:)).^2));
    n_del=round(lenth/(3*sigma));
%     n_del=10;
   del=lenth/n_del;
%    Ax+By+Cz+D=0 plane equation
   vect=point(p+1,:)-point(p,:);
   
   for t=0:n_del-1
       
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
       for i=36:36:360
           for j=1:5
%                distant from center to point
%                l=exp(j*(log(sigma)/5));
               l=exp(j*(log(sigma)/5));
               x=cos(i*pi/180)*l;
               y=sin(i*pi/180)*l;
               p2=T*[x, y, 0, 1]';
               cloud(c_cloud,c,:)=p2(1:3,1);
               c=c+1;
               
               if (p2(1:3,1)'*vect'+d)>1 
                   disp('point not in plane');
               end
           end
       end
%                
%        for i=-1:1:1
%        for j=-1:1:1
%            
%            
%            p2=T*[i*sigma, j*sigma, 0, 1]';
%            cloud(c_cloud,c,:)=p2(1:3,1);
%            c=c+1;
%            if (p2(1:3,1)'*vect'+d)>1 
%                disp('point not in plane');
%            end
%        end
%        end
       
%             for k=-1:1:1
%                 x1=pon(1)+i*sigma;
%                 y1=pon(2)+j*sigma;
%                 z1=pon(3)+k*sigma;
%                 
%                 M=[vect(2) -vect(1) 0; 0 -vect(3) -vect(2);vect(1) vect(2) vect(3)];
%                 r=[x1*vect(2)-y1*vect(1); y1*vect(3)-z1*vect(2);-d ];
%                 proection=inv(M)*r;
%                 
%                 cloud(c_cloud,c,:)=proection;
%                 c=c+1;
%             end
%        end
%        end
        
       
       num_p_in_cloud(c_cloud)=c-1;
       c_cloud=c_cloud+1;
       
   end

   
end
cloud(c_cloud,1,:)=point(4,:);
num_p_in_cloud(c_cloud)=1;


hold on

plot3(point(:,1),point(:,2),point(:,3))

for i=1:c_cloud
    plot3(cloud(i,1:num_p_in_cloud(i),1),cloud(i,1:num_p_in_cloud(i),2),cloud(i,1:num_p_in_cloud(i),3),'o')
end



       