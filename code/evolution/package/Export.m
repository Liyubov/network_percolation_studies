function Export(R, txt_flag)
%dump result to disk in results/ path.

destination = 'results/'; %destination folder
filename = sprintf('results--%s-%d-%s.mat', date, randi(1e3), txt_flag);
R_ser = serialize(R); %Then serialize it (if previously serialized).
savefast(strcat(destination, filename), 'R_ser'); %save it using the savefast package.

%or use:
%save(file_name, 'R','-v7.3');
%for a much slower saving.
