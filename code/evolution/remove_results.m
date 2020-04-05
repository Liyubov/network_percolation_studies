%remove_results script
%warning: will remove ALL results in the results/ folder.

warning('will remove ALL results from /results folder');

d = dir('results');

for i=3:size(d,1)
    delete(strcat('results/',d(i).name));
end
