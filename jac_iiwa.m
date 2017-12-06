function [ J ] = jac_iiwa( q )
%jac_iiwa calculate jacoboan for IIWA LBR 14
%   Detailed explanation goes here
    
    o1=q(1);
    o2=q(2);
    o3=q(3);
    o4=q(4);
    o5=q(5);
    o6=q(6);
    o7=q(7);
    
% kuka iiwa DH params
    d1=360;
    d2=0;
    d3=420;
    d4=0;
    d5=400;
    d6=0;
    d7=130;

    a1=0;
    a2=0;
    a3=0;
    a4=0;
    a5=0;
    a6=0;
    a7=0;

    alh1=pi/2;
    alh2=-pi/2;
    alh3=pi/2;
    alh4=-pi/2;
    alh5=pi/2;
    alh6=-pi/2;
    alh7=0;


    A1= calcMatrix(d1,o1,a1,alh1);
    A2= calcMatrix(d2,o2,a2,alh2);
    A3= calcMatrix(d3,o3,a3,alh3);
    A4= calcMatrix(d4,o4,a4,alh4);
    A5= calcMatrix(d5,o5,a5,alh5);
    A6= calcMatrix(d6,o6,a6,alh6);
    A7= calcMatrix(d7,o7,a7,alh7);

    T7=A1*A2*A3*A4*A5*A6*A7;
    T6=A1*A2*A3*A4*A5*A6;
    T5=A1*A2*A3*A4*A5;
    T4=A1*A2*A3*A4;
    T3=A1*A2*A3;
    T2=A1*A2;
    T1=A1;
    
    
    z0 = [0 0 1]';
    z1 = T1(1:3,3);
    z2 = T2(1:3,3);
    z3 = T3(1:3,3);
    z4 = T4(1:3,3);
    z5 = T5(1:3,3);
    z6 = T6(1:3,3);

    p0=[0 0 0]';
    p1=T1(1:3,4);
    p2=T2(1:3,4);
    p3=T3(1:3,4);
    p4=T4(1:3,4);
    p5=T5(1:3,4);
    p6=T6(1:3,4);
    p7=T7(1:3,4);

    J = [ cross(z0,(p7-p0)), cross(z1,(p7-p1)), cross(z2,(p7-p2)), cross(z3,(p7-p3)), cross(z4,(p7-p4)), cross(z5,(p7-p5)), cross(z6,(p7-p6))
                z0,                z1,                z2,                z3,                z4,                z5,                z6 ];

    
end

