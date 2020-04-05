function figure_5(fig_config)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% FIGURE 3: ENTROPY vs. pruned links (L) (or time)
%% for different strategies / gamma values
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Options:
is_eps = fig_config.is_eps; %for EPS export (vectorial fraphics)
set(0, 'DefaultFigureRenderer', 'painters');

% Select configs to draw:
% recall: results.infos = [size, beta, gamma, strategy]
% strategy is: 0 (random), 1 (weakest link), 2 (strongest link)
% config is [size, beta];
configs = fig_config.net_size; %which configs should we be browsing in this figure?

%Browse 'result' repository and plot a figure per simulation file:
fprintf(1,'browse ''results'' folder...');
D = dir(fig_config.results_folder);
n = size(D,1); %number of files
fprintf(1,'ok\n');

fprintf(1,'retrieve info...\n');
results.infos = [];
ked = 1;
for k=3:n
    %LOAD FILE AND GATHER INFOS------
    load(strcat(fig_config.results_folder, '/', D(k).name));
    fprintf(1, 'load %s...', D(k).name);
    R = deserialize(R_ser);
    
    %Group by parameters:
    for kk=1:size(R,2)
        if(strcmp(R{kk}.config, 'UCM'))
            %Build final index structure:
            A(kk,1) = R{kk}.n_nodes;
            A(kk,2) = R{kk}.beta;
            A(kk,3) = R{kk}.gamma;
            A(kk,4) = R{kk}.strategy; %evolution strategy
            
            %Append to larger structure:
            results.total_flux{ked} = R{kk}.entropy;
            ked = ked +1;
        end
    end
    
    if(strcmp(R{kk}.config, 'UCM')) %only kept UCM structure.
        %Append to final structure:
        results.infos = [results.infos; A];
    end
    fprintf(1, 'ok\n', D(k).name);
end

clear R_ser R
fprintf(1,'ok\n');

sizes = unique(results.infos(:,1));
betas = unique(results.infos(:,2));
gammas = unique(results.infos(:,3));
strategies = unique(results.infos(:,4));

n_sizes = numel(sizes);
n_betas = numel(betas);
n_gamma = numel(gammas);
n_strat = numel(strategies);

fprintf(1,'found %d sizes\n', n_sizes);
fprintf(1,'found %d betas values\n', n_betas);
fprintf(1,'found %d gamma values\n', n_gamma);
fprintf(1,'found %d strategies values\n', n_strat);

fprintf(1,'build figure...');

%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% FIGURE 1 (upper pannel)
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Define colors:
mcolors = ['b','r','g','c','m','y','k'];    %assuming 7 gamma values max
msymbols = ['*','o','x','s','d','+','.'];   %assuming 7 values max

%Group by gammas and strategies:
figure;
ked = 1;

for j=1:n_betas
    for i=1:n_gamma
        subplot(n_betas, n_gamma, ked);
        hold on;
        for s=1:n_strat
            
            idx0 = results.infos(:,1) == configs(1); %gather current size values
            idx1 = results.infos(:,3) == gammas(i); %gather current gamma values
            idx2 = results.infos(:,2) == betas(j); %gather wanted beta value
            idx3 = results.infos(:,4) == strategies(s); %gather wanted strategy
            fidxs = idx0 & idx1 & idx2 & idx3; %final indexs
            idxs = find(fidxs);
            
            %Extract current flux values:
            for z=1:numel(idxs)
                Q_ = results.total_flux{idxs(z)}; %retrieve entropy
                %Q_ = Q_ / max(Q_); %for normalization
                Q_ = Q_ / Q_(1); %for normalization
                %plot(Q_, strcat(mcolors(s), msymbols(s)));
                if(z==1)
                    hhh(s) = plot(Q_, strcat(mcolors(s), '-'));
                else
                    plot(Q_, strcat(mcolors(s), '-'));
                end
            end
            leg{s} = sprintf('strategy = %d', strategies(s));
        end
        %switch to loglog scale:
        set(gca,'XScale','log','YScale','log');
        if(ked == 1 || ked == 4 || ked == 7)
            ylabel('normalized Entropy');
        end
        
        if(ked == 7 || ked == 8 || ked == 9)
            xlabel('step');
        end
        if(configs == 400)
            xlim([0, 650]);
            ylim([1e-1, 1]);
        else
            if(configs == 900)
                xlim([0, 2e3]);
                ylim([1e-1, 1]);
            else
                if(configs == 1600)
                    xlim([0, 3.25e3]);
                    ylim([1e-1, 1.05]);
                end
            end
        end
        title(sprintf('%d nodes, \\beta = %.1f \\gamma = %.1f', configs(1), betas(j), gammas(i)));
        
        if(i==1 && j==1)
            legend(hhh, leg, 'Location', 'southwest');
        end
        ked = ked + 1;
    end
end
set(gcf,'Position',[100, 100, 1400, 800]);

%EXPORT FIGURE------
export_fig(gcf, is_eps, sprintf('EVOLUTION_Entropy_N=%dx%d', sqrt(configs(1)), sqrt(configs(1))));
fprintf(1,'Figure #1 (combined) dumped in the figures/ folder\n');
close all;



