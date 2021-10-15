function pixel = cemera(K, F, p, c)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
[i, j]= size(p);
X = ones(i+1,j);
%% generacion del vector en coordenadas homogeneas
X(1:i,1:j) = p;

%% Generacion de la ubicacion de la camara
h = c(1:3,1);


R = T(c(4,1));

%% Matriz de tranformacion
H_e =[inv(R),-inv(R)*h;...
      0, 0, 0 ,1];

  
H3 = K*F*H_e*X;
H3 = H3(1:2,:)/H3(3);


pixel = reshape(H3, numel(H3), 1);
end

