function [R] = T(th)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
Rz1 = trotz(th);
Rz1 = Rz1(1:3,1:3);

Ry = troty(pi/2);
Ry = Ry(1:3,1:3);

Rz2 = trotz(-pi/2);
Rz2 = Rz2(1:3,1:3);

R = Rz1*Ry*Rz2;
end

