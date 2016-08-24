function D = distMod(s, v)
%
%   file    : distMod.m
%   author  : Samuel Lee (samuell@bu.edu)
%   date    : 8/12/16
%
%   description: The Distance Module for a Distance-Dependent neural
%   network. 
%
%   Takes inputs:
%       - s (disparity, scalar, in range [-4, 4])
%       - v (vergence angle, scalar)
%
%   Outputs:
%       - D (distance, scalar)
%
%   credit: Network architecture is based on the paper "A Neural Model of
%   Distance-Dependent Percept of Object Size Constancy" (Qian &
%   Yazdanbakhsh, 2015).
%
%   LAST MODIFED: 8/19/16 16:00

%% Initialize nodes
% V1 (n = 40)
% FEF (n = 5)
% MT (n = 200)
% LIP (n = 1)

N_V1  = 40; % num V1 nodes
N_FEF = 5;  % num FEF nodes

V1  = zeros(N_V1,1);
FEF = zeros(N_FEF,1);

%% Define V1 node-types
% Six types (see paper for details):
%   - TE (tuned excitatory)
%   - TI (tuned inhibitory)
%   - TN (tuned near)
%   - TF (tuned far)
%   - FA (far)
%   - NE (near)

    function a = tuneNF(A1, A2, A3, si, sigma)
       % Tuning function for Near & Far (NE, TN, FA, TF) nodes.
       % Takes inputs: 
       %    - A1 (height of first gaussian)
       %    - A2 (height of second gaussian)
       %    - A3 (constant)
       %    - si (preffered disparity for node i)
       %    - sigma (STD of curve for node i)
       
       arg1 = -((s - si)^2 / sigma^2 );
       arg2 = -((s - (s + sigma^2))^2 / sigma^2 );
       
       a = A1*exp(arg1) - A2*exp(arg2) + A3;
    end
    function a = tuneTE(A1, A2, si, sigma)
       % Tuning function for TE nodes.
       % Takes inputs: 
       %    - A1 (height of gaussian)
       %    - si (preffered disparity for node i)
       %    - sigma (STD of curve for node i)
       
       arg1 = -(( s - si)^2 / sigma^2); 
       
       a = A1*exp(arg1) + A2;
    end

% set cell types and preffered disparities

div = idivide(N_V1, int32(3), 'floor');     % group sizes for cell types
div = double(div);

nNear = div;
nFar  = div;
nZero = N_V1-2*div; 

nearCells = linspace(1, div, nNear);
farCells  = linspace(div+1, 2*div, nFar);
zeroCells = linspace(2*div+1, N_V1, nZero);

% preffered disparities
nearDisp = linspace(-4,-1.5, nNear);      % for NE/TN nodes
farDisp  = linspace(1.5, 4, nFar);        % for FA/TF nodes 
zeroDisp = linspace(-1.5, 1.5, nZero);    % for TE nodes


% update near cells
for i = 1:nNear
    V1(nearCells(i)) = tuneNF(1, 1, 0.2, nearDisp(i), 3);    % tuneNF(A1, A2, A3, si, sigma)
end

% update far cells
for i = 1:nFar
    V1(farCells(i)) = tuneNF(1, 1, 0.2, farDisp(i), 3);     % tuneNF(A1, A2, A3, si, sigma)
end

% update zero cells
for i = 1:nZero
    V1(zeroCells(i)) = tuneTE(1, 0.2, zeroDisp(i), 3);          % tuneTE(A1, A2, si, sigma)
end


%% MT integration
MT = V1 * FEF';

%% DEBUGGING
D = V1(v);     % currently returns a scalar of activity of one cell


% return D
end