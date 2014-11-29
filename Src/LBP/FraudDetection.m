%This is the main file.

%Step 1 - Read the input file
fid_u = fopen('/home/mudit/workspace/DataMining/FakeReview/DataSet/Datamining-Dataset-Normalized/users_10.txt','r');
users = textscan(fid_u, '%s %s','delimiter', ';');
fclose(fid_u);

fid_p = fopen('/home/mudit/workspace/DataMining/FakeReview/DataSet/Datamining-Dataset-Normalized/products_10.txt','r');
products = textscan(fid_p, '%s %s','delimiter', ';' );
fclose(fid_p);

fid_r = fopen('/home/mudit/workspace/DataMining/FakeReview/DataSet/Datamining-Dataset-Normalized/relation_10.txt','r');
relation = textscan(fid_r, '%s %s %f %f %d %d','delimiter', ',' );
fclose(fid_r);

%Find the number of unique reviewers
numUsers = length(users{1,1});

%Find the number of unique products
numProducts = length(products{1,1});

%Number of edges in the graph
nEdges = length(relation{1,1});

%Create the adjacency list
adjList = zeros(nEdges,3);

for j = 1:length(relation{1,1}) 
   userId = relation{1,1}{j}; 
   productId = relation{1,2}{j};
   [userIndex] = find(strcmp(users{1,1}, userId));
   [productIndex] = find(strcmp(products{1,1},productId));
   
   rating = relation{1,3}(j);
   avgRating = relation{1,4}(j);
   review = 2;
   if (rating >= avgRating)
       review = 1;
   end
   adjList(j,:) = [userIndex productIndex review];   
end

nStates = 2;

%Currently assign 0.5 to priors, real probabilities will come from pMRF
userPriors = ones(numUsers,2)*0.5;
productPriors = ones(numProducts,2)*0.5;

edgePot = ones(2,2,3);
edgePot(:,:,1) = [.99 .01; .02 .98];
edgePot(:,:,2) = [.01 .09; .98 .02];

[userBel, productBel, Hi] = UGM_Infer_LBP(adjList, userPriors, productPriors, edgePot, 1000);

display(userBel);
display(productBel);
display(Hi);
try
    maxkmex(1,1);
    maxkmex(1,1);
catch
    minmax_install();
end

%Find top 50 users with maximum probability of being fake
%[mx, loc]=maxk(userBel(:,2),5);

%display('Top 50 fake users are');
%for i=1:length(loc)
%    display(users{1,2}{loc(i)});    
%end

[mx, loc]=maxk(Hi,5);

display('Top 50 fake users are');
for i=1:length(loc)
    display(users{1,2}{loc(i)});    
end

%Find top 50 products with maximum probability of being bad
[mx, loc]=maxk(productBel(:,2),1);
display('Top 50 bad products are');
for i=1:length(loc)
    display(products{1,2}{loc(i)});
end








