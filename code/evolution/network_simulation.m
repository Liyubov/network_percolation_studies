function R = network_simulation(adj_mat, n_nodes, dim, d, gamma, beta, strategy, is_mex)
%performs one network simulation

%remains to do:
% check for the existance of a patch between source and sink
% catch singluar matrixes
% evol_stats with Lyuba

%-----Initial conditions:
degrees = sum(adj_mat, 2);
%Build empirical structure:
G.layout = 0;
G.XY = [0, 0];
G.gamma = gamma;
G.degree = degrees;
G.adjm = adj_mat;
clear adj_mat; %we don't need this adj matrix anymore.

% %%%% SORTED PLACEMENT:
% %we assign nodes to a XY grid, with distance between node equal 1:
% power2 = ceil(sqrt(n_nodes+1))^2; %find the immediate power2 above 'n_nodes'
% S = linspace(0, sqrt(power2)-1, sqrt(power2)); %create a graph with this quantity and each node separated by 1
% X = ndgrid(S,S);
% Y = X'; %should be replaced by something faster
% G.XY = [X(:), Y(:)];
% %but as we generated more coordinates than nodes, we need to prune this
% %vector:
% G.XY = G.XY(1:n_nodes,:);

%%%% RANDOM PLACEMENT:
%we assign nodes to a XY grid in a random way, with distance between node equal 1:
power2 = ceil(sqrt(n_nodes+1))^2; %find the immediate power2 above 'n_nodes'
S = linspace(0, sqrt(power2)-1, sqrt(power2)); %create a graph with this quantity and each node separated by 1
X = ndgrid(S,S);
Y = X'; %should be replaced by something faster
G.XY = [X(:), Y(:)];
%but as we generated more coordinates than nodes, we need to prune this
%vector:
G.XY = G.XY(1:n_nodes,:);
idxs = randperm(size(G.XY,1));
G.XY = G.XY(idxs,:);

[G.dis_eucl] = get_distances(G.XY, G.adjm, beta); %Build distances impact according to beta <== erreur ?
[G.inflow, G.outflow, distance_sinksource] = get_sink_source(G.adjm, d);

if(distance_sinksource == -1)
    %sink / source may not be connected due to a failure in the linking
    %algorithm with high gamma values!
    R.is_warning = 1;
    return
else
    G.distance_SS = distance_sinksource;
    G.distance_switch = 0;
    G.is_warning = 0;
end

%push essential info about the network to the 'R' structure.
G.n_nodes = n_nodes;
G.gamma = gamma;
G.strategy = strategy;
G.beta = beta;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ATTACK THE NETWORK
% (remove the weaskest links until there remains no flux between inflow and outflow)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
is_exit = 0;
k = 1;

R = {};
RN = {};
RL = {};
while(1)
    lastwarn('') % Clear last warning message
    [G.Potentials, G.fluxes] = get_flow(G, is_mex); %Compute the flow
    
    [warnMsg, ~] = lastwarn;
    if ~isempty(warnMsg) %catch singular matrix (due to disconnection in the network for instance)
        G.is_warning = 1;
    else
        G.is_warning = 0;
    end
    
    %===Gather statistics and figures data:
    R = gather_evol_statistics(G, R, RN, RL, k);
    
    %===Apply pruning strategy:
    if(strategy == 0)
        [G, RL, is_exit] = remove_random_link(G);   %Remove random link
    else
        if(strategy == 1)
            [G, RL, is_exit] = remove_weakest_link(G);     %Remove weakest link
        else
            if(strategy == 2)
                [G, RL, is_exit] = remove_strongest_link(G);    %Remove strongest link
            end
        end
    end
    
    cur_dis = find_dis(G.adjm, G.inflow, G.outflow); %returns distance between source and sink
    
    if(sum(sum(~isnan(G.fluxes),2)) == 0 || is_exit || isinf(cur_dis) || G.is_warning == 1)
        %We stop because either:
        % - no more fluxes are existing,
        % - a warning was raised due to singular matrix
        % - is_exit flag is 'on'
        % - the source and sink are disconnected
        break; %we exit.
    end
    
    [G, RN, is_exit] = clean_network(G); %then remove single nodes
    
    if(is_exit)
        %we removed either the sink or source, thus we exit.
        break;
    end
    
    k=k+1;
end


