%Implementation of the LoopyBeliefPropagation
%Assume the below sample adjacency matrix
% U  P 1 2 3 4   
% 1    1 0 1 0
% 2    1 1 0 1
% 3    1 1 1 0 
% 4    0 1 0 0 
% 5    1 0 1 0
% 6    0 1 1 1

nNodes = 10;

adj = zeros(nNodes);

adj(1,7) = 1;
adj(1,9) = 1;
adj(2,7) = 1;
adj(2,8) = 1;
adj(2,10) = 1;
adj(3,7) = 1;
adj(3,8) = 1;
adj(4,8) = 1;
adj(5,7) = 1;
adj(5,9) = 1;
adj(6,8) = 1;
adj(6,9) = 1;
adj(6,10) = 1;

adj = adj + adj';

nStates = 2;
edgeStruct = UGM_makeEdgeStruct(adj,nStates);

%node pot to be edited, probabilities will come from pMRF
nodePot = [.5 .5
    .5 .5
    .5 .5
    .5 .5
    .5 .5
    .5 .5
    .5 .5
    .5 .5
    .5 .5
    .5 .5];

edgePot = zeros(nStates,nStates,edgeStruct.nEdges);
edgePot(:,:,1) = [2 1 ; 1 2];
edgePot(:,:,2) = [2 1 ; 1 2];
edgePot(:,:,3) = [2 1 ; 1 2];
edgePot(:,:,4) = [2 1 ; 1 2];
edgePot(:,:,5) = [2 1 ; 1 2];
edgePot(:,:,6) = [2 1 ; 1 2];
edgePot(:,:,7) = [2 1 ; 1 2];
edgePot(:,:,8) = [2 1 ; 1 2];
edgePot(:,:,9) = [2 1 ; 1 2];
edgePot(:,:,10) = [2 1 ; 1 2];
edgePot(:,:,11) = [2 1 ; 1 2];
edgePot(:,:,12) = [2 1 ; 1 2];
edgePot(:,:,13) = [2 1 ; 1 2];

[nodeBel, edgeBel] = UGM_Infer_LBP(nodePot,edgePot,edgeStruct)


