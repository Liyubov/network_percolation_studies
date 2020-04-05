function A = importNet(filename)
%create graph corresponding to filename:

G = load(filename);

mm = min(G);
if(mm(1) == 0 || mm(2) == 0)
    %is '0' based, since MATLAB uses a '1' based numbering, 
    %we add '1' to all nodes indexes:
    G = G+1;
end

maxed = max(max(G));

A = zeros(maxed, maxed);

%create the adjacency matrix:
for i=1:size(G,1)
    idx = G(i,:);
    A(idx(1), idx(2)) = 1;
    A(idx(2), idx(1)) = 1;
end

%spy(A)

