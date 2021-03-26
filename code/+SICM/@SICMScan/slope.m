function d = slope(self, varargin)
% Computes the slope along the horizontal axes. 
%
%    Examples: 
%      
%      obj.slope()
%        
%        Computes the slope of the data in obj and returns it.
%     scale = 1;
%     if nargin > 1
%         scale = varargin{1};
%     end
%     sz = size(self.zdata_grid);
%     d = zeros(sz(1), sz(2) - 1);
%     for i = 1:sz(1)
%         d(i, :) = diff(self.zdata_grid(i,:));
%     end
    d = diff(self.zdata_grid);
end

%+BEGIN GUIMETADATA: Do not delete
%+GMD Type: 'img'
%+GMD Name: 'Slope'
%+GMD Depends: {'x','y','z'}
%+GMD Changes: {}
%+GMD Immediate: 1
%+END GUIMETADATA