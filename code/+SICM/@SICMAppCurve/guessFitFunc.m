function varargout = guessFitFunc(self, varargin)
% This function tries to guess whether the AppCurve was recorded with
% increasing or decreasing x-values.
    if nargout == 1
        o = SICM.SICMAppCurve.fromSICMAppCurve_(self);
        o.guessFitFunc(varargin{:});
        varargout{1} = o;
        return;
    end
    
    force_overwrite = self.returnValIfVarArgEmpty_(0, varargin{:});
    if force_overwrite == 0 && ~isempty(self.fitfunc)
        warning('SICMAppCurve:FitFuncNotEmpty',...
            'This AppCurve object already has a fit function. I will keep that.');
        return
    end
    
    if isnan(self.direction)
        self.guessDirection();
    end
    
    % For VC and DEC
    if self.mode == SICM.SICMAppCurve.modes.VC ...
            && self.direction == SICM.SICMAppCurve.directions.DEC
        self.setFitFunc(@(I0,C,D,x)(...
            I0 .* (1 + C ./ (x - D) ).^-1 ...
            ));
        self.setInverseFitFunc(@(I0,C,D,I)(...
            D - C ./ ((I./I0) - 1)...
            ));
    end
    % For VC and INC
    if self.mode == SICM.SICMAppCurve.modes.VC ...
            && self.direction == SICM.SICMAppCurve.directions.INC
        self.setFitFunc(@(I0,C,D,x)(...
            I0 .* (1 + C ./ (D - x) ).^-1 ...
            ));
    end
    % For CC and DEC
    if self.mode == SICM.SICMAppCurve.modes.CC ...
            && self.direction == SICM.SICMAppCurve.directions.INC
        self.setFitFunc(@(U0,C,D,x)(...
            U0 .* (1 + C ./ (x - D) ) ...
            ));
    end
    % For CC and INC
    if self.mode == SICM.SICMAppCurve.modes.CC ...
            && self.direction == SICM.SICMAppCurve.directions.INC
        self.setFitFunc(@(U0,C,D,x)(...
            U0 .* (1 + C ./ (D - x) ) ...
            ));
    end
end