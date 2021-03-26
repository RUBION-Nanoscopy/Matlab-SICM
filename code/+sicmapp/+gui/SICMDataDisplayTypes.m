classdef SICMDataDisplayTypes
    properties
        Text
    end
    enumeration
        HEIGHT2D('Height 2D') 
        HEIGHT3D('Height 3D')
        SLOPE('Slope')
    end
    
    methods 
        function self = SICMDataDisplayTypes(txt)
            self.Text = txt;
        end
    end
end