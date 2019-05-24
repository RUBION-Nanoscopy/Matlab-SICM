function change_threshold(self, dirs)
	thr = self.threshold;
    for n=1:2
        if dirs(n) == 0, continue; end
        if dirs(n) == Inf
            thr(n) = 1.01;
        elseif dirs(n) == -Inf
            thr(n) = 0;
        else
            t = thr(n);
            thr(n) = t + sign(dirs(n)) * 0.01;
        end
    end
        
	self.threshold = thr;
end