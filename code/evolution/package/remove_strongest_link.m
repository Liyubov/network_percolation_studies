function [netw, RL, bad_news] = remove_strongest_link(netw)
%Remove the link that has the strongest amount of flux.
%We also remove any node that has only one link, 
%due to the conservation of mass.

RL = [];

bad_news = 0;
V = max(max(netw.fluxes)); %Find value of strongest POSITIVE flow
if(isempty(V))
    bad_news = 1;
    return;
else
    [r, c] = find(netw.fluxes==V); %find its corresponding index
end

if(size(r,1) > 1)
    %ouch! we have several similar identical minimal fluxes values!
    %then only use the first one:
    r = r(1);
    c = c(1);
end

[netw, RL] = remove_link(netw, r, c); %then remove link
