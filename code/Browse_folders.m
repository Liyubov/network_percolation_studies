function Browse_folders()
%load folders and export various information:

addpath power-law-master/

%extract_info('../power-US-Grid/power-US-Grid_2.mtx', 'US-power-grid');
%extract_info('../bn-fly-drosophila_medulla_1/bn/bn-fly-drosophila_medulla_1.edges', 'Drosophila-medulla');
%extract_info('../ia-crime-moreno/ia-crime-moreno_2.edges', 'Crime');
%extract_info('../bn-mouse-kasthuri_graph_v4/bn-mouse-kasthuri_graph_v4.edges', 'mouse-kasthuri');
%extract_info('../web-spam/web-spam_2.mtx', 'web-spam_challenge');
%extract_info('../road-minnesota/road-minnesota_2.mtx', 'road_minnesota');

%BIG files:
extract_info('../ca-AstroPh.txt/CA-AstroPh_2.txt', 'arvix_astroph'); %too big to load :-/

%Networks with weird adjacency matrix:
%extract_info('../web-EPA/web-EPA.edges', 'web-epa_linking'); %isolated cluster of 4 nodes! :(
%extract_info('../ca-Erdos992/ca-Erdos992_2.mtx', 'Erdos_network'); %weird connection stuff :(
%extract_info('../petster-friendships-hamster/petster-friendships-hamster_2.edges', 'hamster_petster'); %isolated clusters
%extract_info('../netscience/netscience_2.mtx', 'net_science'); %wtf??
%extract_info('../inf-openflights/inf-openflights_2.edges', 'open_flights'); %isolated clusters

% closing stuff:
rmpath power-law-master/


function extract_info(filename, txt_flag)
fprintf(1, "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n");
fprintf(1, "%% %s\n", txt_flag);
fprintf(1, "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n");
G = importNet(filename);
fprintf(1, 'Total number of nodes before processing: %d\n', size(G,1));
G = remove_loops(G); %remove loops
G = remove_isolated_nodes(G); %then remove isolated nodes
G = remove_unconnected_nodes(G); %then remove unconnected nodes
fprintf(1, 'Total number of nodes after processing: %d\n', size(G,1));

% then plot and export graph:
set(0, 'DefaultFigureRenderer', 'painters');
h1 = figure('Visible', 'off'); %will not show the figure but dump it on folder instead
subplot(1, 2, 1);
plot( graph(G) );
title(txt_flag);
subplot(1, 2, 2);
spy(G);
snamed1 = strcat('Figure_', txt_flag, '_Graph.tiff');
print(h1,'-dtiff',snamed1);
%snamed1 = strcat('Figure_', txt_flag, '_Graph.eps');
%print(h1,'-dpsc',snamed1);

% plot and estimate power-law coefficient:
% https://github.com/XikunHuang/power-law/blob/master/plfit.m
degrees = sum(G,2);
[gamma, xmin, L] = plfit(degrees);

% plot and export fit:
h2 = figure('Visible', 'off'); %will not show the figure but dump it on folder instead
hist(degrees,20);
hold on;
x = min(degrees):0.5:max(degrees);
plot(x, 4e4*x.^-gamma, 'Linewidth', 2, 'Color', 'r'); %with scaling factor (arbitrary)
%set(0, 'defaulttextinterpreter', 'latex');
text( 12, 1400, strcat('\gamma=', num2str(gamma)) , 'Fontsize', 15);
xlim([min(degrees), max(degrees)]);
[b,a] = hist(degrees,20);
ylim([0, max(b)]);
xlabel('degrees');
ylabel('frequency');
snamed1 = strcat('Figure_', txt_flag, '_hist.tiff');
print(h2,'-dtiff',snamed1);
%snamed1 = strcat('Figure_', txt_flag, '_hist.eps');
%print(h2,'-dpsc',snamed1);



