function response = activV1(d, di, sig, A1, A2, A3)
% Returns the tuning profile of a near-tuned V1 cell.
% Input argument defs:
%
%   d   - disparity
%   di  - prefered disparity of cell i
%   sig - std of the gaussian for cell i
%   A1  - 
%   A2  -
%   A3  -

arg1 = -(d - di)^2 / sig^2; 

arg2 = -(d - (d + sig^2))^2 / sig^2; 

response = A1*exp(arg1) - A2*exp(arg2) + A3;

end