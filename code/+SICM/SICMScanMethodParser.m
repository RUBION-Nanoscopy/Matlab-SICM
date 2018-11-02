classdef SICMScanMethodParser
    properties 
        func
        fname
        path_to_SICMScan
        can_be_parsed
        
        expr = '%\+GMD([A-Za-z\ '':{}()0-9,@]*)';
        
        expr2 = '\s+(\w+)\s*:\s*([\ ''a-zA-Z{}0-9,@()]+)'
    end
    methods
        function self = SICMScanMethodParser( func )  
            [self.path_to_SICMScan,~,~] = fileparts(which('SICM.SICMScan'));
            self.func = func;
            self.fname = fullfile(...
                self.path_to_SICMScan, sprintf('%s.m',self.func));
            self.can_be_parsed = (...
                exist(self.fname, 'file') == 2 ...
            );
        end
        function md = getMethodDescription( self )
            if ~self.can_be_parsed
                md = SICM.EmptySICMScanMethodDescription();
                return
            end
            content = fileread(self.fname);
            matches = regexp(content, self.expr, 'match');
            if isempty(matches)
                md = SICM.EmptySICMScanMethodDescription();
                return
            end
            md = SICM.SICMScanMethodDescription;
            for mtch = matches
                %fprintf('Parsing: %s\n', mtch{1});
                res = regexp(mtch, self.expr2, 'tokens');
                r = res{1}(1);
                key = char(r{1}(1));
                val = eval(char(r{1}(2)));
                md.func = self.func;
                try
                    md.(key) = val;
                end
            end
            
            
        end
    end
end