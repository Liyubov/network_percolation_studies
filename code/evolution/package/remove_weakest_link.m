function [netw, RL, bad_news] = remove_weakest_link(netw)
%Remove the link that has the smallest amount of flux.
%We also remove any node that has only one link, 
%due to the conservation of mass.

RL = [];

bad_news = 0;
V = min(netw.fluxes(netw.fluxes > 0)); %Find value of weakest POSITIVE flow
if(isempty(V))
    bad_news = 1;
    return;
else
    [r, c] = find(netw.fluxes==V); %find its corresponding index
end

% tmp = netw;
% 
% if(isempty(r))
%     keyboard;
% end

if(size(r,1) > 1)
    %ouch! we have several similar identical minimal fluxes values!
    %then remove the first one:
    r = r(1);
    c = c(1);
end

% %Debug:
% if(any(netw.degree == 1))
%     keyboard;
%     error('one degree exist :(!');
% end

[netw, RL] = remove_link(netw, r, c); %then remove link

% %Debug:
% if(any(netw.degree <= 0))
%     keyboard;
%     error('Negative or null degrees!');
% end

