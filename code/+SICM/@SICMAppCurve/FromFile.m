function o = FromFile(varargin) 
% Reads data from a file into a SICMAppCurve object
%
%    To allow importing different types of data, this functions
%    uses different importer functions. They are stored in the
%    constant importer property of the SICMScan class.
%
%    Examples:
%      obj = SICMAppCurve.FromFile
%
%      Opens a file dialog and reads the selected file in an
%      SICMSAppCurve object.
%
%      obj = SICMAppCurve.Fromfile(filename)
%      Reads the file `filename` into a SICMScan object
%
%    See also IMPORTER

    tmp = SICM.SICMAppCurve();
    if nargin == 0
        [finame, pname] = tmp.getFilename_();
        if finame == 0
            return
        end
        filename = fullfile(pname, finame);
    else
        filename = varargin{1};
    end
    o = tmp.getObjectFromFilename_(filename);
    delete(tmp);
    
end

