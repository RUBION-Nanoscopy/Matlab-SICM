classdef SICMAppCurve < SICM.importer & matlab.mixin.Copyable
% This class provides tools to analyse and process SICM approach curves.


    properties (SetAccess = protected, SetObservable)
        xdata = NaN; % holds the x-data, that is the piezo extension
        ydata = NaN; % holds the voltage data
        mode = NaN; % VC or CC mode
        direction = NaN; % Was the piezo increasing or decreasing...
        fitobject = []; % Holds thh fit object, once the method `fit`has been called.
        filename = NaN;
        FallRate = NaN;
        Threshold = NaN;
        info = struct;
        SamplingRate = NaN;
    end
    
    properties (Hidden)
        importers = {...
            struct(...
                'name'   , 'AscII importer, PH', ...
                'exts'   , '*.sic;',...
                'expl'   , 'Two-column ASCII data files (*.sic)',...
                'extlist', {'.sic'},...
                'handle' , @local_ImportAscii_sic...
            ),...
            struct(...
                'name'   , 'AscII importer for ac files, PH', ...
                'exts'   , '*.ac;',...
                'expl'   , 'Three-column ASCII data files (*.ac)',...
                'extlist', {'.ac'},...
                'handle' , @local_ImportAscii_ac...
            ),...
            struct(...
                'name'   , 'Binary Importer, AG', ...
                'exts'   , '*.sicm;',...
                'expl'   , 'Binary Data (*.sicm)',...
                'extlist', {'.sicm'},...
                'handle' , @local_ImportBinary_sicm...
            ),...
        }
        fitfunc = []; %holds the fit function...
        inversefitfunc = []; % holds the inversed fit function
        fitproblems = 0;
    end
    
    properties (Constant)
        modes = struct(...
            'VC', 0, ...% Voltage Clamp mode
            'CC', 1  ...% Current Clamp mode
        ); 
        directions = struct(...
            'INC', 0, ...
            'DEC', 1 ...
        );
    end

    methods (Static)
       o = FromFile(varargin)
       o = FromXYData(x,y)
       o = FromXYData_info(x,y,FallRate,Threshold)
       
       % internal functions...
       o = fromSICMAppCurve_(obj)
    end
    methods (Access = public)
        % Constructor
        function self = SICMAppCurve()
        % Generates an empty SICMAppCurve object. Rarely used. The static
        % methods FROMFILE and FROMXYDATA generate a SICMAppCurve object
        % that contains data.
        %
        % See also FROMFILE, FROMXYDATA
        end
        
        % Methods to describe the data:
        
        varargout = setMode(self, mode)
        varargout = setDirection(self, direction)
        varargout = setFitFunc(self, handle)
        
        % Methods to manipulate the data
        
        varargout = normalize(self, varargin)
        varargout = inverse(self)
        varargout = reverse(self)
        varargout = autoDetectSamplingRate( self, varargin )
        scaleX (self, factor, varargin);
        scaleY (self, factor, varargin);
        
        varargout = shiftX( self, offset );
        varargout = shiftY( self, offset );
        
        varargout = addInfo( self, info, value);
        % Methods to analyse the data automaticlly
        
        varargout = guessCurveType(self, varargin);
        varargout = guessMode(self, varargin);
        varargout = guessDirection(self, varargin);
        varargout = guessFitFunc(self, varargin);
        varargout = setSamplingRate(self, rate);
        % Methods to visualize the data
        varargout = plot(self, varargin);
        varargout = filter(self, varargin);
        varargout = frequencyPlot(self);
        % fitting
        
        varargout = fit(self, varargin);
        varargout = fitToThreshold(self, T);
        fitIsOk(self);
    end
    methods (Access = protected)
        [I0, C, D] = guessStartPoint(self);
        b = returnValIfVarArgEmpty_(self, val, varargin);
    end
end


% Importer functions

function o = local_ImportAscii_sic(filename)
	fid = fopen(filename);
    res = textscan(fid, '%s %s','headerLines',1);
    % text import is always a bit ugly...
    o = SICM.SICMAppCurve.FromXYData(...
        str2double(strrep(res{2}(:,1),',','.')),...
        str2double(strrep(res{1}(:,1),',','.')));
end

function o = local_ImportAscii_ac(filename)
	fid = fopen(filename);
    
    res = textscan(fid, '%s %s %s','headerLines',1);
    % This import throws away the resistance data
    o = SICM.SICMAppCurve.FromXYData(...
        str2double(strrep(res{1}(:,1),',','.')),...
        str2double(strrep(res{3}(:,1),',','.')));
end

function o = local_ImportBinary_sicm(filename)
    [~,purefilename,~] = fileparts(filename);    
    tempdirname = tempname;
    gunzip(filename, tempdirname);
    untar([tempdirname filesep purefilename], tempdirname);
    
    filelist = dir(tempdirname);
    
    % information about the size etc. are stored in json format in a file
    % called settings.json
    fid = fopen([tempdirname filesep 'settings.json']);
    cjson = textscan(fid,'%s');
    fclose(fid);
    sjson = cjson{1}{1};
    info = parse_json(sjson);
    
    for i=1:size(filelist,1)
        [~,purefilename2,ext] = fileparts(filelist(i).name);
        if isempty(ext) && ~strcmp(purefilename2, purefilename)
            datafile = purefilename2;
        end
    end
    
    fid = fopen([tempdirname filesep datafile]);
    data = fread(fid,'uint16');
    rmdir(tempdirname, 's');

    o = SICM.SICMAppCurve.FromXYData(...
        (1:length(data))', ...
        double(data));
    o.info = info;
    o.filename = filename;
    try  %#ok<TRYNC>
        o.FallRate = str2double(info.FallRate);
    end
    try %#ok<TRYNC>
        o.Threshold = str2double(info.Threshold)/100;
    end
end