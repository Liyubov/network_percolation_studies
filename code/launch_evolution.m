function launch_evolution(init, G, gamma, degrees, txt_flag)
%perform evolution using the 'G' adjacency matrix only:

% define usefull variables:
n_nodes = size(G,1); %number of nodes
dim = 2;             %dimension of the graph
net_size = n_nodes;  %'size' of the network (1 means the unit square)

% 'gamma':already defined

% ****** beta ******
beta = init.beta;
%beta defines the relation-ship with distance, could be a vector in order 
%to test different values of beta (example: beta = [-2:.1:2];)
%beta = -1 : inverse-relationship with euclidean distance
%beta = 0 : no effect of distance 
%beta = 1 : typical effect of euclidean distance
%beta = 2 : power-2 effect of euclidean distance

% ****** Strategy ******
strategy = init.strategy;
%defines strategies for pruning the network's links, possible options are: 
%'random' : will remove links randomly (S = 0)
%'minimal': will remove the link with the minimal flux (the first one found
%if equal values) (S = 1)
%'strongest': will remove the link with the strongest flux (the first one
%found if equal values) (S = 2)

%-----Simulation initializations
n_sims = init.n_sims;                   %number of simulations (realizations) to perform per configurations
recompile_mex = init.recompile_mex;     %recompile mex file (if needed, else will try to re-use the provided MEX-file).
is_mex = init.is_mex;                   %use mex file? (only for non-sparse matrixes)
is_parallel = init.is_parallel;         %Should we use parallel computing?
override = init.override;               %one could choose to override the number of physical
%cores when paralleling the computations, thus is override == 3; will use 3
%cores instead of machine capacity.

run('evolution/main_script.m');

