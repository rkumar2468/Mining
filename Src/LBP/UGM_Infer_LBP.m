function [userBel, productBel, Hi] = UGM_Infer_LBP( adjlist, userPriors, productPriors, edgep, maxIter )

% adjlist : (Ex3) adjacency list; 
%	First two columns for source (1...N) and dest (1...M), N: #users and M: #prod.s
%	3rd column either (1) 1 for + and 2 for - , or (2) 1-5: ratings
% nodep1: NxK1 matrix of initial prior potentials; N: #users, K1: classes/states
% nodep2: MxK2 matrix of initial prior potentials; M: #prod.s, K2: classes/states
% edgep: K1xK2x|domain3rdColumn|
% it: max #iter.s

[N K1] = size(userPriors);
[M K2] = size(productPriors);
E = size(adjlist,1);

% initializing all messages to 1
% holding ALL msgs in log's so init to 0
m_to = zeros(E,K2);
m_from = zeros(E,K1);

userPriors = log(userPriors);
productPriors = log(productPriors);
edgep = log(edgep);

epsilon = 10^-6;

% for each node 
repeat = true;
iter=0;

while( repeat )    
    tic
    iter=iter+1
	maxdiff = -Inf;
	
	% compute product buffer for N
	prodN = zeros(N,K1);
	for i=1:E
		prodN(adjlist(i,1),:) = prodN(adjlist(i,1),:) + ( m_from(i,:) );
	end
	
	% compute messages to M nodes
    alldiff=zeros(2*E,1);
	for i=1:E
		a = adjlist(i,1);
		
		mn = ( prodN(a,:) - ( m_from(i,:) ) );
            
		part = userPriors(a,:) + mn;
		newmsg = zeros(1,K2);              
		for k=1:K2
			term = ( part + edgep( :,k,adjlist(i,3) )' ); 
			newmsg(k) = log(sum(exp(term-max(term)))) + max(term); 
		end
		
		% normalize: newmsg(i)/sum(newmsg)
		newmsg = newmsg-( log(sum(exp(newmsg-max(newmsg)))) + max(newmsg) );
		
		
		fark = exp(newmsg) - exp(m_to(i,:));
		diff = norm(fark);		
        alldiff(i) = diff;		
		if( diff > maxdiff)
			maxdiff = diff;  
		end 

		m_to(i,:) = newmsg; 

		
	end % iterating N nodes
	
		
	% compute product buffer for M
	prodM = zeros(M,K2);
	for i=1:E
		prodM(adjlist(i,2),:) = prodM(adjlist(i,2),:) + ( m_to(i,:) );
	end
	
	% compute messages to N nodes
	for i=1:E
		a = adjlist(i,2);
		%b = adjlist(i,1);
		mn = ( prodM(a,:) - ( m_to(i,:) ) );
		
	            
		part = productPriors(a,:) + mn;
		newmsg = zeros(1,K1);              
		for k=1:K1
			term = ( part + edgep( k,:,adjlist(i,3) ) );  
			newmsg(k) = log(sum(exp(term-max(term)))) + max(term); 
		end
		
		newmsg = newmsg-( log(sum(exp(newmsg-max(newmsg)))) + max(newmsg) );
		
		
		fark = exp(newmsg) - exp(m_from(i,:));
		diff = norm(fark);
        alldiff(i+E) = diff;	
		
		if( diff > maxdiff)
			maxdiff = diff;  
		end     
		
		m_from(i,:) = newmsg; 
		
	end % iterating M nodes
	
	maxd = max(alldiff) 
	mind = min(alldiff) 
	meand = mean(alldiff)
	p90 = quantile(alldiff, 0.9)
	
	if maxdiff < epsilon
        repeat = false;
    end
    
    if(iter == maxIter)        
        break;
    end	
end

% compute beliefs
userBel = zeros(N,K1);
productBel = zeros(M,K2);
% compute product buffer for N
for i=1:E
	a = adjlist(i,1);
	b = adjlist(i,2);
	userBel(a,:) = userBel(a,:) + ( m_from(i,:) );
	productBel(b,:) = productBel(b,:) + ( m_to(i,:) );	
end

for a=1:N
	userBel(a,:) = (userPriors(a,:)) + ( userBel(a,:) );
	
	nwm = userBel(a,:);
	for k=1:K1
		userBel(a,k) = 1 / ( sum(exp(nwm-nwm(k))) );
	end
	
end
for b=1:M
	productBel(b,:) = (productPriors(b,:)) + ( productBel(b,:) );
	
	nwm = productBel(b,:);
	for k=1:K2
		productBel(b,k) = 1 / ( sum(exp(nwm-nwm(k))) );
	end
	
end

Hi = exp(m_from(:,K1)); %edge-beliefs for fakeness of users
end