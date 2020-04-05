function [G, RN, db] = clean_network(G)
%return the network without any 'single' nodes or unconnected nodes.

% if(any(G.degree == 0))
%     %there should be no nodes with degree == 0
%     %just a test to ensure this assertion.
%     keyboard;
% end

RN = {};
db = 0; k = 1;
while(any(G.degree == 1)) %Check for nodes with only one link remaining
    idxs = find(G.degree==1); %find indexes of nodes with degree 1.
    %for all idxs, remove corresponding nodes:
    while(~isempty(idxs))
        %while there are nodes in idxs, we continue:
        [G, RN{k}, db] = remove_node(G, idxs(end));  %Remove node
        k = k+1; %update removed node counter.
        if(db == 1)
            return; %we removed the inflow or outflow node... hum.
        else
            idxs(end) = []; %remove corresponding idxs
        end
    end
end

%NUMEL VERSION: (identical)
% db = 0;
% while(any(G.degree == 1)) %Check for nodes with only one link remaining
%     idxs = find(G.degree==1); %find indexes of nodes with degree 1.
%     %for all idxs, remove corresponding nodes:
%     while(~isempty(idxs))
%         %while there are nodes in idxs, we continue:
%         [G, db] = remove_node(G, idxs(numel(idxs)));  %Remove node
%         if(db == 1)
%             return; %we removed the inflow or outflow node... 
%         else
%             idxs(numel(idxs)) = []; %remove corresponding idxs            
%         end
%     end
% end


% if(any(G.degree == 0))
%     %there should be no nodes with degree == 0
%     %just a test to ensure this assertion.
%     %keyboard; %<=== CAN HAPPEN WHEN network G is empty (no more nodes!).
% end
% 
% %Verification function, to make sure that degrees vector follows the adjacency matrix (slow!):
% for i=1:numel(G.degree)
%     if(G.degree(i) ~= sum(G.adjm(i,:)))
%         %error
%         keyboard;
%     end
% end


