%This is the main file.

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
fid_r = fopen('/home/mudit/workspace/CSE591/Mining/Dataset/Bot/relations.txt','r');
%fid_r = fopen('/home/mudit/workspace/CSE591/Mining/Dataset/Training/AlgoRunDataSet/relation_nrec_1000.txt','r');
relation = textscan(fid_r, '%s %s %f %f %d %d %d','delimiter', ',' );
fclose(fid_r);


probabilityLookupMatrix = [0.1 0.9;
                           0.99 0.01;
                           0.6 0.5;
                           0.99 0.01;
                           0.5 0.5;
                           0.99 0.01;
                           0.99 0.01;
                           0.05 0.05];

%Find the number of unique reviewers
numUsers = length(users{1,1});

%Find the number of unique products
numProducts = length(products{1,1});

%Number of edges in the graph
nEdges = length(relation{1,1});


userPriors = ones(numUsers,2)*0.5
productPriors = ones(numProducts,2)*0.5;

dupConsidered = zeros(numUsers);
vpConsidered = zeros(numUsers);
usefulConsidered = zeros(numUsers);

averageRating = zeros(numProducts,2);

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
   
   if (relation{1,5}(j) > 10 )
       usefulConsidered(userIndex) = 1;
   end
   if (relation{1,6}(j) > 0 )
       dupConsidered(userIndex) = 1; 
   end
   if (relation{1,7}(j) == 1 )
       vpConsidered(userIndex) = 1;
   end  
   
   if (averageRating(productIndex) == 0)
       averageRating(productIndex) = avgRating;
   end
   
end

for i = 1: numUsers
    if (dupConsidered(i) == 1 && vpConsidered(i) == 0 && usefulConsidered(i) == 0)
        userPriors(i,:) = probabilityLookupMatrix(1,:);
    elseif (dupConsidered(i) == 0 && vpConsidered(i) == 1 && usefulConsidered(i) == 0)
        userPriors(i,:) = probabilityLookupMatrix(2,:);
    elseif (dupConsidered(i) == 0 && vpConsidered(i) == 0 && usefulConsidered(i) == 1)
        userPriors(i,:) = probabilityLookupMatrix(3,:);
    elseif (dupConsidered(i) == 1 && vpConsidered(i) == 1 && usefulConsidered(i) == 0)
        userPriors(i,:) = probabilityLookupMatrix(4,:);
    elseif (dupConsidered(i) == 1 && vpConsidered(i) == 0 && usefulConsidered(i) == 1)
        userPriors(i,:) = probabilityLookupMatrix(5,:);
    elseif (dupConsidered(i) == 0 && vpConsidered(i) == 1 && usefulConsidered(i) == 1)
        userPriors(i,:) = probabilityLookupMatrix(6,:);
    elseif (dupConsidered(i) == 1 && vpConsidered(i) == 1 && usefulConsidered(i) == 1)
        userPriors(i,:) = probabilityLookupMatrix(7,:);
    elseif (dupConsidered(i) == 0 && vpConsidered(i) == 0 && usefulConsidered(i) == 0)
        userPriors(i,:) = probabilityLookupMatrix(8,:);
    end;
 end;
 
 for i = 1:numProducts
     productPriors(i,1) = averageRating(i) / 5;
     productPriors(i,2) = 1 - productPriors(i,1);
 end     

nStates = 2;

edgePot = ones(2,2,3);
edgePot(:,:,1) = [.8 .2; .15 .85];
edgePot(:,:,2) = [.2 .8; .85 .15];

[userBel, productBel, Hi] = UGM_Infer_LBP(adjList, userPriors, productPriors, edgePot, 1000);

display(userBel);
display(productBel);
display(Hi);
%try
%    maxkmex(1,1);
%    maxkmex(1,1);
%catch
%    minmax_install();
%end

%Find top 25 users with maximum probability of being fake
[mx, loc]=maxk(userBel(:,2),100);

display('Top 100 fake users are');
for i=1:length(loc)
    fprintf('%s %s %f\n',users{1,1}{loc(i)}, users{1,2}{loc(i)},userBel(loc(i),2));    
end

%Find top 15 products with maximum probability of being bad
[mx, loc]=maxk(productBel(:,2),15);
display('Top 15 bad products are');
for i=1:length(loc)
    display(products{1,2}{loc(i)});
end
