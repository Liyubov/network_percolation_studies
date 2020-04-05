function G = remove_isolated_nodes(G)
%Removed isolated nodes of graph G
%As we removed isolated nodes, we then create new isolated nodes... thus
%we need a loop to remove all isolated nodes (ie, we remove "chains"):

total_removed = 0;

%find rows that contains only 1 '1':
is_isolated = check_isolated(G);
while(is_isolated > 0)
    
    idx = find(sum(G,2) == 1);
    
    %remove both colum and rows for these indexes:
    G(:, idx) = [];
    G(idx, :) = [];
    
    total_removed = total_removed + numel(idx);
    
    %check for new isolated nodes:
    is_isolated = check_isolated(G);
end

fprintf(1, 'removed %d (isolated) nodes\n', total_removed);

function iso = check_isolated(G)

iso = size(find(sum(G,2) == 1), 1);




