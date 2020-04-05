function FIGURE_2(filename)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Figure 2: Total flux (averaged) and normalized
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load(strcat('results\',filename));
R = deserialize(R_ser);
clear R_ser

maxed = 0;
maxedp = 0;

for i=1:size(R,2)
    %tp = (1:size(R{i}.n_links,2)) ./ R{i}.n_links; %normlized time: tp = t / n_links
    M{i}.tp = (1:size(R{i}.n_links,2)) .* R{i}.n_links; %normalized time: tp = t / (n_links)^-1    
    M{i}.t = 1:size(R{i}.n_links,2);
    M{i}.total_flux = R{i}.Q_ ./ R{i}.Q_(1);
    
    %for t value:
    if(numel(M{i}.t) > maxed)
        maxed = numel(M{i}.t); %max evolution time
    end
    
    %for t norm value:
    if(max(M{i}.tp) > maxedp)
        maxedp = max(M{i}.tp); %max evolution time
    end
    
end

%then average 't' version:
for i=1:maxed
    for j=1:size(M,2)
        if( numel(M{j}.total_flux) >= i )
            tQ(j,i) = M{j}.total_flux(i);
        else
            tQ(j,i) = NaN;
        end
    end
end

for i=1:maxed
    Qmean(i) = mean( tQ(~isnan(tQ(:,i)),i) );
end


h1 = figure;
hold on;
%first: plot all trajectories:
for i=1:size(tQ,1)
    plot(tQ(i, ~isnan(tQ(i,:))), 'b');
end

plot(Qmean, 'k-', 'Linewidth', 2.0); %average

%set loglog scale:
set(gca,'XScale','log','YScale','log');

xlabel('time');
ylabel('Q / Q(t=0)');
ylim([0, 1.05]);

set(gcf, 'Position', [10,10,500,300]);

file_name_eps = sprintf('figures/%s.eps', filename);
print(h1,'-dpsc', file_name_eps);

close all
