%% Class SICMtoolSettings
% A class that manages the settings for the SICMtool.

% Settings are defined by a simple syntax. Settings are passed as cell
% arrays containing the following information using a key, value syntax.
%
%% 
%    setting = { 'group', group, ...
%                'type', type, ...
%                'label', label, ...
%                'default', default, ...
%                 optional type specific information }
%
% The meaning of the single components is
%
%    *group*:   A string displaying the hierachical structure of the
%               setting, single hierachies are separated by a dot. For
%               example, if you want to define a setting that sets the
%               background color of the quit-entry in a file menu, group
%               could be |menu.file.quit.bgcolor|.
%
%    *type*:    The content allowed for this setting, could be one of 
%               'numeric', 'int', 'bool', 'char', 'color', 'file',
%               'directory' 
%
%    *label*:   The text of the label of the input field
%
%    *default*: The default value
%
%    *type specific information*: Depending on the |type| you use, some
%               more information might be provided or even required. 
%
%
% How to use the class:
%
%    

classdef SICMtoolSettings < dynamicprops
    properties (Hidden)
        settings_file
    end
    
    methods (Access = public)
        function self = SICMtoolSettings(filename)
            self.settings_file = filename;
            if exist(filename, 'file') ~= 2
                self.touch();
            else
                self.parse_file();
            end
        end
    end
    
    methods (Access = protected)
        function touch(self)
            [p, ~, ~] = fileparts(self.settings_file);
            mkdir(p);
            fclose(fopen(self.settings_file,'w'));
        end
        
        function parse_file(self)
            fid = fopen(self.settings_file, 'r');
                finished = 0;
                while ~finished
                    line = fgetl(fid);
                    if ischar(line) 
                        line = strtrim(line);
                        if strcmp(line, '') == 1 || strcmp(line(1), '#') == 1
                            continue
                        end
                        self.add_setting_from_file(line);
                    else 
                        finished = 1;
                    end
                end
                
            fclose(fid);
        end
        
        function add_setting_from_file(self, line)
            % First check the syntax of the line (will issue an error if
            % something is strange)
            
            content = self.pre_parse_input_line(line);
            tokens = regexp(content, ',', 'split');
            prop = NaN;
            type = NaN;
            label = NaN;
            value = NaN;
            default = NaN;
            for i = 1:2:size(tokens,2)
                switch strtrim(lower(cell2mat(tokens(i))))
                    case 'group'
                         components = regexp(tokens(i+1), '\.', 'split');
                         prop = strtrim(components{1}{1});
                         fields = components{1}(2:end)
                    case 'value'
                        value = tokens(i+1);
                    case 'type'
                        type =  cell2mat(tokens(i+1));
                    case 'label'
                        label = cell2mat(tokens(i+1));
                    case 'default'
                        default = cell2mat(tokens(i+1));
                end
            end
            
            % Check if we have sufficient information
            self.check_for_sufficient_data(prop, type, label, default);
            
            if ~isnan(value) 
                val = value; 
            else
                val = default;
            end;
            if ~isprop(self, prop)
                addprop(self, prop);
            end
            if size(fields,2) > 0
                o = struct(fields{end}, val);
                for field = fields(end - 1: -1 : 1)
                    tmp.(field{1}) = o;
                    o = tmp;
                    tmp = [];
                end
                self.(prop)=o;
            else
                self.(prop)=val;
            end
            
        end
        
        function check_for_sufficient_data(~, prop, type, label, default)
            if isnan(prop)
                error('SICMtoolSettings:InvalidSyntax',...
                    'A `group` field is required');
            end
            if isnan(type)
                error('SICMtoolSettings:InvalidSyntax',...
                    'A `type` field is required');
            end
            if isnan(label)
                error('SICMtoolSettings:InvalidSyntax',...
                    'A `label` field is required');
            end
            if isnan(default)
                error('SICMtoolSettings:InvalidSyntax',...
                    'A  `default` field is required');
            end
        end
            
        function token = pre_parse_input_line(~, line)
            % We parse the input from the file. Since we are a bit
            % paranoid, we add some minor syntax checks.
            %
            % If everythin is fine, the line without the curly braces is
            % returned.
            
            expr = '{(.*?)}';
            tokens = regexp (line, expr, 'tokens');
            if size(tokens,2) < 1
                warning('SICMtoolSettings:InvalidSyntax', ...
                    'Line seems not to match the syntax. Skipping it.');
                return
            end
            if size(tokens,2) > 1
                error('SICMtoolSettings:InvalidSyntax', ...
                    'Only one pair of curly braces is allowed per line in the config file');
            end
            if numel(line) - numel(tokens{1}{1}) ~= 2
                error('SICMtoolSettings:InvalidSyntax', ...
                    'No characters beyond the closing curly brace are allowed.');
            end    
            token = tokens{1}{1};
        end
    end
end