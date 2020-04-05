function d = get_distances(XY, adjm, beta)
%%%%%%%%%%%%%%%%%%%%%%%%%%
% VERSION #1 
% Gather the euclidean distance for each node (more efficient than version
% #2).
% Also sets source (inflow) and sink (outflow) nodes. If distance == 0 then 
% assign random nodes, otherwise try to find the requested distance.
%%%%%%%%%%%%%%%%%%%%%%%%%

%****** COMPUTE EUCLIDEAN DISTANCES
%Pre-alloc:
d = zeros(size(adjm))*NaN; %NaN values will be used when nodes are not connected.

%Compute euclidean distances:
for i=1:size(adjm,1)
    xy=XY(i,:);
    
    %Find connected nodes (adj matrix):
    idx = find(adjm(i,:));
    S = size(idx,2); %dimension of the node.
    
    %Gather coordinates of other nodes:
    list = XY(idx,:);
    
    %Repmat according to S:
    D = repmat(xy, S, 1);
    
    %Compute euclidean distances for each link:
    d(i,idx) = sqrt((list(:,1) - D(:,1)) .* (list(:,1) - D(:,1)) + (list(:,2) - D(:,2)) .* (list(:,2) - D(:,2)));
    %NOTE: @bsxfun may be a faster solution?
end

%****** ASSIGN BETA TO DISTANCE MATRIX
%Second, use 'beta' to affect the distance:
d(~isnan(d)) = d(~isnan(d)).^beta;

%%%%%%%%%%%%%%%%%%%%%%%%%
% VERSION #2
%Since tril(adjm) == triu(adjm)' then only work with the upper triangular
%part of the matrix and aggregate the triangular sizes.
%(slower than version #1)
%%%%%%%%%%%%%%%%%%%%%%%%%
% function d = get_distances(XY, adjm)
% %Gather the euclidean distance for each link.
% 
% %Pre-alloc distance matrice:
% d = zeros(size(adjm));
% U = triu(adjm);
% 
% for i=1:size(U,1)
%     xy=XY(i,:);
%     
%     %Find connected nodes (adk matrix):
%     idx = find(U(i,:));
%     S = size(idx,2); %Size of the node.
%     
%     %Gather coordinates of other nodes:
%     list = XY(idx,:);
%     
%     %Repmat according to S:
%     D = repmat(xy, S, 1);
%     
%     %Compute euclidean distances for each link:
%     d(i,idx) = (list(:,1) - D(:,1)) .* (list(:,1) - D(:,1)) + (list(:,2) - D(:,2)) .* (list(:,2) - D(:,2));
% end
% 
% %Then aggregate the two variables:
% d = triu(d) + triu(d,1)';


%for a requested euclidean distance:
% alld = (sqrt(sum(bsxfun(@minus, XY(in,:), XY).^2,2)));
%     
%     if(any(alld == distance)) %found an exact match!
%         idx = find(alld == distance);
%         out = idx(randi(size(idx,1)));
%     else %find the nearest match with error epsilon:
%         [a,out] = min(abs(alld - distance));
%         warning(sprintf('requested distance was not found, nearest one an error of %.5f',a));
%     end


% function d = get_distances(adjm, beta)
% %%%%%%%%%%%%%%%%%%%%%%%%%%
% % VERSION #1 
% % Gather the euclidean distance for each node (more efficient than version
% % #2).
% % Also sets source (inflow) and sink (outflow) nodes. If distance == 0 then 
% % assign random nodes, otherwise try to find the requested distance.
% %%%%%%%%%%%%%%%%%%%%%%%%%
% 
% %****** ASSIGN RANDOM EUCLIDEAN DISTANCES (on the unit square)
% %Pre-alloc:
% idx = find(adjm > 0);
% n_links = size(idx,1);
% 
% d = zeros(size(adjm));
% d(idx) = rand(n_links, 1);
% 
% %then assign NaN values to zeros:
% d(d==0) = NaN;
% 
% %****** ASSIGN BETA TO DISTANCE MATRIX
% %Use 'beta' to affect the distance:
% d(~isnan(d)) = d(~isnan(d)).^beta;
