clear; close all; clc

% load('data_point2point.mat');
load('data2.mat');

N=size(traect);
traject11=zeros(3,N(1));

traject11(1,:)=smooth(traect(:,1,11),'rlowess');
traject11(2,:)=smooth(traect(:,2,11),'rlowess');
traject11(3,:)=smooth(traect(:,3,11),'rlowess');

traject10(1,:)=smooth(traect(:,1,10),'rlowess');
traject10(2,:)=smooth(traect(:,2,10),'rlowess');
traject10(3,:)=smooth(traect(:,3,10),'rlowess');


% plot3(traject11(1,:),traject11(2,:),traject11(3,:))

% bondaries for p1 and p2 calculated "by hand"

x1=mean(traject11(1,200));
y1=mean(traject11(2,200));
z1=mean(traject11(3,200));


x2=-0.25;
y2=-0.21;
z2=1.54;

hold on
% plot3(traject11(1,25:300),traject11(2,25:300),traject11(3,25:300))
plot3(x1,y1,z1,'o')
plot3(x2,y2,z2,'o')
% hold off

c=1;
i=33;
sensitivity=0.07;
track11_forward=zeros(20,100,3);
track11_forward_num_of_points=zeros(20,1);
track11_back=zeros(20,100,3);
track11_back_num_of_points=zeros(20,1);

track10_forward=zeros(20,50,3);
track10_back=zeros(20,50,3);

while i<N(1)-200
    
    x=traject11(1,i);
    y=traject11(2,i);
    z=traject11(3,i);
    
    while sqrt((x1-x)^2+(y1-y)^2+(z1-z)^2)<=sensitivity
        
        i=i+1;
        x=traject11(1,i);
        y=traject11(2,i);
        z=traject11(3,i);
    end
    
%     start tracking forward
    track11_forward(c,1,:)=traject11(:,i-1);
    track10_forward(c,1,:)=traject10(:,i-1);
    j=2;
    while sqrt((x2-x)^2+(y2-y)^2+(z2-z)^2)>=sensitivity
        
        track11_forward(c,j,:)=traject11(:,i);
        track10_forward(c,j,:)=traject10(:,i);
        j=j+1;
        i=i+1;
        x=traject11(1,i);
        y=traject11(2,i);
        z=traject11(3,i);
        
    end
    track11_forward(c,j,:)=traject11(:,i);
    track10_forward(c,j,:)=traject10(:,i);
    track11_forward_num_of_points(c)=j;
    
    while sqrt((x2-x)^2+(y2-y)^2+(z2-z)^2)<=sensitivity
        
        i=i+1;
        x=traject11(1,i);
        y=traject11(2,i);
        z=traject11(3,i);
    end
    
%     start tracking back
    track11_back(c,1,:)=traject11(:,i-1);
    track10_back(c,1,:)=traject10(:,i-1);
    j=2;
    while sqrt((x1-x)^2+(y1-y)^2+(z1-z)^2)>=sensitivity
        
        track11_back(c,j,:)=traject11(:,i);
        track10_back(c,j,:)=traject10(:,i);
        j=j+1;
        i=i+1;
        x=traject11(1,i);
        y=traject11(2,i);
        z=traject11(3,i);
    end
    track11_back(c,j,:)=traject11(:,i);
    track10_back(c,j,:)=traject10(:,i);
    track11_back_num_of_points(c)=j;
    
    c=c+1;
end



track=zeros((c-1)*2,100,3);
track10=zeros((c-1)*2,100,3);
track_num_of_points=zeros((c-1)*2,1);

% track(1:(c-1),:,:)=track11_forward(1:(c-1),:,:);
% track10(1:(c-1),:,:)=track10_forward(1:(c-1),:,:);
% track_num_of_points(1:(c-1))=track11_forward_num_of_points(1:(c-1));

for i=1 : (c-1)
    j=i;
    
    n=track11_forward_num_of_points(j);
    track_num_of_points(i)=n;
    m=1;
    while n~=0
        track(i,m,:)=track11_forward(j,m,:);
        track10(i,m,:)=track10_forward(j,m,:);
        m=m+1;
        n=n-1;
    end
    
end


for i=c : 2*(c-1)
    j=i-(c-1);
    
    n=track11_back_num_of_points(j);
    track_num_of_points(i)=n;
    m=1;
    while n~=0
        track(i,m,:)=track11_back(j,n,:);
        track10(i,m,:)=track10_back(j,n,:);
        m=m+1;
        n=n-1;
    end
    
end

track_orientation=zeros(size(track));
for i=1 : 2*(c-1)
    
    n=track_num_of_points(i);
    for j=1:n
        
        x1=track10(i,j,1)*1000;
        y1=track10(i,j,2)*1000;
        z1=track10(i,j,3)*1000;
        
        x2=track(i,j,1)*1000;
        y2=track(i,j,2)*1000;
        z2=track(i,j,3)*1000;
        
        track_orientation(i,j,:)=find_angles(x1,y1,z1,x2,y2,z2);
        
    end
    
end


% hold on

k=1;
for i=1:(c-1)*2
    
    n=round(track_num_of_points(i));
%     plot3(track(i,1:n,1),track(i,1:n,2),track(i,1:n,3))
    
    n_track_num_of_points(k)=track_num_of_points(i);
    n_track_orientation(k,1:n,:)=track_orientation(i,1:n,:);
    n_track(k,1:n,:)=track(i,1:n,:);
    k=k+1;
    if i==9; k=k-1;end;
    if i==2; k=k-1;end;
    if i==12; k=k-1;end;
end

clear track_num_of_points track_orientation track

track=n_track;
track_orientation=n_track_orientation;
track_num_of_points=n_track_num_of_points;
    
k=1;

f=figure();
hold on
xlabel('X, m');
ylabel('Y, m');
zlabel('Z, m');

for i=1:4
    
    n=round(track_num_of_points(i));
    plot3(track(i,1:n,1),track(i,1:n,2),track(i,1:n,3))
    
end
legend('line 1', 'line 2', 'line 3', 'line 4')
hold off
