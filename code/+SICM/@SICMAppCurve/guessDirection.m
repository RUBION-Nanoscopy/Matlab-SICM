function varargout = guessDirection(self, varargin)
% This function tries to guess whether the AppCurve was recorded with
% increasing or decreasing x-values.
    if nargout == 1
        o = SICM.SICMAppCurve.fromSICMAppCurve_(self);
        o.guessDirection(varargin{:});
        varargout{1} = o;
        return;
    end
    
    force_overwrite = self.returnValIfVarArgEmpty_(0, varargin{:});
    
    if force_overwrite == 0 && ~isnan(self.direction)
        warning('SICMAppCurve:DirectionNotEmpty',...
            'This AppCurve object already has a direction. I will keep that.');
        return
    end
    
    if isnan(self.mode)
        warning('SICMAppCurve:MissingInformation',...
            'This AppCurve object has not yet a mode. Trying to guess it.');
        self.guessMode();
    end
    if isnan(self.mode)
        error('SICMAppCurve:MissingInformation',...
            'This AppCurve object has no mode. Giving up.');
    end
    
    if self.mode == SICM.SICMAppCurve.modes.VC
        local_guessDirectionForVC(self)
    else
        local_guessDirectionForCC(self)
    end
end

% These functions are still quite ugly...

function local_guessDirectionForVC(obj)
    [mlow, mhigh, x0, xend] = local_getMeansAndExtremes(obj);
    if mlow < mhigh
        if x0 < xend
            obj.setDirection(SICM.SICMAppCurve.directions.DEC);
        else
            obj.setDirection(SICM.SICMAppCurve.directions.INC);
        end
    else
        if x0 < xend
            obj.setDirection(SICM.SICMAppCurve.directions.INC);
        else
            obj.setDirection(SICM.SICMAppCurve.directions.DEC);
        end
    end
end
function local_guessDirectionForCC(obj)
    [mlow, mhigh, x0, xend] = local_getMeansAndExtremes(obj);
    if mlow > mhigh
        if x0 < xend
            obj.setDirection(SICM.SICMAppCurve.directions.DEC);
        else
            obj.setDirection(SICM.SICMAppCurve.directions.INC);
        end
    else
        if x0 < xend
            obj.setDirection(SICM.SICMAppCurve.directions.INC);
        else
            obj.setDirection(SICM.SICMAppCurve.directions.DEC);
        end
    end
end

function [mlow, mhigh, x0,xend] = local_getMeansAndExtremes(obj)
    mlow = mean(obj.ydata(1:10));
    mhigh = mean(obj.ydata(end-10:end));
    x0 = obj.xdata(1);
    xend = obj.xdata(end);
end

