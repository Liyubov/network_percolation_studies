function G = remove_loops(G)
%remove loops

tot = trace(G);

if(tot > 0)
    s = size(G); 
    index = 1:s(1)+1:s(1)*s(2);
    G(index) = 0; %empty diagonal
end

fprintf(1, 'removed %d links (self-loops)\n', tot);