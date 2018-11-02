function slopegrid = imslope (imgrid, varargin)
    % -
    %
    % SICM.imslope
    % ------------
    %
    % Synopsis:
    %
    %   slopes = SICM.imslope(datagrid)
    %     returns a grid with the size of datagrid containing the slope of
    %     every pixel 
    %
    %   slopes = SICM.imslope(grid, delta)
    %     returns a grid with the size of datagrid containing the slope of
    %     every pixel assuming a pixel distance of delta
    %
    %   slopes = SICM.imslope(grid, deltax, deltay)
    %     returns a grid with the size of datagrid containing the slope of
    %     every pixel assuming a pixel distance of deltax in x- and deltay
    %     in y-direction. 
    %
    
    
    dx = 1;
    dy = 1;
    if nargin > 1
        dx = varargin{1};
        dy = varargin{1};
    end
    if nargin > 2
        dy = varargin{2};
    end
    [X,Y] = size(imgrid);
    if X < 2 || Y < 2
        error('SICM:imslope','Size of image has to be at least 2 in both dimensions.');
    end
    slopegrid = ones(X,Y) * NaN;
    for x = 2:X-1
        for y = 2:Y-1
            xvals = imgrid(x-1:x+1,y)';
            yvals = imgrid(x,y-1:y+1);
            if ~isempty(find(isnan([xvals; yvals]),1))
                slopegrid(x,y)=NaN;
                continue;
            end
            px = getParabola((-1:1)*dx, xvals);%polyfit((-1:1)*dx,xvals,2);
            py = getParabola((-1:1)*dx, yvals);%polyfit((-1:1)*dy,yvals,2);
            
            slx = px(2); sly=py(2);
            
            n = [-slx -sly 1];
            s = dot(n,[0 0 1]) / sqrt(n*n');
            slopegrid(x,y)=tan(acos(s));
        end
    end
    for y=2:Y-1
        yvals = imgrid(1,y-1:y+1);    
        xvals = [imgrid(1,y) imgrid(2,y)];
        if ~isempty(find(isnan([xvals, yvals]),1))
            slopegrid(x,y)=NaN;
            continue;
        end
        px = getLine((0:1)*dx,xvals);%polyfit((0:1)*dx,xvals,1);
        py = getParabola((-1:1)*dy,yvals);
        slx = px(1); sly = py(2);
        n = [-slx -sly 1];
        s = dot(n,[0 0 1]) / sqrt(n*n');    
        slopegrid(1,y) = tan(acos(s));
        
        yvals = imgrid(X,y-1:y+1);    
        xvals = [imgrid(X-1,y) imgrid(X,y)];
        if ~isempty(find(isnan([xvals, yvals]),1))
            slopegrid(x,y)=NaN;
            continue;
        end
        px = getLine((0:1)*dx,xvals);%polyfit((0:1)*dx,xvals,1);
        py = getParabola((-1:1)*dy,yvals);
        slx = px(1); sly = py(2);
        n = [-slx -sly 1];
        s = dot(n,[0 0 1]) / sqrt(n*n');    
        slopegrid(X,y) = tan(acos(s));
    end
    for x=2:X-1
        xvals = imgrid(x-1:x+1,1)';
        yvals = [imgrid(x,1) imgrid(x,2)];   
        if ~isempty(find(isnan([xvals, yvals]),1))
            slopegrid(x,y)=NaN;
            continue;
        end
        px = getParabola((-1:1)*dx,xvals);
        py = getLine((0:1)*dy,yvals);%polyfit((0:1)*dy,yvals,1);
        slx = px(2); sly = py(1);
        n = [-slx -sly 1];
        s = dot(n,[0 0 1]) / sqrt(n*n');    
        slopegrid(x,1) = tan(acos(s));
        
        xvals = imgrid(x-1:x+1,Y)';
        yvals = [imgrid(x,Y-1) imgrid(x,Y)];   
        
        if ~isempty(find(isnan([xvals, yvals]),1))
            slopegrid(x,y)=NaN;
            continue;
        end
        px = getParabola((-1:1)*dx,xvals);
        py = getLine((0:1)*dy,yvals);%polyfit((0:1)*dy,yvals,1);
        slx = px(2); sly = py(1);
        n = [-slx -sly 1];
        s = dot(n,[0 0 1]) / sqrt(n*n');    
        slopegrid(x,Y) = tan(acos(s));
    end
    xvals = [imgrid(1,1) imgrid(2,1)];
    yvals = [imgrid(1,1) imgrid(1,2)];
    if ~isempty(find(isnan([xvals, yvals]),1))
        slopegrid(x,y)=NaN;
    else
    
        px = getLine((0:1)*dx,xvals);%polyfit((0:1)*dx,xvals,1);
        py = getLine((0:1)*dy,yvals);%polyfit((0:1)*dy,yvals,1);
        
        slx = px(1); sly = py(1);
        n = [-slx -sly 1];
        s = dot(n,[0 0 1]) / sqrt(n*n');    
        slopegrid(1,1) = tan(acos(s));
    end
    
    xvals = [imgrid(1,Y) imgrid(2,Y)];
    yvals = [imgrid(1,Y-1) imgrid(1,Y)];
    if ~isempty(find(isnan([xvals, yvals]),1))
        slopegrid(x,y)=NaN;
    else
    
        px = getLine((0:1)*dx,xvals);%polyfit((0:1)*dx,xvals,1);
        py = getLine((0:1)*dy,yvals);%polyfit((0:1)*dy,yvals,1);
        
    
        slx = px(1); sly = py(1);
        n = [-slx -sly 1];
        s = dot(n,[0 0 1]) / sqrt(n*n');    
        slopegrid(1,Y) = tan(acos(s));
    end
    xvals = [imgrid(X-1,Y) imgrid(X,Y)];
    yvals = [imgrid(X,Y-1) imgrid(X,Y)];
    if ~isempty(find(isnan([xvals, yvals]),1))
        slopegrid(x,y)=NaN;
    else
    
        px = polyfit((0:1)*dx,xvals,1);
        py = polyfit((0:1)*dy,yvals,1);
    
        slx = px(1); sly = py(1);
        n = [-slx -sly 1];
        s = dot(n,[0 0 1]) / sqrt(n*n');    
        slopegrid(X,Y) = tan(acos(s));
    
    end
    xvals = [imgrid(X-1,1) imgrid(X,1)];
    yvals = [imgrid(X,1) imgrid(X,2)];
    if ~isempty(find(isnan([xvals, yvals]),1))
        slopegrid(x,y)=NaN;
    else
        px = getLine((0:1)*dx,xvals);%polyfit((0:1)*dx,xvals,1);
        py = getLine((0:1)*dy,yvals);%polyfit((0:1)*dy,yvals,1);
    
        slx = px(1); sly = py(1);
        n = [-slx -sly 1];
        s = dot(n,[0 0 1]) / sqrt(n*n');    
        slopegrid(X,1) = tan(acos(s));
    end
end

function P = getParabola(xvals, yvals)
    p1 = [xvals(1), yvals(1)];
    p2 = [xvals(2), yvals(2)];
    p3 = [xvals(3), yvals(3)];
    P(1) = (p1(1)*(p2(2)-p3(2))+p2(1)*(p3(2)-p1(2))+p3(1)*(p1(2)-p2(2)))/((p1(1)-p2(1))*(p1(1)-p3(1))*(p3(1)-p2(1)));
    P(2) = (p1(1)^2*(p2(2)-p3(2))+p2(1)^2*(p3(2)-p1(2))+p3(1)^2*(p1(2)-p2(2)))/((p1(1)-p2(1))*(p1(1)-p3(1))*(p2(1)-p3(1)));	
    P(3) = (p1(1)^2*(p2(1)*p3(2)-p3(1)*p2(2))+p1(1)*(p3(2)^2*p2(2)-p2(1)^2*p3(2))+p2(1)*p3(1)*p1(2)*(p2(1)-p3(1)))/((p1(1)-p2(1))*(p1(1)-p3(1))*(p2(1)-p3(1)));
end

function P = getLine(xvals, yvals)
    p1 = [xvals(1) yvals(1)];
    p2 = [xvals(2) yvals(2)];
    P(1) = (p2(2)-p1(2))/(p2(1)-p1(1));
    P(2) = p1(2)-P(1)*p1(1);
end