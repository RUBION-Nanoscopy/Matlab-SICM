function varargout = readAllAppCurves(self, fhandle)
% Reads all Approach Curves into the approachcurves-property. Requires a
% function handle that returns the file name of the approach curve. 
%
% The function handle must accept three arguments: x,y,i. Here, x is the
% x-value of the current data point, y is the y-value and i is the index of
% the data point (as a matlan index, hence starting at 1)
%
% Assume the approach curves are stored as:
%
% appCurve-no0.ac
% appCurve-no1.ac
% ...
%
% a good function would be
%
%   @(x,y,i)(sprintf('appCurve-no%g.ac',i))
%
%  Example:
%
%    obj.readAllAppCurves(@(x,y,i)(sprintf('appCurve-no%g.ac',i)))
%
%     Will read all appcurves as described above
%
%    newobj = obj.readAllAppCurves(@(x,y,i)(sprintf('appCurve-no%g.ac',i)))
%
%       As above, but returns a new object instead of modifying the
%       original one. 

    if nargout == 1
        o = SICM.SICMScan.fromSICMScan_(self);
        o.readAllAppCurves(fhandle);
        varargout{1} = o;
        return
    end
    
    
    self.approachcurves = zeros(...
        size(self.zdata_grid,1),...
        size(self.zdata_grid,2)); 
    
    % Loop through all data points
    for i = 1:length(self.zdata_lin)
        [y,x] = ind2sub(size(self.zdata_grid), i);
        fname = fhandle(x,y,i);
        self.approachcurves(y,x) = SICM.SICMAppCurve.FromFile(fname);
    end
    