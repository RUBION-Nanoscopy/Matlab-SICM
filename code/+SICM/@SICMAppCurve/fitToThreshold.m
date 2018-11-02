function varargout = fitToThreshold(self, T)
% Performs an fit optimized to find a z.value at a certain threshold.

    if nargout == 1
        o = SICM.SICMAppCurve.fromSICMAppCurve_(self);
        o.fitToThreshold(T);
        varargout{1} = o;
        return
    end
    
    if isempty (self.fitfunc)
        self.guessFitFunc();
    end
    if isempty(self.fitobject)
        self.fit();
    end
    C = self.fitobject.C;
    I0 = self.fitobject.I0;
    D = self.fitobject.D;
    
    % To detect infinite loops, we need to keep all old values of zT:
    
    l_old = []; % It will grow inside a loop since I do not know how many attempts will be made
    I0_old = []; % It will grow inside a loop since I do not know how many attempts will be made
    C_old = []; % It will grow inside a loop since I do not know how many attempts will be made
    D_old = []; % It will grow inside a loop since I do not know how many attempts will be made
    
    zT = self.inversefitfunc(I0, C, D, T*I0);
    %xstep = min(abs(diff(self.xdata)));
    zT_old = [];
    errors = 0;

    while isempty(zT_old) ...
            || abs(zT_old(end)-zT) > 0.001
        
        [x,y]= local_getXandYuntilThreshold(self, zT);
        
        % Check whether we might enter an infinite loop...
        l = length(x);
        idx = find (l_old == l);
        if ~isempty(find(abs(I0_old(idx) - I0)<.99*I0,1))...
            && ~isempty(find(abs(C_old(idx) - C)<.99*C,1))...
            && ~isempty(find(abs(D_old(idx) - D)<.99*D,1))
            warning('SICMAppCurve:InfiniteLoopDetected',...
                'Fitting is likely to enter an infinite loop. Stopping after %g attempts.', length(l_old));
            self.fitproblems=1;
            
            break;
        end
        
        if length(x) < 3
            if errors == 0
                if self.isVCMode()
                    idx = find(self.ydata > T * I0_old(end));
                else
                    idx = find(self.ydata < T * I0_old(end));
                end
                x = self.xdata(idx);
                y = self.ydata(idx);
                l = length(x);
                plot(x,y);
                errors = 1; 
            else
                self.fitproblems=1;
                error('SICMAppCurve:NotEnoughDataPointsForFit',...
                    'Sorry, I cannot fit this data automatically.');
            end
        end
        l_old(end+1) = l;%#ok<AGROW>
        if self.isDEC()
            w = abs(y - T * I0);
            w = 1 - (w / max(w));
            fo = fit(x,y,self.fitfunc, 'Start', [I0, C, D], 'Lower',[I0*.5 1e-6 D-5], 'Upper', [I0*2, 1, min(x)+1e-6;],'Weights', w);
        else
            fo = fit(x,y,self.fitfunc, 'Start', [I0, C, D], 'Upper',[I0*2 1 D+5], 'Lower', [I0*.5, 1e-6, max(x)+1e-6], 'Weights', w);
        end
        
        I0_old(end+1) = I0; %#ok<AGROW>
        I0 = fo.I0;
        C_old(end+1) = C; %#ok<AGROW>
        C = fo.C;
        
        D_old(end+1) = D; %#ok<AGROW>
        D = fo.D;
        zT_old = zT;  
        zT = self.inversefitfunc(I0, C, D, T*I0);

        
    end
    
    self.fitobject = fo;
    
end
    
    
 function [x,y] = local_getXandYuntilThreshold(obj, zT)
    if obj.isDEC()
        ind = find(obj.xdata >= zT);
        x = obj.xdata(ind);
        y = obj.ydata(ind);
        return
    end
    if obj.isINC()
        ind = find(obj.xdata <= zT);
        x = obj.xdata(ind);
        y = obj.ydata(ind);
        return
    end
    error('SICMAPPCurve:DirectionNotSet',...
        'The direction of the approach curve is not known.');
end
    