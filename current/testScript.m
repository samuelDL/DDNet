% Test script for distMod.m file

clear; clc; close all;

N = 1000; % num data points per trace

disp = linspace(-4, 4, N);
out  = zeros(1,N);

figure(1); hold on;

for j = 1:40    % iterate thorugh all cells in net
    for i = 1:N

        %fprintf( 'Disp. --> %d\n', disp(i) ) 

        out(i) = distMod(disp(i), j);

    end
    
    
    if j <= 13
        h1 = plot(disp, out, 'b');    % near cells

    elseif j >= 14 && j <= 26
        h2 = plot(disp, out, 'g');    % far cells

    else
        h3 = plot(disp, out, 'r');    % zero cells
    end
           
end 

axis([-4 4 0 1.2])
ylabel('Activity'); xlabel('Disparity (deg)'); 
title('Simulated tuning curves of disparity')
legend([h1 h2 h3],'Near cells','Far cells', 'Zero cells', 'location', 'southwest')
hold off;



