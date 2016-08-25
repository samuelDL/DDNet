function D = distMod(s, v)
%
%   file    : distMod.m
%   author  : Samuel Lee (samuell@bu.edu)
%   date    : 8/12/16
%
%   Description: The Distance Module for a Distance-Dependent neural
%   network. 
%
%   Takes inputs:
%       - s (disparity, scalar, in range [-4, 4])
%       - v (vergence angle, scalar)
%
%   Outputs:
%       - D (distance, scalar)
%
%   Credit: Network architecture is based on the paper "A Neural Model of
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

%% Define and activate disparity-tuned V1 nodes

% tuning functions for V1 nodes
    function a = tuneNF(A1, A2, A3, si, sigma)
       % Tuning function for Near & Far (NE, TN, FA, TF) V1 nodes.
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
       % Tuning function for TE V1 nodes.
       % Takes inputs: 
       %    - A1 (height of gaussian)
       %    - si (preffered disparity for node i)
       %    - sigma (STD of curve for node i)
       
       arg1 = -(( s - si)^2 / sigma^2); 
       
       a = A1*exp(arg1) + A2;
    end

% set cell types and preffered disparities

% group sizes for cell types
div = double(idivide(N_V1, int32(3), 'floor'));
nNear = div; nFar = div; nZero = N_V1-2*div; 

% locations of cell types in V1
nearCells = linspace(1, div, nNear);
farCells  = linspace(div+1, 2*div, nFar);
zeroCells = linspace(2*div+1, N_V1, nZero);

% preffered disparities
nearDisp = linspace(-4,-1.5, nNear);      % for NE/TN nodes
farDisp  = linspace(1.5, 4, nFar);        % for FA/TF nodes 
zeroDisp = linspace(-1.5, 1.5, nZero);    % for TE nodes


% update near cells
for i = 1:nNear
    % tuneNF(A1, A2, A3, si, sigma)
    V1(nearCells(i)) = tuneNF(0.8, 0.8, 0.2, nearDisp(i), abs(nearDisp(i)) );
end

% update far cells
for i = 1:nFar
    % tuneNF(A1, A2, A3, si, sigma)
    V1(farCells(i)) = tuneNF(0.8, 0.8, 0.2, farDisp(i), abs(farDisp(i)) );
end

% update zero cells
for i = 1:nZero
    % tuneTE(A1, A2, si, sigma)
    V1(zeroCells(i)) = tuneTE(0.8, 0.2, zeroDisp(i), abs(zeroDisp(i)) ); 
end


%% Define and activate vergence-tuned FEF nodes

    function z = tuneV(vi, T)
        % Tuning function for all FEF nodes
        % Takes inputs:
        %   - v (vergence, scalar)
        %   - vi (preferred vergence of node i, scalar)
        %   - T (slope of curve)
        
        z = 1 / (  1 + exp( -(v - vi) / T )  );
    end

% set parameters for each node
thresh  = linspace(5, 25, N_FEF);       % thresholds
slope   = linspace(4, 5, N_FEF);        % slopes

for i = 1:N_FEF
    % tuneV(vi, T)
    FEF(i) = tuneV(thresh(i), slope(i)); 
end


%% MT integration
MT = V1 * FEF';


%% LIP distance estimation via linear combination

w = ones(N_V1, N_FEF);  % weights from connections from MT to LIP

D = 0.0;
for i = 1:N_V1
    for j = 1:N_FEF
        D = D + w(i,j) * MT(i,j); 
    end
end


%% DEBUGGING (w/ testScript.m)

% begin:    DISPARITY-TEST
%D = V1(v);     % returns a scalar of activity of V1 node v (second inarg)
% end:      DISPARITY-TEST

% begin:    VERGENCE-TEST
%D = FEF(s);     % returns a scalar of activity of FEF node s (first inarg)
% end:      VERGENCE-TEST

% begin:    MT-TEST
D = MT;         % returns N_V1 x N_FEF matrix containing all MT node values
% end:      MT-TEST


end