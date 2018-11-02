function varargout = filter(self, method, varargin)
% Filtering of the data using different methods
%
%    Examples: 
%      
%      obj.filter(method)
%        
%        Filters the data using `method` (see below).
%
%      newobj = obj.filter(method)
%
%        As above, but returns a new SICMScan object with the filtered
%        data.
%
%  
% The methods available are listed below. Some have additional arguments
% that can or have to be passed to the function. The meaning is explained
% in the corresponding description:
%
% Methods available:
% ==================
%
%  'median': 
%     Sets the pixel value to the median of the surroundings. Filter width
%     must be applied as second argument:
%
%     obj.filter('median', 5)

    if nargout == 1
        o = SICM.SICMScan.fromSICMScan_(self);
        o.filter(method, varargin{:})
        varargout{1} = o;
        return
    end
    
    % Known methods...
    
    methods = struct(...
        'median', @local_filterMedian,...
        'average', @local_filterAverage...
    );

    data = feval(methods.(method), self, varargin{:});
    self.zdata_grid = data;
    self.upd_zlin_();
end

function data = local_filterMedian(obj, varargin)
    data = medfilt2(obj.zdata_grid, [varargin{1} varargin{1}],'symmetric');
end
function data = local_filterAverage(obj, varargin)
    h = fspecial('average', [varargin{1} varargin{1}]);
    data = filter2(h, obj.zdata_grid);
end

%+BEGIN GUIMETADATA: Do not delete
%+GMD Type: 'meth'
%+GMD Name: {'Median','Average'}
%+GMD FixedArgs: {'median','average'}
%+GMD VarArgs: {struct('type','int','desc','Width of the filter window'), struct('type','int','desc','Width of the filter window')}
%+GMD Depends: {}
%+GMD Changes: {'z'}
%+GMD Immediate: 0
%+GMD Menu: 'Filter'
%+END GUIMETADATA