classdef SICMToolManipulateSubtractMin < SICMoolDataManipulation %#ok<MCDIR>
    properties (SetAccess = protected, GetAccess = public)
        Name = 'Subtract Minimum'
        Weight = 100
        Parent_Name = '';
        Long = false;
    end
    methods (Access = public)
        function result = do(~, sicm, varargin )
            result = sicm.subtractMin();
        end
    end
end






        