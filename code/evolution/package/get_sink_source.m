function [in, out, d] = get_sink_source(adjm, distance)
%check the nodes at distance 'distance' from node 'in'.
%This can be time consuming! ==> need a C/C++ implementation?
%also see: 'Breadth-first_search'

%Randomize vector at the initial stage:
R = randperm(size(adjm,1));

%Pick two random nodes:
in = R(1);
out = R(2);

%Then compute distance between the two:
if(distance ~= 0) %then use 'min_distance'
    d = find_dis(adjm, in, out); %<== this is SUPER fast!!!!
    %d = dijkstraM(adjm, in, out); %<== this is SUPER slow!!!! (don't use, except for testing and comparison purposes)

    %if no link between source and sink, or distance doesn't match
    %requirements ==> raise an error by setting d = -1;
    if(isinf(d) || d < distance)
        d = -1;
    end
else
    %distance == 0: we don't care!
end

%***** Testing dijkstra:
% for i=1:size(adjm,1)
%     sp(i) = dijkstra(adjm, in, i);
% end
%to compare both algorithm then use: [nodes, find(sp==3)'];
%it gives simulare results, the above one is way faster, ie, for one
%execution on a 40*40 network (adjm = 1600*1600):
%speed above is: 0.009880 seconds.
%(speed for a 15*15 is 0.008855 seconds, roughly the same).
%ONE execution of dijkstra is: 2.424735 (40*40) (or 

function [spcost] = dijkstraM(costmatrix, s, d)
% uses sparse matrix and ingores paths to save time and memory for large networks
% calculates totals cost only

% This is an implementation of the dijkstra�s algorithm, which finds the
% minimal cost path between two nodes. It�s supoussed to solve the problem on
% possitive weighted instances.

% inputs:
% n*n costmatrix, can be sparse for nonexisting links
% n: the number of nodes in the network;
% s: source node index;
% d: destination node index;

%For information about this algorithm visit:
%http://en.wikipedia.org/wiki/Dijkstra%27s_algorithm

%This implementatios is inspired by the Xiaodong Wang's implememtation of
%the dijkstra's algorithm, available at
%http://www.mathworks.com/matlabcentral/fileexchange
%file ID 5550

%Author: Jorge Ignacio Barrera Alviar. April/2007
%Edited Dirk Stelder September/2013

%I think you could speed up Dirk Stelder's solution by replacing the first for 
%loop (between "candidate=[];' and "[u_index u]=min(candidate);")
%by the statement
%[u_index u] = min(1 ./ (S==0) .* dist);

n=size(costmatrix,1);
S(1:n) = 0; % vector, set of visited vectors
dist(1:n) = inf; % it stores the shortest distance between the source node and any other node;
prev(1:n) = n+1; % Previous node, informs about the best previous node known to reach each network node

dist(s) = 0;

kkk = 1; %counter to test for a link between source and sink

while sum(S)~=n
    candidate=[];
    for i=1:n
        if S(i)==0
            candidate=[candidate dist(i)];
        else
            candidate=[candidate inf];
        end
    end
    %can be replaced by: 
    %[u_index u] = min(1 ./ (S==0) .* dist);
    
    [u_index u]=min(candidate);
    S(u)=1;
    for i=1:n
        if costmatrix(u,i)>0 % ignore non-existing links (=zero in sparse matrices) to save time and memory
            if(dist(u)+costmatrix(u,i))<dist(i)
                dist(i)=dist(u)+costmatrix(u,i);
                prev(i)=u;
            end
        end
    end
    
    kkk = kkk+1;
    if(kkk > n+1)
        %Error source and sink arent connected...
        %Quit!
        d = -inf;
        break;
    end
end

if(d == -inf)
    spcost = d;
else
    spcost = dist(d);
end

