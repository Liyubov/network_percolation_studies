function FIGURE_2_MULTI(filename1, strategy1, filename2, strategy2, axes_limits)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Figure 2 MULTI: Total flux (averaged) and normalized
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% FILENAME1
load(strcat('results\',filename1));
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
            tQ_1(j,i) = M{j}.total_flux(i);
        else
            tQ_1(j,i) = NaN;
        end
    end
end

for i=1:maxed
    Qmean_1(i) = mean( tQ_1(~isnan(tQ_1(:,i)),i) );
end

clear M


%% FILENAME2
load(strcat('results\',filename2));
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
            tQ_2(j,i) = M{j}.total_flux(i);
        else
            tQ_2(j,i) = NaN;
        end
    end
end

for i=1:maxed
    Qmean_2(i) = mean( tQ_2(~isnan(tQ_2(:,i)),i) );
end

clear M

%%PLOT FIGURE

h1 = figure;
hold on;
%first: plot all trajectories:
for i=1:size(tQ_1,1)
    if(strcmp(strategy1,'random'))
        plot(tQ_1(i, ~isnan(tQ_1(i,:))), 'b');
    else
        plot(tQ_1(i, ~isnan(tQ_1(i,:))), 'r');
    end
end

if(strcmp(strategy1,'random'))
    plot(Qmean_1, 'b--', 'Linewidth', 2.0); %average
else
    plot(Qmean_1, 'r--', 'Linewidth', 2.0); %average
end

%set loglog scale:
set(gca,'XScale','log','YScale','log');

xlabel('time');
ylabel('Q / Q(t=0)');

axis(axes_limits)

%first: plot all trajectories:
for i=1:size(tQ_2,1)
    if(strcmp(strategy2,'random'))
        plot(tQ_2(i, ~isnan(tQ_2(i,:))), 'b');
    else
        plot(tQ_2(i, ~isnan(tQ_2(i,:))), 'r');
    end
end

if(strcmp(strategy2,'random'))
    plot(Qmean_2, 'b--', 'Linewidth', 2.0); %average
else
    plot(Qmean_2, 'r--', 'Linewidth', 2.0); %average
end

%set loglog scale:
set(gca,'XScale','log','YScale','log');

xlabel('time');
ylabel('Q / Q(t=0)');

set(gcf, 'Position', [10,10,500,300]);

file_name_eps = sprintf('figures/%s.eps', strcat(filename1,'_MULTI'));
print(h1,'-dpsc', file_name_eps);

close all
