function [ out ] = rmat2eul( R )
%rmat2eul Calculate euler angels XYZ


    sy = sqrt(R(1,1) * R(1,1) +  R(2,1) * R(2,1));
    x = atan2(R(3,2) , R(3,3));
    y = atan2(-R(3,1), sy);
    z = atan2(R(2,1), R(1,1));
    
    out=[x y z];


end

