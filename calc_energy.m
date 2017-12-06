function [ Energy ] = calc_energy( lbr, qWaypoints, t)

tt=[0 t/3 2*t/3 t];
tWaypoints=[0 t];
[qDesired, qdotDesired, qddotDesired, tt] = exampleHelperJointTrajectoryGeneration(tWaypoints, qWaypoints, tt);

n = size(qDesired,1);
tau = zeros(n,7);
for i = 1:n
    tau(i,:) = inverseDynamics(lbr, qDesired(i,:), qdotDesired(i,:), qddotDesired(i,:));
end


Energy=sum(sum(abs(tau(:,:))));


end



