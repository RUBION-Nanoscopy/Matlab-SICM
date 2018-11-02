classdef SICMScan <  SICM.importer & matlab.mixin.Copyable
% This class provides tools to analyse, display and process SICM data.
%
% To generate an object `obj` of this class, use:
%
%    obj = SICMScan()
%
% However, this is rarely used. The static methods FROMFILE and
% FROMZDATAGRID return an object of this class that is populated with data.
% To test the class, FROMEXAMPLEDATA generates a SICMScan object with
% exemplary data.
%
% This class is inherited from the hiddenHandle class to simplify the
% programming since Matlab uses lazy copying otherwise.
% 
% See also FROMFILE, FROMZDATAGRID, FROMEXAMPLEDATA
    properties
        zdata_grid = NaN; % z-data of the scan as a grid
        starttime = NaN; % Start time of the scan in arbitrary time units
        endtime = NaN; % End time of the scan in arbitrary time units
        duration = NaN; % Scan duration
        info = struct();
    end
    properties (SetAccess = protected)
        approachcurves = []; % A grid holding SICM.AppCurves for all data points, if available.
        xsize = NaN; % Size of the scan in x-direction in length unit
        ysize = NaN; % Size of the scan in y-direction in length unit
        xpx = NaN; % number of pixels in x-direction
        ypx = NaN; % number of pixels in y-direction
        stepx = NaN; % size of a pixel in x-direction
        stepy = NaN; % size of a pixel in y-direction
        xdata_lin = NaN; % x-data of all data point in a onedimensional vector
        ydata_lin = NaN; % y-data of all data point in a onedimensional vector
        zdata_lin = NaN; % z-data of all data point in a onedimensional vector
        xdata_grid = NaN; % x-data of all data points as a grid
        ydata_grid = NaN; % y-data of all data points as a grid

    end
    properties (Dependent)

    end
    properties (Hidden)
        % The importers property holds information about the different
        % importer functions known in the system. The property is a cell
        % containing different structs. The strucs should look like the
        % following:
        %   'name':
        %    A name assigned to the importer, not yet used, just for
        %    internal information. 
        %
        %   'exts': 
        %   The extensions processed by the importer, as required for the
        %   uigetfile method 
        %
        %   'expl': 
        %   A short information about the file type(s), as required for
        %   uigetfile 
        %
        %   'extlist':
        %   A cell array containing the extensions (including the
        %   preceeding .) that can be processed by the importer. More or
        %   less the same as 'exts', but in a format that is can be used
        %   with strcmp to simplify finding the correct importer.
        %
        %   'handle':
        %   A function handle pointing to a funtion that reads the data.
        %   The function should have one input argument, the filename, and
        %   return an SICMScan object
        %
        % See also UIGETFILE, STRCMP, FUNCTIONS
        importers = {
            struct(...
                'name'   , 'Binary data import, PH', ...
                'exts'   , '*.sicm;',...
                'expl'   , 'Binary data files (*.sicm)',...
                'extlist', {'.sicm'},...
                'handle' , @SICM.readBinarySICMData...
            ),...
            struct(...  
                'name'   , 'ASCII data import, PH', ...
                'exts'   , '*.sic; *.ras;',...
                'expl'   , 'ASCII data files (*.sic, *.ras)',...
                'extlist', {{'.sic', '.ras'}},...
                'handle' , @local_ReadAsciiData...
            )...
        }
    end
    
    methods (Static)
        
        o = FromZDataGrid(zdatagrid)
        o = FromFile(varargin)
        o = FromExampleData()

        % The following functions are intended for internal use

        o = fromSICMScan_(obj)
    end
    
    methods (Access = public)

        function self = SICMScan(varargin)
            % Generate a SICMScan object
            %
            % This function generates an empty SICMScan object. In most
            % cases, you want to generate a SICMScan object from data or
            % from a file, see below.
            %
            % See also FROMZDATAGRID, FROMFILE
            %
            %
        end
    
        % 
        % Functions for completing the data. 
        %
        setPx (self, xpx, ypx)
        varargout = setXSize (self, xsize)
        varargout = setYSize (self, ysize)
        
        

        %
        % Functions for data manipulation
        %
        
        varargout = addXOffset(self, xoffset)
        varargout = addYOffset(self, yoffset)
        
        varargout = subtractMin(self)
        varargout = scaleZ(self, factor, varargin)
        varargout = scaleZDefault(self)
        
        varargout = flatten(self, method, varargin)
        varargout = normalize(self)
        
        varargout = applyMask(self, mask)
        
        % Functions to read an manipulate the approach curves
        varargout = readAllAppCurves(self, fhandle)
        varargout = eachAppCurve(self, handle)
        
        varargout = inverse(self);
        varargout = filter(self, method, varargin);
        varargout = crop(varargin);
        varargout = profile(self, varargin); 
        h = distance(self);
        
        d = slope(self, varargin);
        r = rms(self);
        
        varargout = interpolate(self, steps, varargin);
        varargout = interpolate_wrapper(self, method, steps);
        varargout = transposeXY(self);
        varargout = transposeAll(self);
        varargout = transposeZ(self);
        varargout = changeXY(self);
        
        
        %
        % Methods, mostly for display
        %

        varargout = surface(self, varargin)
        varargout = plot(self, varargin)
        varargout = imagesc(self)
        varargout = reviewAllApproachCurves(self);
        reviewProblematicFits(self, varargin);
        app = getAppCurve(self, idx, varargin);
        t = fduration(self, varargin);
        
        %
        % Methods for data analysing 
        %
        m = min(self);
        m = max(self);
        v = volume(self);
        c = centroid(self, threshold);
        a = area(self);
        rmse = rmse(self);
        r = roughness(self, varargin);
    end
    
    methods (Access = private)
        setXSize_(self, xsize)
        setYSize_(self, ysize)
        setPx_(self, xpx, ypx)
        varargout = generate_xygrids_(self, varargin)
        
        update_from_xsize_(self)
        update_from_ysize_(self)
        
        upd_zlin_(self)
        
        subtract_(self, what)
        multiply_(self, factor)
    end
end

function o = local_ReadAsciiData(filename)

    fid = fopen(filename);
    res = textscan(fid, '%s %s %s');
    fclose(fid);
    
    
    xlin = str2double(strrep(res{1}, ',', '.'));
    ylin = str2double(strrep(res{2}, ',', '.'));
    zlin = str2double(strrep(res{3}, ',', '.'));
    
    % There might be NaNs in xlin. Remove them.
    xlin(isnan(xlin)) = [];
    ylin(isnan(ylin)) = [];
    
    xoffset = min(xlin);
    yoffset = min(ylin);
    
    stepx = max(diff(xlin));
    stepy = max(diff(ylin));
    
    xpx = length(unique(xlin));
    ypx = length(unique(ylin));
    
    % Alas, a proper method SICMScan.FromLinearData(x,y,z) is missing...

    
    % Here, x and y is changed intentionally!
    [xg,yg] = meshgrid((0:xpx-1),(0:ypx-1));
    zg = griddata(xg(:),yg(:),zlin,xg,yg);
    
    o = SICM.SICMScan.FromZDataGrid(zg);
    o.setXSize(xpx*stepx);
    o.setYSize(ypx*stepy);
    o.addXOffset(xoffset);
    o.addYOffset(yoffset);
    
    
end
