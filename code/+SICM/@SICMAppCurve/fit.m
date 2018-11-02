function varargout = fit(self, varargin)
% Fit the function provided by setFitFunc to the data
%
% See also SETFITFUNC

    if nargout == 1
        o = SICM.SICMAppCurve.fromSICMAppCurve_(self);
        o.fit(varargin{:});
        varargout{1} = o;
        return
    end
    
    others = {}; 
    
    [I0, C, D] = self.guessStartPoint();
    start = [I0, C, D];
    lower = [I0 - .5 * I0 , 0, D/100];
    upper = [I0 * 2, Inf D*100];
    if self.direction == SICM.SICMAppCurve.directions.DEC
        upper(3) = min(self.xdata) - 10 *eps;
        lower(3) = D - 3;
    else
        upper(3) = D + 3;
        lower(3) = max(self.xdata) + 10 *eps;
    end
    while ~isempty(varargin)
        switch varargin{1}
            case 'Start'
                start = varargin{2};
                varargin(1:2)=[];

            case 'Upper'
                upper = varargin{2};
                varargin(1:2)=[];

            case 'Lower'
                lower = varargin{2};
                varargin(1:2)=[];

            otherwise
                others{end+1} = varargin{1}; %#ok<AGROW> % I do not know better...
                
        end
    end
    
    self.fitobject = fit(self.xdata, self.ydata, self.fitfunc, ...
        'Start', start,...
        'Lower', lower,...
        'Upper', upper,...
        others{:});
end
