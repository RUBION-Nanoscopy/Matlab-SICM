function varargout = profile (self, varargin)
% Determination of a height profile. Uses the improfile function of
% matlab.
%
% Examples:
% --------
%
% p = scan.profile()
%   Opens an image of the scan and allows to select a profile as in the
%   matlab function improfile. 
%  
% p = scan.profile(<arguments>)
%
%   If called with non-empty arguments, these arguments are passed to
%   improfile. Note that in this case, the call to improfile is:
%
%   improfile(self.xdata_lin, self.ydata_lin, self.zdata_grid, <arguments>)
%
% For return values, see the improfile docs.
% See also IMPROFILE

if nargin > 1
    [varargout{1:nargout}] = improfile(...%
        self.zdata_grid, varargin{:} );

else
    figure; 
    self.imagesc();
    [varargout{1:nargout}] = improfile();
end

% The following is for debugging 
%plot(self);
%hold on;
%plot3([p1(1) p2(1)],[p1(2) p2(2)],[101 101],'r-');


%+BEGIN GUIMETADATA: Do not delete
%+GMD Type: 'meas'
%+GMD Name: 'Measure Profile'
%+GMD FixedArgs: {}
%+GMD VarArgs: {}
%+GMD Depends: {}
%+GMD Changes: {}
%+GMD Immediate: 0
%+GMD Menu: 'Measurements'
%+END GUIMETADATA