function r = roughness(self, varargin)
% Computes the roughness (RMSE) of the scan.
%
% In general, the roughness is computed as follows:
%
% 1) A 2D-polynomial of n-th degree is fitted to the data and then
%    subtracted from the data.
% 2) The RMSE is computed
%
% The function has three optional parameters.
%
%   r = scan.roughness(n, threshold, width)
%
%         n: Is the degree of the 2D-polynomial. Max degree is 5. Default
%            value is 5.  
%
% threshold: Is a height value used applied to the data. If set, only
%            values above (note: See next parameter) this value are
%            included in the fitting of the polynomial and the RMSE
%            computation. Default threshold is -Inf.
%
%     width: Does not compute the roughness of the entire scan, but of
%            squared sections of the scan with the corresponding width.
%            Note that width has to be a odd number, otherwise width is
%            increased by 1. 
%            Here, the threshold parameter is interpreted slightly
%            different: 
%            - If the central pixel of of the square window is below the
%              threshold, the roughness of the pixels below the threshold
%              is computed, otherwise the roughness of the pixels above the
%              threshold is computed.
%            If width is given a matrix of roughness values is returned.


% Defaults:

n = 5;
threshold = -Inf;
width = NaN;


if nargin > 1
    n = varargin{1};
end
if n > 5
    n = 5;
    warning('Reduced n to five.');
end

if nargin > 2
    threshold = varargin{2};
end

if nargin > 3
    width = varargin{3};
end

if isnan(width)
    exclude = self.zdata_grid < threshold;
    scan = self.flatten( 'polyXX', n, 'Exclude', exclude(:) );
    scan.zdata_grid(exclude) = NaN;
    r = scan.rmse();
else
    if mod(width,2) == 0
        width = width + 1;
        warning('Increased width by one.');
    end
    half_width = (width-1)/2;
    nx = 0;
    ny = 0;
    r = zeros(self.xpx - 2*half_width,self.ypx - 2*half_width);
    total = (size(r,1)-1-width)*(size(r,2)-1-width);
    fprintf('Will compute %g roughness values. This might take a while.\n', total);
    fprintf('Temporarilly switching off the warning for bad equation design for fitting.\n')
    warning('off', 'curvefit:fit:equationBadlyConditioned');
    report = floor(total/100);
    fprintf('Will report every %gth computation.\n', report);
    n_total = 0;
%    tic;
    %for y = 1 : self.ypx - width - 1
    %    ny = ny +1;
    %    for x = 1 : self.xpx - width - 1
    %        n_total = n_total + 1;
    %        if mod(n_total, report) == 0
    %            fprintf('Computed the %gth roughness point', n_total);
    %            toc;
    %        end
    %        nx = nx + 1;
    %        scan = self.crop(y,x,width,width);
    %        sg = sign(self.zdata_grid(x+half_width ,y + half_width) - threshold);
    %        scan.scaleZ(sg);
    %        try
    %            r(nx,ny) = sg * scan.roughness(n, sg * threshold);
    %        catch
    %            r(nx,ny) = NaN;
    %        end
    %    end
    %    nx = 0;
    %end
    
    % trying to implement the two loops from above as a single one. 
    
    sz = size(self.zdata_grid) - width;
    
    parfor idx = 1 : total
        scan = NaN;
        sg = NaN;
        warning('off', 'curvefit:fit:equationBadlyConditioned');
        if mod(idx, report) == 0
            fprintf('Computed the %gth roughness point', n_total);
        end      
        
        [row, col] = ind2sub(sz, idx);
        try
            % crop uses col<->row syntax (bad!)
            scan = self.crop(col, row, width, width);
            sg = sign(self.zdata_grid(row + half_width ,col + half_width) - threshold);
            scan.scaleZ(sg);

        catch
            idx_x
            idx_y
            idx
        end
        try
            r(idx) = sg * scan.roughness(n, sg * threshold);
        catch
            r(idx) = NaN;
    	end
    end
    % 
    fprintf('Enabling the warning again.')
    warning('on', 'curvefit:fit:equationBadlyConditioned');
end

%+BEGIN GUIMETADATA: Do not delete
%+GMD Type: 'prop'
%+GMD Name: 'Roughness'
%+GMD Depends: {'z'}
%+GMD Changes: {}
%+GMD Immediate: 1
%+GMD Unit: '[z]'
%+END GUIMETADATA