function varargout = guessMode(self, varargin)
% This function tries to guess whether the AppCurve was recorded in VC or
% CC mode.
    
    if nargout == 1
        o = SICM.SICMAppCurve.fromSICMAppCurve_(self);
        o.guessMode(varargin{:});
        varargout{1} = o;
        return;
    end
    force_overwrite = self.returnValIfVarArgEmpty_(0, varargin{:});

    if force_overwrite == 0 && ~isnan(self.mode)
        warning('SICMAppCurve:ModeNotEmpty',...
            'This AppCurve object already has a mode. I will keep that.');
        return
    end
    
    avg = mean(self.ydata);
    if abs(min(self.ydata)-avg) > abs(max(self.ydata) - avg)
        self.setMode(SICM.SICMAppCurve.modes.VC);
    else
        self.setMode(SICM.SICMAppCurve.modes.CC);
    end
%% old check, not very reliable    
%     p25 = prctile(self.ydata, 25);
%     p75 = prctile(self.ydata, 75);
%     
%     iqr = p75-p25;
%     outl_low = self.ydata(self.ydata < p25-1.5*iqr);
%     outl_high = self.ydata(self.ydata > p75+1.5*iqr);
%     
%     if length(outl_low) == length(outl_high)
%         warning('SICMAppCurve:CannotGuessMode',...
%             'I cannot find a proper mode for this curve');
%     elseif length(outl_low) > length(outl_high)
%         % Looks like the curve values decrease, hence ydata contains
%         % the current. 
%         self.setMode(SICM.SICMAppCurve.modes.VC);
%     else
%         self.setMode(SICM.SICMAppCurve.modes.CC);
%     end
end
