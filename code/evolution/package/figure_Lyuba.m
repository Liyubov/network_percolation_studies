function figure_Lyuba()
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% FIGURE 1: Flux distribution
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Options:
is_eps = 1; %for EPS export (vectorial fraphics)

%Browse 'result' repository and plot a figure per simulation file:
fprintf(1,'browse ''results'' folder...');
D = dir('../results');
n = size(D,1); %number of files
fprintf(1,'ok\n');

fprintf(1,'retrieve info...');
results.infos = [];
ked = 1;
for k=3:n
    %LOAD FILE AND GATHER INFOS------
    load(strcat('../results/',D(k).name));
    R = deserialize(R_ser);
    
    %Group by parameters:
    for kk=1:size(R,2)
        if(strcmp(R{kk}.config, 'UCM'))
            %build final structure:
            A(kk,1) = R{kk}.n_nodes;
            A(kk,2) = R{kk}.beta;
            A(kk,3) = R{kk}.gamma;
            results.flux{ked} = R{kk}.q;
            ked = ked +1;
        end
    end
    
    if(strcmp(R{kk}.config, 'UCM'))
        %Append to final structure:
        results.infos = [results.infos; A];
    end
end
clear R_ser R
fprintf(1,'ok\n');

sizes = unique(results.infos(:,1));
betas = unique(results.infos(:,2));
gammas = unique(results.infos(:,3));

n_sizes = numel(sizes);
n_betas = numel(betas);
n_gamma = numel(gammas);

fprintf(1,'found %d sizes\n', n_sizes);
fprintf(1,'found %d betas values\n', n_betas);
fprintf(1,'found %d gamma values\n', n_gamma);

fprintf(1,'build figure...');

%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% FIGURE 1 (upper pannel)
%%%%%%%%%%%%%%%%%%%%%%%%%%%

%group by gammas and betas:
fix_beta = -1; %pick your beta values
fix_gamma = [1.5, 2, 2.5, 3.0, 4.0, 5.0, 6.0]; %pick your gamma values

zed = 1;

for i=1:numel(fix_gamma)
    idx1 = results.infos(:,3) == fix_gamma(i); %gather current gamma values
    idx2 = results.infos(:,2) == fix_beta; %gather wanted beta value
    flux_idx = idx1 & idx2; %get current flux
    %Extract current flux values:
    A = results.flux(flux_idx); %flux values for each realization
    %B = vertcat(A{:}); %whole collection

    named = sprintf('fluxes_gamma%.1f_beta%d.mat', fix_gamma(i), fix_beta);
    save(named,'A');  
end

% export_fig(h1, is_eps, 'figure_1_combined');
% fprintf(1,'Figure #1 (combined) dumped in the figures/ folder\n');
% close all;


