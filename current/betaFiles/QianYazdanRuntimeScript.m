 %
%   File    : QianYazdanRuntimeScript.m
%   Author  : Samuell@bu.edu
%   Date    : 7/15/16
%   
%   Description:
%       Main runtime script for the generation of a neural model of
%       distance-doependent percept of ojbect size constancy.
%
%       Two sequential stages: 
%           - The Distance module
%               > Creates distance map
%               > Incorporates areas V1 (disparity), FEF (vergence), MT 
%                 (disparity and vergence integration), and LIP (distance).
%           - The Size module
%               > Tune size as regulated by distance
%               > Incorporates LIP (distance), MT (distance scaling), and
%                 V1 (size).
%
%   Credit:
%       The network architecture was based of of the paper "A Neural Model
%       of Distance-Dependent Percept of Object Size Constancy" (Qian &
%       Yazdanbakhsh, 2015). 
%
%% Runtime script:

clear; close all; 

% Initialize distance module:

N = 10;     % dimension of node matricies


prefDisp = linspace(-4, -1.5, 100);

test = zeros(1,100); j = 100; 
for i = 1:100
   test(i) = activV1(prefDisp(j), prefDisp(i), 3, 1, 1, 1);
   j = j - 1; 
end

plot(prefDisp, test)
hold on; 























