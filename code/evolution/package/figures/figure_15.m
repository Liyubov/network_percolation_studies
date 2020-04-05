function figure_15(fig_config)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% FIGURE 15: derivative of flux (q) vs. time
%% for different strategies / gamma values and grouped by betas values.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Options:
is_eps = fig_config.is_eps; %for EPS export (vectorial fraphics)
set(0, 'DefaultFigureRenderer', 'painters');

% Select configs to draw:
% recall: results.infos = [size, beta, gamma, strategy]
% strategy is: 0 (random), 1 (weakest link), 2 (strongest link)
% config is [size, beta];
configs = fig_config.net_size; %which configs should we be browsing in this figure?

print_slope = 0; %if additional printing info is required

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
            results.total_flux{ked} = R{kk}.Q_;
            results.n_links{ked} = R{kk}.n_links;
            
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
fig_k = 1;

for i=1:n_gamma
    mat = [];

    for j=1:n_betas
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
                Q_ = results.total_flux{idxs(z)}; %retrieve degree_sequence
                Q_ = Q_ / max(Q_); %for normalization
                t = 1:numel(Q_);

                %Emperical derivative
                dQdL = diff(Q_) ./ diff(t);

                if(strategies(s) == 1 || strategies(s) == 0)
                    vec = [t(2:end); dQdL]';
                    A = [betas(j)*ones(size(vec,1),1), strategies(s)*ones(size(vec,1),1), vec];
                    mat = [mat; A];
                end
            end
        end
    end

    try
        idxS = mat(:,2) == 1; %pick strategy == 1
    catch
       keyboard;
    end

    for z = 1:size(betas,1)
        idxB = mat(:,1) == betas(z); %beta == 'z'
        curmat = mat(idxS & idxB, :);

        %get marker:
        mark(1) = mcolors(z);
        mark(2) = msymbols(i);

        %average over betas values
        clear vec;
        Ls = unique(curmat(:,3));
        for zz = 1:numel(Ls)
            idx = Ls(zz) == curmat(:,3);
            vec(zz,:) = [Ls(zz), mean(curmat(idx,4)), std(curmat(idx,4))];
        end

        %pick correct marker marker:

        hhh(ked) = plot(vec(:,1), vec(:,2), mark);
        S{ked} = sprintf('\\beta = %d, \\gamma = %.1f', betas(z), gammas(i));
        
        ked = ked + 1;
    end
end

set(gcf,'Position',[100, 100, 1400, 800]);

title(sprintf('%d nodes', configs(1)));

set(gca,'XScale','log','YScale','log');

if(configs == 400)
    xlim([1, 10^2.8]);
    ylim([-10^0, -10^-10.5]);
else
    if(configs == 900)
        xlim([1, 10^3.25]);
        ylim([-10^0, -10^-12]);
    else
        if(configs == 1600)
            xlim([1, 10^3.6]);
            ylim([-10^0, -10^-13.5]);
        end
    end
end

ylabel('dQ/dt');
xlabel('t');

if(print_slope)
    if(configs == 900)
        %add original line for slope estimation:
        x = 2:10^1.8;
        loglog(x, -10^-8.25*x.^2,'k');
        
        %add additional graphic details:
        line([6, 15], [-10^-5.9, -10^-5.9], 'Color', 'k', 'LineStyle',':');
        line([6, 6],  [-10^-5.9, -10^-6.7], 'Color', 'k', 'LineStyle',':');
        text(5.5, -10^-5.7, '-2','FontSize',12);
    else
        %add original line for slope estimation:
        x = 2:10^1.3;
        loglog(x, -10^-7.25*x.^2,'k');
        
        %add additional graphic details:
        line([6, 15], [-10^-4.9, -10^-4.9], 'Color', 'k', 'LineStyle',':');
        line([6, 6],  [-10^-4.9, -10^-5.7], 'Color', 'k', 'LineStyle',':');
        text(5.5, -10^-4.7, '-2','FontSize',12);
    end
end

legend(hhh, S);
        
%EXPORT FIGURE------
export_fig(gcf, is_eps, sprintf('EVOLUTION_dQdt_grouped__N=%dx%d', sqrt(configs(1)), sqrt(configs(1))));
fprintf(1,'Figure #15 (combined) dumped in the figures/ folder\n');
close all;


                
                

