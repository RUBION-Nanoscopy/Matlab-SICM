classdef SICMToolDataHandling <  matlab.mixin.Copyable
    
    
    properties (SetAccess = protected, GetAccess = public)
        
        % A cell array that holds all the data.
        data
        
        % A pointer  to the current data 
        
        current = NaN;
        
    end
    
    methods (Access = public)
    % Contructor
        function self = SICMToolDataHandling()
            self.data = {};
        end
        
        function id = addData ( self, data )
            id = size(self.data,2) + 1;
            self.data{ id } = struct(...
                'data', {data}, ...
                'dirty', false, ...
                'id', id ...
            );
        
            self.current = id;
        end
        
        function data = getCurrent( self )
            data = self.data{ self.current };
        end
        
        function data = getCurrentData( self )
        	foo = self.data{ self.current };
            data = foo.data;
        end
        
        function applyToCurrent( self, what, varargin )
            self.apply_to(self.current, what, varargin{:});
        end
        
    end
    
    methods (Access = protected)
        function apply_to(self, id, what, varargin)
            obj = self.data{id}.data;
            try
                obj.(what)(varargin{:});
            catch
                
            end
        end
        
        
    end
    
end