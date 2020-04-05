function [F, M] = get_flow(netw, is_mex)
%Returns the matrix of fluxes M and flow potentials F

%dbstop if warning
%warning off;

%Preallocs:
%P = zeros(size(netw.dis_eucl)); %Matrix of Pi's (without inflow and outflow entries)
%S = zeros(size(netw.XY,1), 1);  %Conservation of mass, thus outputs are 0's

%Preallocs:
sized = sum(any(netw.adjm,2));

if(is_mex)
    %Use MEX version (C) (much faster!, but only for full matrixs)
    [P, S] = prepare_sys_full(netw, sized);
else
    %use MATLAB version:
    [P,S] = prepare_linsys(netw, sized);
end

%Remove both inflow and outflow entries from P:
P([netw.inflow, netw.outflow],:) = [];
P(:,[netw.inflow, netw.outflow]) = [];
S([netw.inflow, netw.outflow]) = [];
%Comparison with Nicolaides: same as him but with a '-' sign.

%Solve the linear system:
FF = P\S;
%Comparison with Nicolaides: F is identical to PP but with small deviation
%(near machine precision) does it matter? (not sure)

% Alternatively forces the LDL solver: 
%[LA, DA] = ldl(M)
%x = LA'\(DA\(LA\S));
%where x holds the solution
% OR force LU solving: 
%[L,U,PP] = lu(M); y = L\(PP*S); x = U\y;
%handmade solution: x = inv (M'*M)*M'*S (less precise)
%Cholesky solving? <= NO Lu is used by 

%Re-insert inflow and outflow nodes (use Nicoladies stuff):
F(1:min([netw.inflow, netw.outflow])-1) = FF(1:min([netw.inflow, netw.outflow])-1);
F(min([netw.inflow, netw.outflow])+1:max([netw.inflow, netw.outflow])-1) = FF(min([netw.inflow, netw.outflow]):max([netw.inflow, netw.outflow])-2);
F(max([netw.inflow, netw.outflow])+1:size(netw.adjm,1)) = FF(max([netw.inflow, netw.outflow])-1:size(netw.adjm,1)-2);
%Insert:
if(min([netw.inflow, netw.outflow]) == netw.inflow)
    F(min([netw.inflow, netw.outflow]))=1;
    F(max([netw.inflow, netw.outflow]))=0;
else
    F(min([netw.inflow, netw.outflow]))=0;
    F(max([netw.inflow, netw.outflow]))=1;
end
F = F';

%Then compute the fluxes matrix M, according to F (flow potentials):
if(is_mex)
    %Use MEX version (C) (much faster!, but only for full matrices)
    M = compute_q_full(netw, sized, F);
else
    %use MATLAB version:
    M = compute_q(netw, sized, F);
end

%still ok but still a minor difference with Nicolaides' version near
%machine precision. Same thing occurs when using sparse vs. full
%matrices...
%Nicolaides compute the following quantity:
%keyboard;
%Q_ = -sum(M(netw.inflow,:));

%verif: dans le code original on a:
%F(netw.inflow) == 1 et F(netw.inflow) == 0
%sum(S) ~= -29.2338
%sum(M(netw.inflow,:)) ~= -17.7087
%sum(M(netw.outflow,:)) ~= 17.7087

% hist(F,20);
% axis square;
% title('potential distribution');
% subplot(1,5,5);
% hist(M(:),20);
% axis square;
% title('flux distribution');
% set(gcf, 'Position', [10,10,2000,300]);
% keyboard;


function M = compute_q(netw, sized, F)

%Prealloc (WARNING: because 0 can possibly be a minimum value, but in remove_weakest_link
% we do: min(netw.fluxes(netw.fluxes > 0)))
M = zeros(sized, sized); 

for i=1:size(netw.adjm,1)
    idx = netw.adjm(i,:) == 1;          %for each connected nodes
    D = netw.dis_eucl(i, idx);          %gather the distances
    M(i, idx) = -(F(i) - F(idx)) ./ D'; %then compute the associated flow
end


function [P, S] = prepare_linsys(netw, sized)
%prepare Linear system for solving:

%Prealloc:
P = zeros(sized, sized); %Matrix of Pi's (without inflow and outflow entries)
S = zeros(sized, 1);  %Conservation of mass, thus outputs are 0's

%%%%%%%%%%%%%%%%%%%%%%%%%%
%% VERSION #1
%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:size(netw.adjm,1)
    idx = netw.adjm(i,:) == 1;   %gather indexes of connected nodes.
    D = netw.dis_eucl(i, idx);   %gather corresponding euclidean distances

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Standard Node (non inflow, non outflow)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Standard computation: does not work for some reason???
    %A = prod(nchoosek(D, size(D,2)-1), 2);
    %P(i,i) = -sum(A);
    %P(i,idx) = flipud(A)';
    
    %THIS WORKS (except a minus inversion with Nicolaides code):
    %Check if there is link to the inflow node:
    if(any(find(idx) == netw.inflow))
        D2 = D; %save D.
        S(i) = -1/D(find(idx) == netw.inflow); %alter output accordingly (we know inflow value = 1)
        D(find(idx) == netw.inflow) = []; %remove inflow from distances
        idx(netw.inflow) = 0; %then erase coefficient from idx
        %Finally, perform standard computation
        P(i,i) = -sum(1./D2);
    else
        %Standard computation (ie. current node 'i' is not linked to inflow):
        P(i,i) = -sum(1./D);
    end
    
    %Assign coefficients values to connected nodes:
    P(i,idx) = 1./D;
end

