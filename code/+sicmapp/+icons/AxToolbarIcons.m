classdef AxToolbarIcons
    properties 
        Image
        FileName
    end
    enumeration
        SHOWHIDECONTENT2('file-image-fill.png', true)
        SHOWHIDECONTENT('file-image.png', true)
        ZAUTOMODE('arrows-expand.png', true)
        DISPLAYTYPE('badge-3d.png', true);
    end
    methods
        function self = AxToolbarIcons(fname, inverse)
            p = self.getLocation();
            self.FileName = [p filesep 'pngs' filesep fname];
            [~,~, alpha] = imread(self.FileName);
             
            self.Image = repmat(double(alpha),3);
            if inverse
                self.Image = uint8(abs(double(self.Image)-63));
            end
        end
        function [p,f,e] = getLocation(self)
            [p,f,e] = fileparts(which(class(self)));
        end
    end
    
end