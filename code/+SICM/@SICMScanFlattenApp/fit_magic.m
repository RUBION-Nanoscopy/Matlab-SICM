function fit_magic( self )
    
    sz = size(self.Scan.zdata_grid);
    result = self.Scan.zdata_grid;
    
    fits = zeros(sz(1),4);
    x = 1:sz(1);
    base_fit = polyfit(x(self.selection), self.line(self.selection), 3);
    
    base_val = self.Scan.zdata_grid(self.linepointer,:) - polyval(base_fit, x); 
    last_fit = base_fit;
    last_val = base_val;
    fits(self.linepointer, :) = base_fit;
    result(self.linepointer, :) = base_val;
    n=2000;
    ratio=[.15 .15 .15 .15];
    
    for idx = self.linepointer-1 : -1 : 1
        line = self.Scan.zdata_grid(idx, :);
        fits(idx,:) = local_minimize_diff(line, last_val, last_fit, n, ratio);
        last_fit = fits(idx,:);
        last_val = self.Scan.zdata_grid(idx,:) - polyval(fits(idx,:), x);
        result(idx,:) = last_val;
    end
    
    last_fit = base_fit;
    last_val = base_val;
    
    for idx = self.linepointer+1 : sz(1)
        line = self.Scan.zdata_grid(idx, :);
        fits(idx,:) = local_minimize_diff(line, last_val, last_fit, n,ratio);
        last_fit = fits(idx,:);
        last_val = self.Scan.zdata_grid(idx,:) - polyval(fits(idx,:), x);
        result(idx,:) = last_val;
    end
    self.Result = result;
    
end


function ft = local_minimize_diff(line, last_val, last_fit, n, ratio)
    p = rand(n,numel(ratio))*2-1;
    l = numel(line);
    x = 1:l;
    for j=1:numel(ratio)
        p(:,j) = p(:,j)*last_fit(j)*ratio(j) + last_fit(j);
    end
    res = zeros(l, n);
    for i = 1:n
        ftl = line-polyval(p(i,:), x);
        res(:,i) = abs(ftl - last_val);
    end
    [~,idx] = min(sum(res));
    ft = p(idx,:);
end