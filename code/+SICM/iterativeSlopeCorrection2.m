function [corrected, varargout] = iterativeSlopeCorrection2 (imagegrid,dn,nums,varargin)
    %-
    % 
    % SICM.iterativeSlopeCorrection2
    % ==============================
    %
    % Synopsis:
    %
    %   corrected = iterativeSlopeCorrection2(imagegrid, dn, nums)
    % 
    %     Returns the corrcted z-values provided in imagegrid, using dn as the
    %     imaging distance for perpendicular approaches of the SICM pipette to the
    %     surface. if nums >= 1, the iteration is performed  nums times, if nums<1,
    %     the iteration is performed until the sum of the squared height
    %     differences of all pixel is below nums. 
    %     Theoretically it does not matter in which units imagegrid and dn are
    %     provided, although it is only tested for all numbers expressed in pipette
    %     radii. If nums < 1, its unit should be the unit of the values in
    %     imgagegrid and dn, but squared. 
    %
    %     The pixel width (the step size) is assumed to be 1 in units of
    %     imagegrid and dn. 
    % 
    %   corrected = iterativeSlopeCorrection2(imagegrid, dn, nums, pixelwidth)
    %
    %     As above, but pixelwidth is assumed for the pixel width,
    % 
    %   corrected = iterativeSlopeCorrection2(imagegrid, dn, nums, pixelwidthX, pixelwidthY)
    % 
    %     As above, but with different pixel sizes for X and Y.
    %
    %   [corrected, onums] = iterativeSlopeCorrection2(imagegrid, dn, nums, ...)
    %
    %     As above, but also returns the number of iterations performed. Makes only
    %     sense in combination with an input for nums which is smaller than one.
    %
    %   [corrected, onums, differences] = iterativeSlopeCorrection2(imagegrid, dn, nums, ...) 
    %     Returns the differences between the corrected data and the data for
    %     onums-1. Was used for debugging purposes.
    %

    dx = 1;
    dy = 1;
    if nargin > 3
        dx = varargin{1};
        dy = varargin{1};
    end
    if nargin > 4
        dy = varargin{2};
    end
    [X,Y] = size(imagegrid);
    
    corrected = ones(X,Y)*NaN;
    
    %if threshold > 1
    %    threshold = threshold - 1;
    %end
    %imagegrid = imagegrid - min(imagegrid(:)) + h0/threshold +.5;
    counter = -1;
    if nums < 1
        deltasumofsquares = 1;
        slopegrid = SICM.imslope(imagegrid,dx,dy);
        oldgrid = imagegrid;
        diffs = imagegrid;
        while deltasumofsquares > nums && counter < 200
            counter = counter +1;
            for x = 1:X
                for y = 1:Y
                    corrected(x,y) = imagegrid(x,y) - (dn*(sqrt((slopegrid(x,y))^2+1)-1));%(.5+h0/threshold)/cos(atan(slopegrid(x,y)));
                    diffs(x,y) = corrected(x,y)-oldgrid(x,y);
                end
            end
            
            deltasumofsquares = sum(diffs(:).^2);
            fprintf('Iteration %d; SSD: %0.5g\n',[counter deltasumofsquares]);
            slopegrid = SICM.imslope(corrected,dx,dy);
            oldgrid=corrected;
        end
        if nargout > 1 
            varargout{1} = counter;
        end
    else
        differences = ones(nums,1)*NaN;
        for i = 1:nums
            if i>1
                slopegrid = SICM.imslope(corrected,dx,dy);
            else
                slopegrid = SICM.imslope(imagegrid,dx,dy);
            end
            for x = 1:X
                for y = 1:Y
                    corrected(x,y) = imagegrid(x,y) - (dn*(sqrt((slopegrid(x,y))^2+1)-1));%(.5+h0/threshold)/cos(atan(slopegrid(x,y)));
                end
            end
            
            differences(i) = sum(sum((imagegrid-corrected).^2));
        end
        if nargout > 1 
            varargout{1} = nums;
        end
        if nargout > 2
            varargout{2} = differences; 
        end
    end
    
    
    %if nums > 0
    %    corrected = iterativeSlopeCorrection(slopegrid, h0, threshold, nums, dx, dy);
    %end
end