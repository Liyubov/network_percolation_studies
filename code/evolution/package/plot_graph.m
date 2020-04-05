function plot_graph(G)

%Plot Graph 'G'
h = figure;
option = 1; %1 if plotted with nodes degree distribution.

set(h,'Color',[1 1 1]);
map=colormap('cool');

%Graphical setup:
linew = 1; %default width of the lines
color_links = 'k';

if(option == 1)
    subplot(1,2,1)
end

hold on;

%Draw Links first:
for i=1:size(G.adjm,1)
    
    %Plot line between two nodes:
    xy=G.XY(i,:);
    
    %find connected nodes (adk matrix):
    idx = find(G.adjm(i,:));
    S = size(idx,2); %Size of the node.
    
    %Gather coordinates of other nodes:
    list = G.XY(idx,:);
    
    %repmat according to S:
    D = repmat(xy, 2*S, 1);
    
    %Wire nodes with a tick line:
    idx = 2:2:2*S;
    D(idx,:) = list;
    line(D(:,1), D(:,2), 'Color', color_links, 'LineWidth', linew);
end

%Then plot Nodes on the top layer:
for i=1:size(G.adjm,1)
    
    %Plot line between two nodes:
    xy=G.XY(i,:);
    
    %find connected nodes (adk matrix):
    idx = find(G.adjm(i,:));
    S = size(idx,2); %Size of the node.

    %Then place node, according to 'S':
    [sized, colored] = get_size(S, map);
    plot(xy(1), xy(2), 'b.', 'Markersize', sized, 'Color', colored);
end


axis square
title(sprintf('%dx%d network, alpha=%.2f', size(G.layout,2), size(G.layout,2), G.alpha));

if(option ==1)
    subplot(1,2,2);
    X = min(G.degree):size(G.layout,2);
    N = histc(G.degree, X);
    bar(X-0.5, N, 'histc');
    axis([X(1)-0.5, X(end)+0.5, min(N), max(N)+5]);
    %hist(G.degree, 20);
    title(sprintf('degree distribution, alpha=%.2f', G.alpha));
end
set(h, 'Position', [50, 100, 1000, 600]);


function [sized, color] = get_size(S, map)
%return the size and color of the marker, according to 'S':

% edge weights ==============
if S<2
    color=map(8,:);
    sized=10;
elseif S>=2 && S<3
    color=map(2*8,:);
    sized=20;
elseif S>=3 && S<4
    color=map(3*8,:);
    sized=30;
elseif S>=4 && S<5
    color=map(4*8,:);
    sized=40;
elseif S>=5 && S<6
    color=map(5*8,:);
    sized=50;
elseif S>=6 && S<7
    color=map(6*8,:);
    sized=60;
elseif S>=7 && S<8
    color=map(7*8,:);
    sized=70;
elseif S>=8
    color=map(8*8,:);
    sized=80;
end

