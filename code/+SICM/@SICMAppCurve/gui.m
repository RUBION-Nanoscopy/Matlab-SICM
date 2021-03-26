function varargout = gui(self)
% Opens the ApproachCurve GUI
%
% Examples:
%    obj.gui();
%
%      Opens the GUI
%
%   handle = obj.gui();
%
%      Returns a handle to the GUI

    
    h = SICMApps.AppCurveApp.AppCurveApp(self);
    if nargout == 1
        varargout{1} = h;
    end
end
    
