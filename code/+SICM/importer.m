classdef importer < matlab.mixin.Copyable
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
        %importers = {};
     end
     methods 
         function self = importer()
         end
         function [fname, pname] = getFilename_(self) 
         % Internal function
         %    This function displays a file selector according to
         %    the filetypes that can be imported
         %
         %    See also IMPORTERS
            filter = {};
            l = length(self.importers);
            
            for i = 1:l
                filter{i,1} = self.importers{i}.exts;
                filter{i,2} = self.importers{i}.expl;
            end
                [fname, pname] = uigetfile(filter,...
                'Pick a file');
         end
         
         function o = getObjectFromFilename_(self, filename)
            [~, ~, e] = fileparts(filename);
            for i = 1:length(self.importers)
                if sum(strcmp(e, self.importers{i}.extlist)) > 0
                    o = self.importers{i}.handle(filename);
                    return
                end
            end
         end
    end
end