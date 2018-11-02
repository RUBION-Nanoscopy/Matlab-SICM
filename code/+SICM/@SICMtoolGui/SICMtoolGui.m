%% Class SICMtoolGui
% Class for defining the Gui componnets of the SICM tool
%
%% Usage
% 
% This class is not intended for usage outside of the SICMtool. However,
% for testing purposes, it might be helpful to generate an instance of this
% class, that will show up the SICMtool GUI without any functionality.
%
% To generate an instance of the class, use
%%
%   foo = SICM.SICMToolGui

%% Code
% Note that the Gui components used here are from the GUI layout toolbox,
% which is hence required. The Gui layout toolbox can be found at
% <https://www.mathworks.com/matlabcentral/fileexchange/47982-gui-layout-toolbox Matl Fileexchange> 

classdef SICMtoolGui < matlab.mixin.Copyable
    properties (SetAccess = protected, GetAccess = public)
        %%  Gui components - Main Layout
        %
        main_figure     % Main window
        main_vbox       % Main vbox
        main_hbox       % Main hbox
        lower_hbox      % Smaller hbox at bottom
        
        %% Gui components - Main area
        % We will have nine axes, each in its own container. Layout will be
        % a vertical box with three horizontal boxes
        
        cn_vbox         % central vbox
        cn_hbox_row1    % hbox of first row       
        cn_hbox_row2    % hbox of second row
        cn_hbox_row3    % hbox of third row
        cn_axes_panels  % cell containing the panels for the axes
        cn_axes         % cell containing axes

        %% Gui components - Left sidebar
        % 
        
        ls_vbox         % Main vbox of the sidebar
        

        %%  Gui components - Right sidebar
        % 
        
        rs_accordion    % Accordion panel
        rs_table_cprop  % Computed properties
        rs_table_aprop  % Additiomnal properties
        rs_table_meta   % Meta data
        rs_top_boxpanel % top box panel in accordion
        rs_mid_boxpanel % middle box panel in accordion
        rs_bot_boxpanel % bottom box panel in accordion
        
        %% Menu
        % The components of the menu bar will are stored in this property.
        
        menu            % The contents of the menu bar
        %% Properties for internal use
        %
        future_sizes    % Cell array storing the size of the components that cannot be set during creation.
    end

    %% Constants
    
    properties (Constant)
        % Colors for the applications
        FOREGROUND_COLOR_FOCUSED = [1 1 1];
        BACKGROUND_COLOR_FOCUSED = [0 0 1];
        
        FOREGROUND_COLOR_ACTIVE = [1 1 1];
        BACKGROUND_COLOR_ACTIVE = [.5 .5 1];
        
        FOREGROUND_COLOR_INACTIVE = [.8 .8 .8];
        BACKGROUND_COLOR_INACTIVE = [.3 .3 .3];
    end
    
    methods (Access = public)
        function self = SICMtoolGui( menu_data )
            
            self.generate_gui( menu_data );
            drawnow();
            self.maximize_gui();
            % Some sizes area updated for the maximized figure
            drawnow();
            self.update_sizes();
        end
        
        function addPlot(self, scan, id)
            m = get(self.cn_axes{id}, 'UIContextMenu');
            self.cn_axes{id} = scan.surface(self.cn_axes{id});
            set(self.cn_axes{id}, 'UIContextMenu', m);
        end
        
        function setActivePlot(self, id)
       
            function deactivatePlot_local(ax)
                p = get(ax ,'parent');
                % ax might be the axis or the scan. Thus, if the parent
                % does  not have the corresponding properties, use the
                % parent's parent
                try
                    set(p, 'TitleColor', self.BACKGROUND_COLOR_INACTIVE);
                    set(p, 'ForegroundColor', self.FOREGROUND_COLOR_INACTIVE);    
                catch
                    set(get(p, 'parent'), 'TitleColor', self.BACKGROUND_COLOR_ACTIVE);
                    set(get(p, 'parent'), 'ForegroundColor', self.FOREGROUND_COLOR_ACTIVE);    
                end
            end
            
            cellfun(@deactivatePlot_local, self.cn_axes);
            drawnow();
            p = get(self.cn_axes{id},'parent');
            p = get(p, 'parent');
            set(p, 'TitleColor', self.BACKGROUND_COLOR_FOCUSED);
            set(p, 'ForegroundColor', self.FOREGROUND_COLOR_FOCUSED);
            drawnow();
        end
    end
    
    methods (Access = private)
        function generate_gui(self, menu_data)
            % First, generate the main figure window. 
            self.main_figure = figure(...
                'DockControls','off',...
                'MenuBar','none',...
                'ToolBar','none');
            
            % generate the main menu
            self.generate_menu( menu_data );
            % generate the layout containers
            self.generate_layout_containers();
            
            % populate the left sidebar
            self.populate_left_sidebar();
            
            % populate the main area
            self.populate_main_area();
            
            % populate the right sidebar
            self.populate_right_sidebar();
            
            % populate the statusbar
            self.populate_statusbar();
            
            % set the sizes of the components
            self.set_sizes();
        end
        
        function generate_menu(self, menu_data)
            % This function expetcs menu data to be a struct with a depth of
            % one (i.e., no nested menus are allowed yet), containing a cell
            % array of cell arrays. The latter one are in the form of
            % {label, callback, shortcut}. If the cell array is empty, a
            % separator is generated. The values for callback and shortcut
            % can be omitted. 
           
           
            items = fieldnames( menu_data );
            for item = items'
                m = uimenu(self.main_figure, 'Label', item{1});
                for i = 1 : size(menu_data.(item{1}), 2)
                    this = menu_data.(item{1}){i};
                    if size(this, 2) == 0
                        continue
                    end
                    cb = @NOP;
                    acc = '';
                    sep = 'off';
                    try %#ok<TRYNC> % One could use ... if i > 1
                        if size(menu_data.(item{1}){i-1}, 2) == 0
                            sep = 'on';
                        end
                    end
                    try   %#ok<TRYNC>
                        cb = this{2};
                    end
                    try  %#ok<TRYNC>
                        acc = this{3};
                    end
                    subm = uimenu(m, ...
                        'Label', this{1},...
                        'Callback', cb,...
                        'Accelerator', acc,...
                        'Separator', sep);
                   
               end
           end
           % self.menu = m;
        end
        
        
        
        function generate_layout_containers(self)
            
            % Shorthand for the main figure
            f = self.main_figure; 
            
            % First, a vertical box to split the window into two parts, the
            % main area and a statusbar
            vb = uix.VBox('Parent', f);
            self.register_size(vb, [-1, 20]);
            
            % Main HBox: 
            hb = uix.HBoxFlex('Parent', vb, 'Spacing', 5 );
            self.register_size(hb, [-1, -3, -1], [200, 0, 200]);
            
            % Lower HBox:
            hb2 = uix.HBox('Parent', vb);
            self.register_size(hb2, [-1, -4], [100, 0]);
            
            % Put shorthands into properties
            self.main_vbox = vb;            
            self.main_hbox = hb;
            self.lower_hbox = hb2;
            
            %Layout components of the left sidebar
            vb = uix.VBox('parent', self.main_hbox);
            self.ls_vbox = vb;
            
            % Layout components of the main area:
            
            vb = uix.VBox('parent', self.main_hbox);
                        
            hb1 = uix.HBox('parent', vb);
            hb2 = uix.HBox('parent', vb);
            hb3 = uix.HBox('parent', vb);
            
            for elem = [vb, hb1, hb2, hb3]
                self.register_size(elem, [-1 -1 -1]); 
            end
            
            self.cn_vbox = vb;
            self.cn_hbox_row1 = hb1;
            self.cn_hbox_row2 = hb2;
            self.cn_hbox_row3 = hb3;
            
            % Layout components of the right sidebar
            acc = uix_add.VAccordion('parent', self.main_hbox);
            
            self.rs_accordion = acc;
        end
        
        
        function populate_left_sidebar(self)
            uicontrol('parent', self.ls_vbox);
        end
        function populate_main_area(self)
            for i = 0 : 8
                row = floor(i/3) + 1;
                p = uix.BoxPanel(...
                    'fontsize', 10,...
                    'parent' , self.(sprintf('cn_hbox_row%i', row)), ...
                    'UIContextMenu', get_context_menu(), ...
                    'title',sprintf('Axis %i', i),...
                    'TitleColor', self.BACKGROUND_COLOR_INACTIVE,...
                    'ForegroundColor', self.FOREGROUND_COLOR_INACTIVE ...
                    );
                self.cn_axes_panels{i+1} = p;
                
                ax = axes('parent', p, 'UIContextMenu', get_context_menu());
                self.cn_axes{i+1} = ax;
            end
            
            function m = get_context_menu()
                 m = uicontextmenu();
                 g = uimenu(m, 'Label','Grow');
                 uimenu(g, 'Label','left');
                 uimenu(g, 'Label','right');
                 uimenu(g, 'Label','up');
                 uimenu(g, 'Label','down');
            end
                
        end
        
        function populate_right_sidebar(self)
            % this function creates the content of the right sidebar. The
            % sidebar consists of three uitables allowing to enter and/or
            % read properties of the data. The uitables are places in uix
            % box panels, which are placed in a uix vbox
            

            
            rows = 100;
            vb = self.rs_accordion;
            top_box = uix.BoxPanel(...
                'parent', vb, ...
                'Title', 'Computed Properties' ...
                );
            middle_box = uix.BoxPanel(...
                'parent', vb, ...
                'Title', 'Additional Properties'...
                );
            bottom_box = uix.BoxPanel(...
                'parent', vb, ...
                'Title', 'Meta data'...
                );
            con = uix.Panel('parent', top_box);
            
            t1 = uitable('parent', con, ...
                'ColumnFormat',  {'char', 'numeric'},...
                'ColumnName', {'Property','Value', '95% conf','unit'},...
                'RowName', {}, ...
                'Data', cell(rows, 4));
            con = uix.Panel('parent', middle_box);            
            t2 = uitable('parent', con, ...
                'ColumnFormat',  {'char', 'numeric'},...
                'ColumnName', {'Property','Value', '95% conf','unit'},...
                'RowName', {}, ...
                'ColumnEditable', ones(1,4) == 1, ...
                'Data', cell(rows, 4));
            con = uix.Panel('parent', bottom_box);            
            t3 = uitable('parent', con, ...
                'ColumnFormat',  {'char', 'char'},...
                'ColumnName', {'Property','Value', },...
                'RowName', {}, ...
                'ColumnEditable', ones(1,2) == 1, ...
                'Data', cell(rows, 2));
            
            % Fill the properties with the shorthands
            %self.rs_vbox = vb;
            self.rs_top_boxpanel = top_box;
            self.rs_mid_boxpanel = middle_box;
            self.rs_bot_boxpanel = bottom_box;
            self.rs_table_cprop  = t1;
            self.rs_table_aprop  = t2;
            self.rs_table_meta  = t3;
        end
            
        function populate_statusbar(self)
            outerMemoryHbox = uix.HBox( 'Parent', self.lower_hbox,...
                'Padding',5, ...
                'Spacing',0 ...
            );
            textStatusBar = uix.Panel('Parent', self.lower_hbox);
            usedMemoryBar = uix.Panel(...
                'Parent', outerMemoryHbox, ...
                'Padding',0, ...
                'BorderWidth', 0, ...
                'BackgroundColor','r');
            freeMemoryBar = uix.Panel(...
                'Parent', outerMemoryHbox, ...
                'Padding',0, ...
                'BorderWidth', 0, ...
                'BackgroundColor','g');
            self.register_size(outerMemoryHbox, [-.25, -.75]);
        end
        
        function maximize_gui(self)
            
            
            % There is an ugly bug in some JDK versions
            % regarding the rendering of the menu in maximized figures.
            % Thus, first we set the position of the main figure to be in
            % the upper left corner of the screen.
            
            movegui(self.main_figure,'northwest');
            
            % This maximizes the gui using the undocumented JavaFrame
            % property. The property will be removed and replaced by
            % web-based figures using the appdesigner.
            
            % switch off the warning. 
            warning('off','MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame');         
            jFig = get(handle(self.main_figure), 'JavaFrame'); 
            jFig.setMaximized(true);
            % switch the warninig on  again
            warning('on','MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame');
        end
        
        function register_size(self, obj, sz, varargin)
            minimum_size = zeros(size(sz));
            if nargin > 3
                minimum_size = varargin{1};
            end
            self.future_sizes{end +1} = {obj, sz, minimum_size}; 
        end
        
        function set_sizes(self)
            % This function loops through self.future_sizes and sets the
            % `Widths' or `Heights' property of the objects stored to the
            % values stored.
            
            for sz = self.future_sizes
                obj = sz{1,1}{1};
                if isprop(obj, 'Widths')
                    what = 'Widths';
                else
                    what = 'Heights';
                end
                set(obj, what, sz{1,1}{2}); 
                set(obj, sprintf('Minimum%s', what), sz{1,1}{3}); 
            end
            
            % Since now the values are set, we remove the entries
            
            self.future_sizes = {};
        end
        
        function update_sizes(self)
            % Update the column widths of the tables in the right sidebar
            drawnow();
            for t = [self.rs_table_aprop, self.rs_table_cprop, self.rs_table_meta]
                jScroll = findjobj(t);
                jTable = jScroll.getViewport.getView;
                jTable.setAutoResizeMode(jTable.AUTO_RESIZE_SUBSEQUENT_COLUMNS);
            end
        end
        
        
    end
        
end