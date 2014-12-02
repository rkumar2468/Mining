%Step 1 - Read the input file

%Step 1 - Read the input file
%fid_u = fopen('/home/mudit/workspace/CSE591/Mining/Dataset/Academic/users.txt','r');
%fid_u = fopen('/home/mudit/workspace/CSE591/Mining/Dataset/Training/AlgoRunDataSet/users_rec_1000.txt','r');
%fid_u = fopen('/home/mudit/workspace/CSE591/Mining/Dataset/Training/AlgoRunDataSet/users_nrec_1000.txt','r');
fid_u = fopen('/home/mudit/workspace/CSE591/Mining/Dataset/Bot/users.txt','r');
%fid_u = fopen('D:\workspace\CSE591\Mining\Dataset\Academic\users.txt','r');
users = textscan(fid_u, '%s %s','delimiter', ';');
fclose(fid_u);

%fid_p = fopen('/home/mudit/workspace/CSE591/Mining/Dataset/Academic/products.txt','r');
%fid_p = fopen('D:\workspace\CSE591\Mining\Dataset\Academic\products.txt','r');
%fid_p = fopen('/home/mudit/workspace/CSE591/Mining/Dataset/Training/AlgoRunDataSet/products_rec_1000.txt','r');
fid_u = fopen('/home/mudit/workspace/CSE591/Mining/Dataset/Bot/products.txt','r');
%fid_p = fopen('/home/mudit/workspace/CSE591/Mining/Dataset/Training/AlgoRunDataSet/products_nrec_1000.txt','r');
products = textscan(fid_p, '%s %s','delimiter', ';' );
fclose(fid_p);

%fid_r = fopen('/home/mudit/workspace/CSE591/Mining/Dataset/Academic/relations.txt','r');
%fid_r = fopen('D:\workspace\CSE591\Mining\Dataset\Academic\relations.txt','r');
%fid_r = fopen('/home/mudit/workspace/CSE591/Mining/Dataset/Training/AlgoRunDataSet/relation_rec_1000.txt','r');
fid_r = fopen('/home/mudit/workspace/CSE591/Mining/Dataset/Bot/relations_Hits.txt','r');
%fid_r = fopen('/home/mudit/workspace/CSE591/Mining/Dataset/Training/AlgoRunDataSet/relation_nrec_1000.txt','r');
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
   review = -2;
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

%Find top 25 users with minimum honesty probability
[mx, loc]=mink(Honesty(:),100);

display('Top 25 fake users according to HITS are');
for i=1:length(loc)      
    fprintf('%s %s %f\n',users{1,1}{loc(i)},users{1,2}{loc(i)},Honesty(loc(i))); 
end

