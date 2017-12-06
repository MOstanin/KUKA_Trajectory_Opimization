
q0=[1.6605    0.8390   -1.5833    1.5496   -0.4952    0.0999    1.3333];
point_1=[-500,-350,650];
point_2=[-500,-230,650];
point_3=[-500,230,650];
point_4=[-500,350,650];



sigma=30;

n=27;
cloud=zeros(2,n,3);

num_p_in_cloud=[1 27 27 1];
c=1;
for i=-1:1:1
    for j=-1:1:1
        for k=-1:1:1

            cloud(1,c,:)=[point_2(1)+i*sigma, point_2(2)+j*sigma, point_2(3)+k*sigma];
            c=c+1;
        end
    end
end

c=1;
for i=-1:1:1
    for j=-1:1:1
        for k=-1:1:1

            cloud(2,c,:)=[point_3(1)+i*sigma, point_3(2)+j*sigma, point_3(3)+k*sigma];
            c=c+1;
        end
    end
end





