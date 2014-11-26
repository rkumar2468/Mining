function [nodeBel, edgeBel] = UGM_Infer_LBP(nodePot,edgePot,edgeStruct)

[nNodes,maxState] = size(nodePot);
nEdges = size(edgePot,3);
edgeEnds = edgeStruct.edgeEnds;
V = edgeStruct.V;
E = edgeStruct.E;
nStates = edgeStruct.nStates;

maximize = 0;
new_msg = UGM_LoopyBP(nodePot,edgePot,edgeStruct,maximize);


% Compute nodeBel
for n = 1:nNodes
    edges = E(V(n):V(n+1)-1);
    prod_of_msgs(1:nStates(n),n) = nodePot(n,1:nStates(n))';
    for e = edges(:)'
        if n == edgeEnds(e,2)
            prod_of_msgs(1:nStates(n),n) = prod_of_msgs(1:nStates(n),n) .* new_msg(1:nStates(n),e);
        else
            prod_of_msgs(1:nStates(n),n) = prod_of_msgs(1:nStates(n),n) .* new_msg(1:nStates(n),e+nEdges);
        end
    end
    nodeBel(n,1:nStates(n)) = prod_of_msgs(1:nStates(n),n)'./sum(prod_of_msgs(1:nStates(n),n));
end

if nargout > 1
    % Compute edge beliefs
    edgeBel = zeros(maxState,maxState,nEdges);
    for e = 1:nEdges
        n1 = edgeEnds(e,1);
        n2 = edgeEnds(e,2);
        belN1 = nodeBel(n1,1:nStates(n1))'./new_msg(1:nStates(n1),e+nEdges);
        belN2 = nodeBel(n2,1:nStates(n2))'./new_msg(1:nStates(n2),e);
        b1=repmat(belN1,1,nStates(n2));
        b2=repmat(belN2',nStates(n1),1);
        eb = b1.*b2.*edgePot(1:nStates(n1),1:nStates(n2),e);
        edgeBel(1:nStates(n1),1:nStates(n2),e) = eb./sum(eb(:));
    end
end
end