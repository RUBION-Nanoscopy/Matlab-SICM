function [I0, C, D] = guessStartPoint(self)
% This function guesses the start points for a fit and returns them. Note
% that this function only guesses the start points for the functions
% provided by guessFitFunc(), for fit functions set manually you should
% provide the start points etc by passing them to the function fit.
%
% See also FIT, GUESSFITFUNC

    if self.direction == SICM.SICMAppCurve.directions.DEC
        D = min(self.xdata) - .1;
        if self.xdata(1) > self.xdata(end)
            I0 = mean(self.ydata(1:10));
        else
            I0 = mean(self.ydata(end-10:end));
        end
    else
        D = max(self.xdata) + .1;
        if self.xdata(1) > self.xdata(end)  
            I0 = mean(self.xdata(end-10:end));
        else
            I0 = mean(self.xdata(1:10));
        end
    end
    
    C = 0.01;
end