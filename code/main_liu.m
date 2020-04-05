%MATLAB analysis of an empirical network.
%FOR LIUBOV EXAMPLE! :D

addpath power-law-master/

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Setup
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ****** beta ******
init.beta = 0;
%beta defines the relation-ship with distance, could be a vector in order 
%to test different values of beta (example: beta = [-2:.1:2];)
%beta = -1 : inverse-relationship with euclidean distance
%beta = 0 : no effect of distance 
%beta = 1 : typical effect of euclidean distance
%beta = 2 : power-2 effect of euclidean distance

% ****** Strategy ******
init.strategy = 'random';
%defines strategies for pruning the network's links, possible options are: 
%'random' : will remove links randomly (S = 0)
%'minimal': will remove the link with the minimal flux (the first one found
%if equal values) (S = 1)
%'strongest': will remove the link with the strongest flux (the first one
%found if equal values) (S = 2)

%-----Simulation initializations
init.n_sims = 1000;        %number of simulations (realizations) to perform per configurations
init.recompile_mex = 0; %recompile mex file (if needed, else will try to re-use the provided MEX-file).
init.is_mex = 1;        %use mex file? (only for non-sparse matrixes)
init.is_parallel = 0;   %Should we use parallel computing?
init.override = 4;      %one could choose to override the number of physical
%cores when paralleling the computations, thus is override == 3; will use 3
%cores instead of machine capacity.

%-----mex compilation (if required):
if(init.is_mex && init.recompile_mex)
    %Check 'OPTIMFLAGS' and make sure 'O2' appears in 'OPTIM'
    mex evolution/package/mex-files/prepare_sys_full.c;
    mex evolution/package/mex-files/compute_q_full.c;
    %for verbose, instead use:
    %mex package/mex-files/prepare_sys_full.c -v;
    %mex package/mex-files/compute_q_full.c -v;
end

%-----make sure to shuffle the RNG to have different files at each call:
rng('shuffle');

%-----Folder inits
addpath('./evolution/package');
addpath('./evolution/toolboxes/vpi');

if(init.is_parallel)
    %Init parallel pool:
    mPool = Start_MultiCores_Env_2017(init.override);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% LIUBOV's EXAMPLE (BELGIUM TRAINS)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf(1, "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n");
fprintf(1, "%% LIUBOV's EXAMPLE\n");
fprintf(1, "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n");
txt_flag = "Belgium trains";
% folder and file name:
filename = '../Belgium_Trains/networkAdjMatrBelgiumTrains.txt';
G = load(filename);
fprintf(1, 'Total number of nodes before processing: %d\n', size(G,1));
fprintf(1, 'Total number of links before processing: %d\n', sum(sum(tril(G))));
%order is: (1) remove loops, (2) remove isolated nodes
G = remove_loops(G); %remove loops
G = remove_isolated_nodes(G); %then remove isolated nodes
G = remove_unconnected_nodes(G); %then remove unconnected nodes
fprintf(1, 'Total number of nodes after processing: %d\n', size(G,1));
fprintf(1, 'Total number of links after processing: %d\n', sum(sum(tril(G))));

% plot and estimate power-law coefficient:
% https://github.com/XikunHuang/power-law/blob/master/plfit.m
degrees = sum(G,2);
[gamma, xmin, L] = plfit(degrees);

% then start evolution: 
launch_evolution(init, G, gamma, degrees, txt_flag);

if(init.is_parallel)
    %Init parallel pool:
    Terminate_MultiCore_Env_2017(mPool);
end

% closing stuff:
rmpath power-law-master/
rmpath('./evolution/toolboxes/vpi');
rmpath('./evolution/package');


% set(0, 'DefaultFigureRenderer', 'painters');
% h = figure;
% hold on;
% subplot(1,5,1);
% plot(graph(G));
% axis square;
% title('graph');
% subplot(1,5,2);
% spy(G);
% title('adj matrix');
% subplot(1,5,3);
% hist(degrees, 20);
% str = sprintf("\\gamma=%.2f", gamma);
% text(2,10, str);
% title('degree distribution');
% axis square;
% subplot(1,5,4);
