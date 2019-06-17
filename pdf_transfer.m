
function [DR, tEnd] = pdf_transfer(D0, D1, Rotations)

nb_iterations = length(Rotations);
prompt = '';
iterations=zeros(2,(nb_iterations));
tStart = tic;

for it=1:nb_iterations
    fprintf(repmat('\b',[1, length(prompt)]))
    prompt = sprintf(' %02d / %02d', it, nb_iterations);
    fprintf(prompt);
    
    R = Rotations{it};    
    nb_projs = size(R,1);
  
    D0R = R * D0;
    D1R = R * D1;
    D0R_ = zeros(size(D0)); 
    
    for i=1:nb_projs%, nb_projs)
        [D0R_(i,:)] = OTsort(D0R(i,:), D1R(i,:));       
    end  
    
    %======IDT 
%     D0 = D0 + (R \ (D0R_ - D0R)) ; 
     
%   %======SWD
    tau = 1; 
    D0 = (1-tau)*D0 + tau*(R\ D0R_);
end
 tEnd = toc(tStart);
% delete(gcp('nocreate'))    

fprintf(repmat('\b',[1, length(prompt)]))
DR = D0;

end

