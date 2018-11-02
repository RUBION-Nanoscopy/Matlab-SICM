% HierachicalListView
%
% Implements a collapsable list with different levels. 

classdef HierachicalListView < uix.Box
    
    properties (Access = private)
        heights 
    end
    
    pro
    methods (Access = public)
        function self = HierachicalListView(varargin)
            self.parse_input(varargin{:});
            
            
            
            
        end
        
        
    end
    
    methods (Access = protected)
        function foo = parse_input(self, varargin)
            p = inputParser();
            
            
            
            params.minimumHeight.default = 100;
            params.minimumHeight.check = @(x)(isnumeric(x));
            
            params.title.default = [];
            params.title.check = @(x)(ischar(x));
            
            params.titlecolor = [.75 .75 .75];
            
            params.titlefont = 'Helvetica';
            
            params.titlefontsize = 12;
            
            params.maxdepth.default = 3;
            params.maxdepth.check = @(x)(isnumeric(x) && (x > 0) && (round(x) == x));
            
            
            
            
        end
            
    end
end