function corrected = iterativeSlopeCorrection (imagegrid, h0, threshold, nums, varargin)
    dx = 1;
    dy = 1;
    if nargin > 4
        dx = varargin{1};
        dy = varargin{1};
    end
    if nargin > 5
        dy = varargin{2};
    end
    [X,Y] = size(imagegrid);
    
    corrected = ones(X,Y)*NaN;
    
    if threshold > 1
        threshold = threshold - 1;
    end
    imagegrid = imagegrid - min(imagegrid(:)) + h0/threshold +.5;
    for i = 1:nums
        if i>1
            slopegrid = SICM.imslope(corrected,dx,dy);
        else
            slopegrid = SICM.imslope(imagegrid,dx,dy);
        end
        
        
        for x = 2:X-1
            for y = 2:Y-1
                corrected(x,y) = imagegrid(x,y) - (.5+h0/threshold)/cos(atan(slopegrid(x,y)));
            end
        end
    end
    
    
    %if nums > 0
    %    corrected = iterativeSlopeCorrection(slopegrid, h0, threshold, nums, dx, dy);
    %end
end