function plot_graph2(G)
%Return graphical function with G

%Plot Graph 'G'
h = figure;
hold on;

set(h,'Color',[1 1 1]);
map=colormap('cool');

%Graphical setup:
linew = 1; %default width of the lines
color_links = 'k';

%Draw Links first:
for i=1:size(G.adjm,1)
    
    %Plot line between two nodes:
    xy=G.XY(i,:);
    
    %Find connected nodes (adj matrix):
    idx = find(G.adjm(i,:));
    S = G.fluxes(i, idx); %Strenght of links
    
    %Gather coordinates of other nodes:
    list = G.XY(idx,:);
    
    %repmat according to S:
    D = repmat(xy, 2* size(idx,2), 1);
    
    %Draw links with size according to their flow:
    idx = 2:2:2*size(idx,2);
    D(idx,:) = list;
    for j=1:size(idx,2)
        %line(D(:,1), D(:,2), 'Color', color_links, 'LineWidth', linew);
        keyboard;
        line([xy(1), list(j,1)], [xy(2),list(j,2)], 'Color', color_links, 'LineWidth', S(j));
    end
end

%Then plot Nodes on the top layer:
for i=1:size(G.adjm,1)
    
    %Plot line between two nodes:
    xy=G.XY(i,:);
    
    %find connected nodes (adk matrix):
    idx = find(G.adjm(i,:));
    sized = 30; %Size of the node.

    %Then place node, according to 'S':
    if(i == G.inflow)
        plot(xy(1), xy(2), 'r.', 'Markersize', sized);
    else 
        if(i == G.outflow)
           plot(xy(1), xy(2), 'b.', 'Markersize', sized);
        else
            plot(xy(1), xy(2), 'k.', 'Markersize', sized);
        end
    end
end


axis square
title(sprintf('%dx%d network, alpha=%.2f', size(G.layout,2), size(G.layout,2), G.alpha));




