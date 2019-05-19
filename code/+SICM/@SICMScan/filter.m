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
%
%  'outliers':
%     Looks for outliers that differ by more than a threshold from the
%     mean of its eight neighbours and replaces them by the mean of the
%     neighbours. For example: 
%  
%       obj.filter('outliers', 30)
% 
%     will filter all pixels that differ by 30 z-units. Thus, the z-scaling
%     is important. To be independent from the scaling, the option
%     'std' can be given as third argument. Thus, every pixel
%     exceeding the x-fold of the standard deviation of its neighbours will 
%     be filtered: 
%
%       obj.filter('outliers', 2, 'std')

    if nargout == 1
        o = SICM.SICMScan.fromSICMScan_(self);
        o.filter(method, varargin{:})
        varargout{1} = o;
        return
    end
    
    % Known methods...
    
    methods = struct(...
        'median', @local_filterMedian,...
        'average', @local_filterAverage,...
        'outliers', @local_filterNeighbours...
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
function data = local_filterNeighbours(obj, varargin)

    deviation = nargin > 2 && strcmp('std', varargin{2});
    data = obj.zdata_grid;
    sz = size(data);
    n=zeros(1,8);
    for row = 2 : sz(1) - 1
        for col = 2: sz(2) - 1
            n(1) = obj.zdata_grid(row-1, col-1);
            n(2) = obj.zdata_grid(row-1, col  );
            n(3) = obj.zdata_grid(row-1, col-1);
            n(4) = obj.zdata_grid(row-1, col);
            n(5) = obj.zdata_grid(row+1, col);
            n(6) = obj.zdata_grid(row-1, col+1);
            n(7) = obj.zdata_grid(row  , col+1);
            n(8) = obj.zdata_grid(row+1, col+1);
            m = mean(n);
            if deviation 
                thresh = varargin{1} * std(n);
            else
                thresh = varargin{1};
            end
            if abs(obj.zdata_grid(row, col)-m) > thresh 
                data(row, col) = m;
            end
        end
    end
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