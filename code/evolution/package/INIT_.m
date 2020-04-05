%INIT_ script that handles all initializations-------------

%-----defines strategy 'S':
% '0' is 'random' (removes random link)
% '1' is 'minimal' (removes minimal link)
if(strcmp(strategy,'random') == 1)
    fprintf(1,'''*%s'' strategy for evolution\n', strategy);
    S = 0;
else
    if(strcmp(strategy,'minimal') == 1)
        fprintf(1,'''*%s'' strategy for evolution\n', strategy);
        S = 1;
    else
        if(strcmp(strategy,'strongest') == 1)
            fprintf(1,'''*%s'' strategy for evolution\n', strategy);
            S = 2;
        else %default strategy:
            fprintf(1,'''*%s'' strategy for evolution \n', strategy);
            S = 0;
        end
    end
end

%-----check for distance choice:
if(distance_switch)
    %ensure it is a lattice config:
    if(strcmp(config,'lattice') == 0)
        error('''distance_switch'' is only available for lattice configuration');
    else
        fprintf(1,'*using specific distance (d=%d) betwen inflow and outflow node (switch on)\n', distance);
    end
else
    fprintf(1,'*using minimal distance (d=%d) betwen inflow and outflow node (switch off)\n', distance);
end

%-----compute the total number of sims:
total_num_sims = length(n_nodes) * length(gamma) * length(beta) * n_sims;
fprintf(1, 'Total number of simulations is %d\n', total_num_sims);
pause(1);

