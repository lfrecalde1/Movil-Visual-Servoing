function [v] = Control(hd, hdp, h)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
st =h(1:2,1);
q = h(3,1);
he = hd-st;

K2 = eye(2);
K1 = 1*eye(2);
J = Jacobiano_c(q);
v = inv(J'*J)*J'*(hdp+K2*tanh((K2)^(-1)*K1*he));
end

