function [Honesty, Goodness] = HITS(adjList, H, G, numUsers, numProducts, maxIter)
    Honesty = H;
    Goodness = G;
    
    iter = 1;
    while (iter < maxIter)
        for i=1:numUsers
            s = 0;
            for j = 1:length(adjList)
                if (adjList(j,1) == i)
                   s = s + Goodness(adjList(j,2))*adjList(j,3);
                end
            end
            %Normalize honesty
            Honesty(i) = 2/(1 + exp(s)) - 1;            
        end
    
        for i=1:numProducts
            s = 0;
            for j = 1:length(adjList)
              if (adjList(j,2) == i)
                s = s + Honesty(adjList(j,1))*adjList(j,3);
              end
            end
            %Normalize goodness
            Goodness(i) = 2/(1 + exp(s)) - 1;            
        end
        iter = iter + 1;
    end;