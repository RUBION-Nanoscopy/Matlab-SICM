classdef importer
% Helper class that provides a simple data import interface. Inherit your
% classes from this class.
%
     properties (Constant, Hidden)
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
        %   A fundtion handle pointing to a funtion that reads the data.
        %   The function should have one input argument, the filename, and
        %   return an SICMScan object
        %
        % See also UIGETFILE, STRCMP, FUNCTIONS
        importers = {};
     end
     methods (Static)
         function [fname, pname] = getFilename_()
         % Internal function
         %    This function displays a file selector according to
         %    the filetypes that can be imported
         %
         %    See also IMPORTERS
            filter = {};
            l = length(SICM.SICMScan.importers);
            for i = 1:l
                filter = {filter{:}; SICM.SICMScan.importers{i}.exts, ...
                SICM.SICMScan.importers{i}.expl};
            end
                [fname, pname] = uigetfile(filter,...
                'Pick a file');
         end
    end
end