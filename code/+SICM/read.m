function varargout = read(varargin)
    % -
    %
    % SICM.read
    % =========
    % 
    % Synopsis:
    % 
    %   SICM.read
    %
    %     Opens a file selection dialogue which let's you chose a sic, ras,
    %     csv, dat or sicm-File. Note: None but sic and sicm-files have
    %     been tested!  
    %     This only works if the data is located within the same folder as
    %     the current matlab folder. While this is not a feature, it is no
    %     true bug ;-).
    % 
    %     The data is displayed as a 3D surface which allow quick
    %     inspection. Internally, the data is stored in a struct. Information 
    %     about this struct  is displayed, for details see below.
    %
    %   recording = SICM.read
    %    
    %     As above, but data is not displayed and the sruct is returned. The
    %     struct consists of the following fields:
    %
    %     x: The vector x-data (The data from the first column in the file).
    %     y: The vector y-data (The data from the second column in the
    %        file).
    %     z: The vector z-data (The data from the third column in the file).
    %
    %     Dx: Step size in x.
    %     Dy: Step size in y.
    %
    %     X: Size of the scan in X, calculated via (max(X) - min(X)).
    %     Y: Size of the scan in Y, calculated via (max(Y) - min(Y)).
    %
    %     xgrid: Grid of the x-data.
    %     ygrid: Grid of the y-data.
    %     zgrid: Grid of the z-data.
    % 
    pname = '';
    if nargin == 0
        [fname, pname] = uigetfile({...
                '*.sic;*.ras','SICM data files (*.sic, *.ras)'; ...
                '*.csv','comma seperated values (*.csv)'; ...
                '*.dat','arbitrary data files (*.dat)'; ...
                '*.*',  'All Files (*.*)'}, ...
                'Pick a file');
        if fname == 0
            return;
        end
        
    else
        fname = varargin{1};
    end
    
    fid = fopen([pname fname]);
    
    tmp = textscan(fid,'%s %s %s');
    SICM.x = str2double(strrep(tmp{1},',','.'));
    SICM.y = str2double(strrep(tmp{2},',','.'));
    SICM.z = str2double(strrep(tmp{3},',','.'));
    
    SICM.Dx =  SICM.x(find(SICM.x > SICM.x(1),1)) - SICM.x(1);
    SICM.Dy =  SICM.y(find(SICM.y > SICM.x(1),1)) - SICM.y(1);
    
    SICM.X = max(SICM.x)-min(SICM.x);
    SICM.Y = max(SICM.y)-min(SICM.y);
    
    [SICM.xgrid,SICM.ygrid] = meshgrid (min(SICM.x):SICM.Dx:max(SICM.x), min(SICM.y):SICM.Dy:max(SICM.y));
    
    SICM.zgrid = griddata(SICM.x, SICM.y, SICM.z, SICM.xgrid, SICM.ygrid);

    if nargout == 0
        fig = figure;
        surface(SICM.xgrid, SICM.ygrid,SICM.zgrid,'EdgeColor','none');
        SICM
        axis image;
    else
        varargout{1} = SICM;
    end
end