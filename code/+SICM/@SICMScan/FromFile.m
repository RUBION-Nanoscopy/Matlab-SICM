function o = FromFile(varargin)
    % Reads data from a file into a SICMScan object
    %
    %    To allow importing different types of data, this functions
    %    uses different importer functions. They are stored in the
    %    constant importer property of the SICMScan class.
    %
    %    Examples:
    %      obj = SICMScan.FromFile
    %
    %      Opens a file dialog and reads the selected file in an
    %      SICMScan object.
    %
    %      obj = SICMScan.Fromfile(filename)
    %      Reads the file `filename` into a SICMScan object
    %
    %    See also IMPORTER
    
    % temporary  instance of the class
    tmp = SICM.SICMScan;
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
    o.info.filename = filename;
    delete(tmp);

end
