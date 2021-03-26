classdef SICMAppSVGIcons
    properties 
        FileName
    end
    enumeration
        FOLDER('folder.svg')
        FOLDERCHECK('folder-check.svg')
        SQUARECHECK('check-square.svg')
        SQUARE('square.svg');
    end
    methods
        function self = SICMAppSVGIcons(fname)
            [p,~,~] = fileparts(which(class(self)));

            
            self.FileName = [p filesep 'svgs' filesep fname];
        end
    end
    
end