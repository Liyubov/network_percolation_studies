function R = gather_evol_statistics(G, R, RN, RL, k)
%gather statistics related to the evolution process

if(k == 1)
    %Copy initial parameters:
    R.n_nodes = G.n_nodes;
    R.gamma = G.gamma;
    R.strategy = G.strategy;
    R.beta = G.beta;
    
    %Save source and drain indexes:
    R.source_idx = G.inflow;
    R.sink_idx = G.outflow;
    R.dis_source_sink = G.distance_SS;
    R.distance_switch = G.distance_switch;
    
    %degree of the source and drain:
    R.degree_source = G.degree(G.inflow);
    R.degree_drain = G.degree(G.outflow);
    R.is_warning = G.is_warning;
    
    R.n_nodes_evol(k) = G.n_nodes;
    R.n_links(k) = size(nonzeros(G.adjm),1)/2; %return the number of links (triangular matrix thus /2)
    R.avg_flux(k) = mean(nonzeros(G.fluxes(~isnan(G.fluxes)))); %compute average flux ?
    R.Q_(k) = -sum(G.fluxes(G.inflow,~isnan(G.fluxes(G.inflow,:)))); %compute nicolaides quantity: flux from inflow node only and irrigating
    R.q{k} = G.fluxes(G.fluxes > 0); %only keep nonzeros positive fluxs
    R.degreesequence{k} = G.degree;
    R.potentials{k} = G.Potentials;
    %R.entropy(k) = 1/R.n_nodes*log(nchoosek((vpi(R.n_nodes*(R.n_nodes-1))/2),vpi(R.n_links(k)))); %entropy calculation from Burda paper
    %This should reflect the number of connected components:
    R.component_value(k) = sum((round(eig((eye(size(G.adjm)) - G.adjm))*1000)/1000 == 0));
else
    %we additionnaly want to save some info on each deleted node ('RN' structure) and each deleted link ('RL' structure), ie.:
    %- distance (in number of nodes) from source and drain
    %- degree
    %- Potential
    R.removed_nodes_list{k} = RN;   %'RN' holds the removed nodes info.
    R.removed_links_list{k} = RL;   %'LN' holds the removed links info.
    
    R.n_links(k) = size(nonzeros(G.adjm),1)/2; %return the number of links (triangular matrix thus /2)
    R.avg_flux(k) = mean(nonzeros(G.fluxes(~isnan(G.fluxes)))); %compute average flux ?
    R.Q_(k) = -sum(G.fluxes(G.inflow,~isnan(G.fluxes(G.inflow,:)))); %compute nicolaides quantity: flux from inflow node only and irrigating
    R.q{k} = G.fluxes(G.fluxes > 0); %only keep nonzeros positive fluxs
    R.degreesequence{k} = G.degree;
    R.potentials{k} = G.Potentials;
    R.n_nodes_evol(k) = size(G.adjm,1);
    %R.entropy(k) = 1/R.n_nodes_evol(k)*log(nchoosek((vpi(R.n_nodes_evol(k)*(R.n_nodes_evol(k)-1))/2),vpi(R.n_links(k)))); %entropy calculation from Burda paper
    %This should reflect the number of connected components:
    R.component_value(k) = sum((round(eig((eye(size(G.adjm)) - G.adjm))*1000)/1000 == 0));
end


%should we save the adjacency matrix?

%R.entropy(k) = 1/Nodes*log(nchoosek((vpi(Nodes*(Nodes-1))/2),vpi(Links))); %entropy calculation from Burda paper

%Fig.1(bottom) derivative of flux: 
%Flux = G.fluxes %gets fluxes for current number of links L
%Links = G.Links
%derivFlux = flux(Llinks) - flux(Links-1) %derivative of flux


%Fig. 2. To detect regime, when the number of links reaches the number of nodes:
%Nodes = G.Nodes
%Links = G.Links
%Diff = Links-Nodes %difference between number of links and nodes (after each iteration of the code)

%Fig. 5 Entropy:
%R.entropy(k) = 1/Nodes*log(nchoosek((vpi(Nodes*(Nodes-1))/2),vpi(Links))); %entropy calculation from Burda paper




