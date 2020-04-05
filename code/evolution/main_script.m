%Main file for the Complex network Project.
%Custom package.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INITS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%-----Distance between sink (outflow) and source (inflow) nodes:
distance = 4; %is the REQUESTED minimal distance (in number of nodes) between inflow and outflow node.
%for example: if distance = 4 then will only keep networks that have a distance >= 4 between inflow and outflow.
%special values:
%if distance == 0 then assign at random.
distance_switch = 0; %for lattice configuration only: switch=1 => will align the source and sink

%-----Folder inits
INIT_; %call the init script.

%ensure warnings are thrown for the following exceptions:
warning('on', 'MATLAB:SingularMatrix');
warning('on', 'MATLAB:nearlySingularMatrix');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SIMULATIONS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cur_idx = 0;

for k = 1:length(n_nodes) %for each network size
    for i = 1:length(gamma) %for each gamma value
        for j = 1:length(beta) %for each beta value
            %***** Run simulations *****
            if(is_parallel)
                cur_nodes = n_nodes(k);
                cur_gamma = gamma(i);
                cur_beta = beta(j);
                R_temp = cell(1,n_sims);
                
                parfor n = 1:n_sims
                    is_warning = 1;
                    while(is_warning == 1)
                        fprintf(1,'sim: N=%d, gamma=%.2f, beta=%.1f (%d/%d) ...', cur_nodes, cur_gamma, cur_beta, n, n_sims);
                        c_try = network_simulation(G, cur_nodes, dim, distance, cur_gamma, cur_beta, S, is_mex);
                        
                        if(c_try.is_warning == 0)
                            is_warning = 0;
                            R_temp{n} = c_try;
                            fprintf(1,' ok\n');
                        else
                            fprintf(1,' failed, retry\n');
                        end
                    end
                end
                
                %Then append to existing structure:
                fprintf(1,'Appending results (beta=%.1f) ...', cur_beta);
                s_idx = 1+(j-1)*n_sims;
                e_idx = s_idx + n_sims -1;
                R(s_idx:e_idx) = R_temp;
                fprintf(1,' ok\n');
            else
                for n = 1:n_sims
                    cur_nodes = n_nodes(k);
                    cur_gamma = gamma(i);
                    cur_beta = beta(j);
                    is_warning = 1;
                    
                    while(is_warning == 1)
                        fprintf(1,'sim: N=%d, gamma=%.2f, beta=%.1f (%d/%d) ...', cur_nodes, cur_gamma, cur_beta, n, n_sims);
                        c_try = network_simulation(G, cur_nodes, dim, distance, cur_gamma, cur_beta, S, is_mex);
                        
                        if(c_try.is_warning == 0)
                            is_warning = 0;
                            R{n+(j-1)*n_sims} = c_try;
                            fprintf(1,' ok\n');
                        else
                            fprintf(1,' failed, retry\n');
                        end
                    end
                end
            end
        end
                    
        %dump result to disk:
        fprintf(1, 'Dump result to /results...');
        Export(R, txt_flag);
        fprintf(1, ' ok\n');
    end
end

% Restore the warnings back to their previous (non-error) state
%warning(s);

