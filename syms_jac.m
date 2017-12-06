syms o1 o2 o3 o4 o5 o6 o7
    
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


%     A1= calcMatrix(d1,o1,a1,alh1);
%     A2= calcMatrix(d2,o2,a2,alh2);
%     A3= calcMatrix(d3,o3,a3,alh3);
%     A4= calcMatrix(d4,o4,a4,alh4);
%     A5= calcMatrix(d5,o5,a5,alh5);
%     A6= calcMatrix(d6,o6,a6,alh6);
%     A7= calcMatrix(d7,o7,a7,alh7);

A1=[ cos(o1), 0,   sin(o1),    0;...
    sin(o1),  0, -cos(o1),     0;...
        0,    1,    0,     360.0;...
        0,    0,    0,      1.0];
    
A2=[ cos(o2),  0,   -sin(o2),    0;...
    sin(o2),   0,   cos(o2),     0;...
        0,    -1,    0,          0;...
        0,     0,    0,         1.0];  
    
A3=[ cos(o3), 0,   sin(o3),    0;...
    sin(o3),  0, -cos(o3),     0;...
        0,    1,    0,     420.0;...
        0,    0,    0,      1.0];    
    
A4=[ cos(o4),  0,   -sin(o4),    0;...
    sin(o4),   0,   cos(o4),     0;...
        0,    -1,    0,          0;...
        0,     0,    0,         1.0]; 
    
A5=[ cos(o5), 0,   sin(o5),    0;...
    sin(o5),  0, -cos(o5),     0;...
        0,    1,    0,     400.0;...
        0,    0,    0,      1.0];  
    
A6=[ cos(o6),  0,   -sin(o6),    0;...
    sin(o6),   0,   cos(o6),     0;...
        0,    -1,    0,          0;...
        0,     0,    0,         1.0]; 
    
A7=[ cos(o7), -1.0*sin(o7),  0,     0;...
    sin(o7),      cos(o7),   0,     0;...
    0,            0,         1, 130.0;...
    0,            0,         0,   1.0];
    
    T7=A1*A2*A3*A4*A5*A6*A7;
    T6=A1*A2*A3*A4*A5*A6;
    T5=A1*A2*A3*A4*A5;
    T4=A1*A2*A3*A4;
    T3=A1*A2*A3;
    T2=A1*A2;
    T1=A1;
    
    T7=simplify(T7);
    T6=simplify(T6);
    T5=simplify(T5);
    T4=simplify(T4);
    T3=simplify(T3);
    T2=simplify(T2);
    T1=simplify(T1);
    
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
    
    c1=cross(z0,(p7-p0));
    c2=cross(z1,(p7-p1));
    c3=cross(z2,(p7-p2));
    c4=cross(z3,(p7-p3));
    c5=cross(z4,(p7-p4));
    c6=cross(z5,(p7-p5));
    c7=cross(z6,(p7-p6));
    
    c7=simplify(c7);
    c6=simplify(c6);
    c5=simplify(c5);
    c4=simplify(c4);
    c3=simplify(c3);
    c2=simplify(c2);
    c1=simplify(c1);
    
%     J = [ cross(z0,(p7-p0)), cross(z1,(p7-p1)), cross(z2,(p7-p2)), cross(z3,(p7-p3)), cross(z4,(p7-p4)), cross(z5,(p7-p5)), cross(z6,(p7-p6))
%                 z0,                z1,                z2,                z3,                z4,                z5,                z6 ];
    
J = [c1,c2,c3,c4,c5,c6,c7;...
    z0,z1,z2,z3,z4,z5,z6]


 simplify(J)