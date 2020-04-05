function export_fig(h1, is_eps, file_name)

file_name_tif = sprintf('figures/%s.tiff', file_name);
print(h1,'-dtiff', file_name_tif);
if(is_eps)
    %for an EPS export:
    file_name_eps = sprintf('figures/%s.eps', file_name);
    print(h1,'-dpsc', file_name_eps);
end


