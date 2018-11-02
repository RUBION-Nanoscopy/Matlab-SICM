%% Class SICMToolDataManipulation
% This class is an abstract interface for DataManipulation classes of SICM
% data. Derive your Data Manipulation Tools from this class to make it
% appear in the menu etc.

classdef (Abstract) SICMToolDataManipulation
    
    methods (Abstract)
        % The only method that is required is a `do' method. It will always
        % receive the SICMScan object as input. Furthermore, varargin might
        % hold additional data such as the current selected ROI. If you
        % need further information, ask the user for it.
        % It is not neccessary that the function returns a new SICMScan
        % object (it will work on a copy anyway), but if it returns one,
        % the original SICMScan object will be lost (until you store it
        % somewhere)
        
        result = do(sicm, varargin);
    end
    
    methods (Static)
        % Use this static function to register your
        % DataManipulationClasses. It receives the Class (not an instance
        % of it!) as input
        function register(kls)
            % We will spam the global context
            global SICMToolDataManipulationCollector(end+1) = kls;
        end
    end
    
    properties (Abstract)
        % (String) A human-readable name for the tool
        Name;
        
        % (String) The name of the Sub-Menu where this item should be
        % located. It is added if this name already existed, otherwise it
        % is generated.
        Parent_Name;
        
        % (Number) Sub-Menu Items will be ordered according to this weight,
        % with the lightest first, 
        Weight;
        
        % (Boolean) Indicates whther the computation might take long 
        Long;
        
    end
end

