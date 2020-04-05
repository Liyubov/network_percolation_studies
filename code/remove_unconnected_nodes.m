function G = remove_unconnected_nodes(G)
%remove unconnected nodes

idx = find(all(G == 0, 2));

if(isempty(idx) == 0)
    G(idx, :) = [];
    G(:, idx) = [];
    fprintf(1, 'removed %d unconnected nodes\n', numel(idx));
else
    fprintf(1, 'removed %d unconnected nodes\n', 0);
end

