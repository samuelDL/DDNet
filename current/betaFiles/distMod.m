function D = distMod(s, v)
%%%%%%%%%%%% CAUTION! THIS IS A BETA VERSION!!! READ ONLY! %%%%%%%%%%%%%%%
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
%   LAST MODIFED: 8/17/16 16:22
%

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
    function a = tuneTE(A1, si, sigma)
       % Tuning function for TE nodes.
       % Takes inputs: 
       %    - A1 (height of gaussian)
       %    - si (preffered disparity for node i)
       %    - sigma (STD of curve for node i)
       
       arg1 = -(( s - si)^2 / sigma^2); 
       
       a = A1*exp(arg1);
    end

nearDisp = linspace(-4,-1.5, N_V1);   % preffered disparities for NE/TN nodes
farDisp  = linspace(1.5, 4, N_V1);    % preffered disparities for FA/TF nodes 
zeroDisp = linspace(-1.5, 1.5, N_V1); % preffered disparities for TE nodes

switch s
    % NE/TN
    case s < -1.5   % s in range [-4, 1.5]
        % execute NF function for near nodes

        A1 = 1;
        A2 = 1;
        A3 = 0;
        sigma = 3; 

        for i = 1:N_V1
            V1(i) = tuneNF(A1, A2, A3, nearDisp(i), sigma); 
        end
        
    % TE
    case s >= -1.5 && s <= 1.5
        % execute TE function
        
        A1 = 1;
        sigma = 3; 
        
        for i = 1:N_V1
            V1(i) = tuneTE(A1, zeroDisp(i), sigma);
        end
        
    % FA/TF    
    otherwise  % s in range [1.5, 4]
        % execute NF function for far nodes
        
        A1 = 1;
        A2 = 1;
        A3 = 0;
        sigma = 3; 

        for i = 1:N_V1
            V1(i) = tuneNF(A1, A2, A3, farDisp(i), sigma); 
        end
end



%% MT integration
MT = V1 * FEF';

%% DEBUGGING
D = V1;     % currently returns a scalar of activity of one cell


% return D
end