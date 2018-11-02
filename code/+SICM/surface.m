function surface(sicm,varargin)
    if nargin > 1
        gridtoshow = varargin{1};
    else
        gridtoshow = sicm.zgrid;   
    end;
    surface(sicm.xgrid, sicm.ygrid, gridtoshow,'EdgeColor','none');
