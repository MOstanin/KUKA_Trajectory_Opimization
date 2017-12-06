function [ T7 ] = forward_kin_iiwa( q )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
    o1=q(1);
    o2=q(2);
    o3=q(3);
    o4=q(4);
    o5=q(5);
    o6=q(6);
    o7=q(7);
    
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

end
