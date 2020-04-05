function [G, removed_node, bad_news] = remove_node(G, idx)
%Remove node with index 'idx' from network 'G'

bad_news = 0;
if(idx == G.inflow)
    bad_news = 1; %Oops target is the inflow node
    %return
end

if(idx == G.outflow)
    bad_news = 1; %Oops target is the outflow node 
    %return;
end

%Additional info
removed_node.degree = G.degree(idx);
removed_node.distance_source = find_dis(G.adjm, idx, G.inflow);
removed_node.distance_drain = find_dis(G.adjm, idx, G.outflow);

%Keep track of inflow and outflow nodes indexes:
%remove this and keep size of all matrices!!
if(G.inflow > idx)              %Check if idx is after the inflow position,
    G.inflow = G.inflow - 1;    %then update inflow index
end

if(G.outflow > idx)             %Check if idx is after the outflow position,
    G.outflow = G.outflow - 1;  %then update outflow index
end

G.Potentials(idx) = [];     %Remove nodes' potential from potential list

%Get indexes of connected nodes in 'idexs':
idexs = find(G.adjm(idx,:)); %Find connected links.

%Remove the links:
if(~isempty(idexs))
    for i=1:size(idexs,1)
        G = remove_link(G, idx, idexs(i));
    end
end

%Then remove from distance matrix:
G.dis_eucl(idx,:) = [];     %Remove corresponding row
G.dis_eucl(:, idx) = [];    %Remove corresponding column

%Remove node from adjacency matrix:
G.adjm(idx,:) = [];     %Remove corresponding row
G.adjm(:, idx) = [];    %Remove corresponding column

%From fluxes matrix:
G.fluxes(idx,:) = [];   %Remove corresponding row
G.fluxes(:, idx) = [];  %Remove corresponding column

%Degree table:
G.degree(idx) = [];     %Remove from degree table
