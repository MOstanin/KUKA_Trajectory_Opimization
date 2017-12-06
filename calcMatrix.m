function [ A ] = calcMatrix( di,oi,ai,alhi )
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here

    A=[ cos(oi), -cos(alhi)*sin(oi),  sin(alhi)*sin(oi), ai*cos(oi)
        sin(oi),  cos(alhi)*cos(oi), -sin(alhi)*cos(oi), ai*sin(oi)
            0,      sin(alhi),        cos(alhi),           di
            0,           0,              0,                 1];
%     A = vpa(A,3);

    
end

