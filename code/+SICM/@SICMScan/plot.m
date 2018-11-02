function varargout = plot(self, varargin)
% Plots a 3D-plot of the data 
%
% Simply calls SURFACE
%
% See also SURFACE
   a = self.surface(varargin{:}); 
   if nargout > 0
       varargout{1} = a;
   end
end