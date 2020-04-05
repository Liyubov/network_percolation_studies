function [in, out, L] = fix_sink_source(adjm, L, net_size, XY)
%check the nodes at distance 'distance' from node 'in'.
%square lattice (the case when each site is connected to 4 its neighbors, except for border sites). 
%If the lattice covers the square (1,1) to (N,N), then the source and the drain nodes should be 
%located at points (N/2-L,N/2) and (N/2+L,N/2), where 2L is the distance between them.

mid_node = sqrt(size(adjm,1))/2; %median node 
center = (net_size +1) / 2; %the network is on [0, x]

if(mid_node ~= center)
    error('spacing between nodes =~ 1, please change the lattice size');
else
    %can use exact case match:
    in = find(XY(:,1) == center - L & XY(:,2) == center); %for an exact match of source node
    out = find(XY(:,1) == center + L & XY(:,2) == center); %for an exact match of sink node
end
