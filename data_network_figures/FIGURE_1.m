%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Figure 1: potential distribution at t=0 (averaged)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load('results\results--18-Jul-2019-840-US_POWER_GRID.mat');
R = deserialize(R_ser);
clear R_ser

figure;
hold on;

for i=1:size(R,2)
    keyboard;

    
    
end


    tp = (1:size(R{i}.n_links,2)) ./ R{i}.n_links; %normlized time: tp = t / n_links
    %vaut mieux faire: 
    %tp = (1:size(R{i}.n_links,2)) * R{i}.n_links; %normlized time: tp = t
    %/ (n_links)^-1