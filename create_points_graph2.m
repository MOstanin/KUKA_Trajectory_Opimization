clear
close all


% creation of points sets by using the error vector limitation


% geniration of planes and points


q0=[1.6605    0.8390   -1.5833    1.5496   -0.4952    0.0999    1.3333];
point(1,:)=[-500,-350,650];
point(2,:)=[-550,-230,650];
point(3,:)=[-550,230,600];
point(4,:)=[-500,350,650];

sigma=10;

num_p_in_cloud(1)=1;
pn=4;
cloud(1,1,1:3)=point(1,:);
c_cloud=2;
%    Ax+By+Cz+D=0 plane equation
planes_coef=zeros(1,4);
control_points=zeros(1,3);


T=forward_kin_iiwa(q0);
G = digraph;

table_of_points=zeros(4,3);
table_of_q=zeros(4,7);
table_of_q(1,:)=q0;

% j - point number
j=1;

for p=1:pn-1
   len=sqrt(sum((point(p,:)-point(p+1,:)).^2));
   n_del=round(len/sigma);
   del=len/n_del;
%    Ax+By+Cz+D=0 plane equation
   vector=point(p,:)-point(p+1,:);
   
   for t=0:n_del-1
       
       pon=point(p,:)+vector*(del*t/len);
       d=-sum(vector*pon');
       
       n2=10;
       vec_from(1:n2)=j;
        vec_to(1:n2)=c2:(c2+n2-1);
        vec_w(1:n2)=pi*7;
        
        for k=1:n2
            T(1:3,4)=table_of_points(c2+k-1,:);
            table_of_q(c2+k-1,:)=inv_kin_iiwa_NS(table_of_q(j,:),T);
            del_q=table_of_q(c2+k-1,:)-table_of_q(j,:);
            vec_w(k)=sum(del_q.^2);
        end
        
        G=addedge(G,vec_from,vec_to,vec_w);
        clear vec_from vec_to vec_w
       
       num_p_in_cloud(c_cloud)=c-1;
       c_cloud=c_cloud+1;
       
   end
end
cloud(c_cloud,1,:)=point(4,:);
num_p_in_cloud(c_cloud)=1;