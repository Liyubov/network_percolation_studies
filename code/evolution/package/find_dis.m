function cur_dis = find_dis(adjm, in, out)
%will returns the distance between 'in' and 'out' nodes.

%Start from inflow node then check existing paths:
idx = find(adjm(in,:));

%(Arbitrary) prealloc (for speed purposes):
visited = zeros(size(adjm,1),1);

%append original idx (distance = 0)
s = size(nonzeros(visited),1);
visited(s+1:s+size(idx,2)) = idx; %append: distance 0

n = size(adjm,1);

%check for out in distance 0:
if(any(nonzeros(visited) == out))
    cur_dis = 1; %bound limit, it should 0 instead.
    return
end

%Check for each entry of idx:
cur_dis = 1;
is_found = 0;
k = 1;
while(is_found == 0)
    %'idx' will grow at each iteration in the loop, capturing more and more
    %nodes until it matches requested distance:
    
    %Perform a new step ahead:
    %For each new entry, append the existing path: 
    idx = unique(ceil(find(adjm(idx,:)) / numel(idx)));
    
    cur_dis = cur_dis +1;

    if(any(nonzeros(idx) == out))
        %we found it!
        is_found = 1;
    else
        %append to visited nodes:
        s = size(nonzeros(visited),1);
        visited(s+1:s+numel(idx)) = idx;

        if(k > n)
            %we should have visited all the nodes at least once, but we
            %can't. It means that the graph is disconnected and that there
            %is no path between in and out. too bad. Thus we set 'cur_dis'
            %to -inf:
            cur_dis = -inf;
            break;
        end
    end
    k=k+1;
end
