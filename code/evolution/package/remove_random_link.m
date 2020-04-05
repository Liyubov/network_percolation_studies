function [netw, RL, bad_news] = remove_random_link(netw)
%Remove the link that has the smallest amount of flux.
%We also remove any node that has only one link, 
%due to the conservation of mass.

RL = [];

bad_news = 0;

%retrieve the number of links (size(nonzeros(netw.adjm),1)/2) from the
%adjacency matrix, and pick a random one (see end of the page):
[a,b] = find(netw.adjm); %it doesnt matter if matrix is symmetric, since we pick randomly

if(isempty(a))
    bad_news = 1;
    return;
else
    %assign random link:
    idx = randi(size(a,1));
    r = a(idx);
    c = b(idx);
end

[netw, RL] = remove_link(netw, r, c); %then remove link

