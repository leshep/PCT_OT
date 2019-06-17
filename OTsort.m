
function [matched]= OTsort(f, g)

options.rows=1;
P = @(f,g)perform_hist_eq(f,g,options);
matched=P(f, g);

end

