%build figures:

set(0, 'DefaultFigureRenderer', 'painters');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Figure 1: potential distribution at t=0 (averaged)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%FIGURE_1

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Figure 2: total flux averaged and normalized
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
FIGURE_2('results--23-Mar-2020-99-Belgium trains.mat');

%for plotting 2 strategies on the same plot use:
%FIGURE_2_MULTI( 'results--23-Mar-2020-99-Belgium trains.mat', ...
%                'random', ...
%                'results--19-Mar-2020-26-Belgium trains.mat', ...
%                'darwinian', ...
%                [1, 65, 0.2, 1.05]);


