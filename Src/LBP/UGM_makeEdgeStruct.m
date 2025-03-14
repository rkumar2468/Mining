function [edgeStruct] = UGM_makeEdgeStruct(adj,nStates,useMex,maxIter)
% [edgeStruct] = UGM_makeEdgeStruct(adj,nStates,useMex,maxIter)
%
% adj - nNodes by nNodes adjacency matrix (0 along diagonal)
%

if nargin < 3
    useMex = 1;
end
if nargin < 4
    maxIter = 100;
end

%L = length(X) returns the length of the largest array dimension in X.
nNodes = int32(length(adj));

%[I,J] = ind2sub(siz,IND) returns the matrices I and J containing
%the equivalent row and column subscripts corresponding to each 
%linear index in the matrix IND for a matrix of size siz

%find(X) returns a vector containing the linear indices of each 
%nonzero element in array X
[i j] = ind2sub([nNodes nNodes],find(adj));
nEdges = length(i)/2;
edgeEnds = zeros(nEdges,2,'int32');
eNum = 0;
for e = 1:nEdges*2
   if j(e) < i(e)
       edgeEnds(eNum+1,:) = [j(e) i(e)];
       eNum = eNum+1;
   end
end

%[V,E] = UGM_makeEdgeVE(edgeEnds,nNodes,useMex);
[V,E] = UGM_makeEdgeVE(edgeEnds,nNodes);

edgeStruct.edgeEnds = edgeEnds;
edgeStruct.V = V;
edgeStruct.E = E;
edgeStruct.nNodes = nNodes;
edgeStruct.nEdges = size(edgeEnds,1);

% Handle other arguments
if isscalar(nStates)
   nStates = repmat(nStates,[double(nNodes) 1]);
end
edgeStruct.nStates = int32(nStates(:));
edgeStruct.useMex = useMex;
edgeStruct.maxIter = int32(maxIter);

