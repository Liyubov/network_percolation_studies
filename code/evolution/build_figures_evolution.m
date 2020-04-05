function build_figures_evolution()
% Build Evolution figures of interest and dump them into /figures folder.

fig_config.results_folder = 'results';
fig_config.is_eps = 1;
fig_config.net_size = 1600;

addpath('package/');
addpath('package/figures');

fprintf(1,'(EVOLUTION) : entropy vs. pruned links (L) for all betas\n');
figure_5(fig_config);
fprintf(1,'(EVOLUTION) : dQ/dL vs. ''L'' grouped by betas values\n');
figure_15(fig_config);
fprintf(1,'(EVOLUTION) : total flux vs. aging for all betas\n');
figure_13(fig_config);


rmpath('package/figures');
rmpath('package/');

