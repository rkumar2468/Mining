%This is the main file.

%Step 1 - Read the input file
fid_u = fopen('/home/mudit/workspace/DataMining/FakeReview/DataSet/Datamining-Dataset-Normalized/users_10000.txt','r');
users = textscan(fid_u, '%s %s','delimiter', ';');
fclose(fid_u);

fid_p = fopen('/home/mudit/workspace/DataMining/FakeReview/DataSet/Datamining-Dataset-Normalized/products_10000.txt','r');
products = textscan(fid_p, '%s %s','delimiter', ';' );
fclose(fid_p);

fid_r = fopen('/home/mudit/workspace/DataMining/FakeReview/DataSet/Datamining-Dataset-Normalized/relation_10000.txt','r');
relation = textscan(fid_r, '%s %s %d %d %d %d','delimiter', ',' );
fclose(fid_r);

%Find the number of unique reviewers
numUsers = length(users{1,1});

%Find the number of unique products
numProducts = length(products{1,1});

%Number of nodes in the graph
nNodes = numUsers + numProducts;

%Create the bipartite graph
adj = zeros(nNodes);

for j = 1:length(relation{1,1}) 
   userId = relation{1,1}{j}; 
   productId = relation{1,2}{j};
   [userIndex] = find(strcmp(users{1,1}, userId));
   [productIndex] = find(strcmp(products{1,1},productId));
   adj(userIndex, numUsers + productIndex) = 1;   
end

adj = adj + adj';

nStates = 2;
edgeStruct = UGM_makeEdgeStruct(adj,2);

%Currently assign some random number to nodePot, real probabilities will come from pMRF
nodePot = ones(nNodes,2);
for i=1:nNodes
    for j=1:2
        nodePot(i,j) = rand();
    end
end

display(nodePot);

edgePot = ones(nStates,nStates,edgeStruct.nEdges);

[nodeBel, edgeBel] = UGM_Infer_LBP(nodePot,edgePot,edgeStruct)


try
    maxkmex(1,1);
    maxkmex(1,1);
catch
    minmax_install();
end

%Find top 50 users with maximum probability of being fake
[mx, loc]=maxk(nodeBel(1:numUsers,2),50);

display('Top 50 fake users are');
for i=1:length(loc)
    display(users{1,2}{loc(i)});
end

%Find top 50 products with maximum probability of being bad
[mx, loc]=maxk(nodeBel(numUsers+1:nNodes,2),50);
display('Top 50 bad products are');
for i=1:length(loc)
    display(products{1,2}{loc(i)});
end








