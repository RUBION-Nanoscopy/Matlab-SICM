function corrected = flattening(image, threshold, order)
    if order > 1
        error ('SICM:flattening','Only -1, zero and first order supported yet.');
    end
    
    [X,Y] = size(image);
    
    corrected = ones(X,Y) * NaN;
    
    switch order
        case -1
            for i=1:X
                corrected(i,:) = image(i,:)-image(i,1);
            end
        case 0
            for i=1:X
                corrected(i,:) = image(i,:)-mean(image(i,image(i,:)-min(image(i,:))<threshold));
            end
        case 1
            for i=1:X
                x = 1:numel(image(i,:));
                p1 = polyfit(x,image(i,:),1);
                lold = x*Inf;
                lcurr=image(i,:);
                n=0;
                allp = [];
                while sum((lold-lcurr).^2) > threshold 
                    n=n+1;
                    fprintf('Line %d, iteration %d, sse: %0.5g\n',[i n sum((lold-lcurr).^2)]);
                    if(n>1)
                        th = .1;
                        ind=find(lcurr<th);
                        while sum(ind)<numel(lcurr)/3
                            th=th+.1;
                            ind=find(abs(lcurr)<th);
                        end
                    else
                        ind=find(lcurr>-Inf);
                        
                    end;
                    p = polyfit(x(ind),lcurr(ind),1);
                    
                    
                    
                    if i==205 %|| i==25%mod(i,20)==5
                        figure;
                        hold on;
                        title(sprintf('%d %d',[i n]));
                        plot(x,lcurr);
                        plot(x,polyval(p,x),'k.')
                        
                    end
                    lold = lcurr;
                    lcurr = lcurr-polyval(p,x);
                   % lcurr = lcurr-min(lcurr);
                    
                    if sum(find(allp==p(1))) > 0
                        break;
                    end
                    allp = [allp p(1)];
                    
                end
                %if (i==1)
                %    figure;
                %       plot(lcurr);
                %end
                %l = image(i,:)-;
                %v = threshold * var(l);
                %x2 = find (abs(l)<v);
                %p2 = polyfit(x(ind),image(i,ind),1);
                
                
                corrected(i,:)=lcurr;%image(i,:)-polyval(p2,1:numel(image(i,:)));
                if mod(i,10)==500
                   figure;
                   hold on
                   title(sprintf('%d',i));
                   plot(x,image(i,:),'k-');
                   plot(x,polyval(p1,x),'r.');
                   %plot(x,l,'k-');
                   plot(x,polyval(p2,x),'k--');
                   plot(x,corrected(i,:),'b-');
                end
            end
    end
end