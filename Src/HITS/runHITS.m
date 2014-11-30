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
   review = -1;
   if (rating >= avgRating)
       review = 1;
   end
   adjList(j,:) = [userIndex productIndex review];   
end

%Initial honesty of users
H = ones(numUsers,1)*0.0001;

%Initial goodness of products
G = ones(numProducts,1)*0.0001;

[Honesty, Goodness] = HITS(adjList, H, G, numUsers, numProducts, 1000);

display(Honesty);
display(Goodness);

%Find top 50 users with minimum honesty probability
[mx, loc]=mink(Honesty(:),5);

display('Top 50 fake users according to HITS are');
for i=1:length(loc)
    display(users{1,2}{loc(i)});    
end

