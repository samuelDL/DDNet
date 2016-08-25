% Test script for distMod.m file

%% DISPARITY-TEST
clear; clc; close all;

N = 1000; % num data points per trace

disp = linspace(-4, 4, N);
out  = zeros(1,N);
figure(1); hold on;

for j = 1:40    % iterate thorugh all nodes in net
    for i = 1:N
        out(i) = distMod(disp(i), j);   % second arg is node in V1 that is returned
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


%% VERGENCE-TEST

clear; clc; close all;

N = 1000; % num data points per trace

verg = linspace(5, 25, N);
out = zeros(1,N);
figure(1); hold on;

for i = 1:5     % iterate through all nodes in net
   for j = 1:N
       out(j) = distMod(i, verg(j));
   end
   
   plot(verg, out)
    
end
hold off;



%% MT-TEST

clear; clc; close all;

nR = 3;     % rows of subplot
nC = 4;     % columns of subplot 
N  = nR*nC; % number of plots

disp = linspace(-4, 4, N);
verg = linspace(5, 25, N);
verg(:) = 15;

figure('units','normalized','outerposition',[0 0 1 1]); 
title('Simulated MT disparity-vergence tuned response')
k = 1;  % counter for plot number
for i = 1:nR 
    for j = 1:nC 
        subplot(nR, nC, k);
        surf( distMod(disp(k),verg(k)) ); 
        str = sprintf('d = %d, v = %d', int32(disp(k)), int32(verg(k))); 
        title(str); xlabel('vergence'); ylabel('disparity');
        k = k + 1; 
    end
end




%% Testing distance and parameter equations

clear; clc; close all;

% eq(1) from Qian & Yazdanbakhsh, 2015
distance =@(I,d,v) I ./ ( 2*tan((v-d) ./ 2) );    

% eq(1) solved for v
vergence =@(D,I,d) 2 * (tan( I ./ (2 * D) )).^-1 + d; 

% eq(1) solved for d
disparity =@(D,I,v) -2 * (tan( I ./ (2 * D) )).^-1 + v; 


I = 6 * 10^-3;          % interocular distance in meters

v = 10;
d = linspace(-4,4,100);

D = distance(I,d,v);

plot(D); hold on; plot(d); legend('Distance','Disparity');


%% DISTANCE FINAL TEST

clear; clc; 

D = distMod(-4, 20);
disp(D)






















