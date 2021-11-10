function [control] = control(param, pixel_d, pixel, p, c)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here
e =pixel_d-pixel;

R = T(c(4,1));

Rotacion = [inv(R), zeros(3,3);
            zeros(3,3), inv(R)];
        
J=jacobian_camera(param, pixel, p, c);

J_movil = Jacobiano_c(c(4,1));

aux = [1,0,0;...
       0,1,0;...
       0,0,0;...
       0,0,0;...
       0,0,0;...
       0,0,1];
   
J_total = J*Rotacion*aux*J_movil;
K1 = 1*eye(10);
K2 = 50*eye(10);
control = pinv(J_total)*(K2*tanh(inv(K2)*K1*e));
end

