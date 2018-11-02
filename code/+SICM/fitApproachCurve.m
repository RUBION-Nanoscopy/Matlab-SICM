function [h, f , g, repeats] =fitApproachCurve(z,U,t,varargin)

    % fitApproachCurve
    %
    % [h, f, g, repeats] = fitApproachCurve(z,U,t)
    % fits the equation U0*(1+C/(z-h)) to the data provided in z and U up
    % to a threshold of U/U0 = t.
    %
    % First, the entire data in z and U is considered. The fit is computed
    % and h, the sample height, is determined. Then only valus of z (and
    % their corresponding U-values) below this value are considered and the
    % fit is computed. Again, h is determined from this data, and the
    % fitting procedure is applied again.
    %
    % This is repeated until two successive determinations yield only a
    % difference in h below 0.0001 (that is .1 nm if data is given in
    % micrometers). Alternatively, the difference can be provided as the
    % optional argument. If a loop occrus, the procedure is halted.
    %
    % The retrun valus are 
    %   h: height of the sample
    %   f: the fit object
    %   g: the goodness of the fit
    %   repeats: the number of iterations. If negative, a loop occured.
    %
    % See also fit
    
    if nargin == 4
        difference = varargin{1};
    else
        difference = 0.0001;
    end
    
    % The equation 
    appCurve = fittype('U0*(1+C/(z-h))','independent',{'z'},'Coefficients',{'C','h','U0'});
    
    % Start points and other helpers for the fit funtion
    
    uh = z(end);
    lh = z(end)-2;
    sh = z(end)-.5;
    
    % These values might be only valid for pipettes used so far... Sharper
    % pipettes might require an adaption
    
    lC = 0.00001;
    uC = 0.1;
    sC = 0.001;
           
    %
    sU0 = mean(U(1:100));
    lU0 = min(U(1:100))/2;
    uU0 = max(U(1:100))*2;
    
    % Some temporary variables
    
    h_old=inf; h=0; counter=1; all_h = [];
    
    % The first fit
    
    [fitres, gfitg]= fit(z, U, appCurve, 'StartPoint',[sC, sh, sU0], 'Lower',[lC, lh, lU0], 'Upper',[uC, uh, uU0]);
    
    while abs(h-h_old) > difference && isempty(find(all_h==h,1))
        h_old = h;
        counter=counter+1;
            
        h = fitres.C/(t-1) + fitres.h;
        ind = find(z >= h);
        if(h_old ~=h)
            all_h = [all_h h_old];
        end
        [fitres, gfitg]= fit(z(ind), U(ind), appCurve, 'StartPoint',[sC, sh, sU0], 'Lower',[lC, lh, lU0], 'Upper',[uC, uh, uU0]);
    end
    
    f=fitres;
    g=gfitg;
    if ~isempty(find(all_h==h,1))
        repeats = -counter;
    else
        repeats = +counter;
    end
    