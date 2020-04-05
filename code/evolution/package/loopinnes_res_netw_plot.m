

function loopinnes_res_netw_plot(arraydegrees)
s = size(arraydegrees); %number of attacks  
num_iterat = s(1);

%% plot loopinness (number of nodes with deg=2 in each graph)
loopin_array = zeros(num_iterat); %array of loopinness
interval = [1:num_iterat]; %interval for plotting


for i=1:num_iterat %loop through all realisations
    for i = 1:index_iterat
        disp('degree sequence for a graph')
        arraydegrees(i,:)
        loopin_array(i) = sum(arraydegrees(i,:) == 2);
    end
    figure;
    plot(interval, loopin_array, 'o-');%%plot(connectivityarray(i,:),'o-')
    %set(gca, 'XScale', 'log') %log scale for y 
    %set(gca, 'YScale', 'log') %log scale for y  % %plot(t,Prop_t_num_inv,'go'); %plot analytic formula and numerical inverse on the same plot
    xlabel(' number of attacks ') %make is for different realisations
    ylabel('Loopinness')
    hold on;
end
hold off;

end