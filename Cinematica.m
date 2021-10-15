function [hk] = Cinematica(h, v, ts)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
hp = f(h, v);
hk = h + hp*ts;
end

