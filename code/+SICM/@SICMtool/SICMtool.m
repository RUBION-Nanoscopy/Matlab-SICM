%% Class SICMtool
% 
% Generates the graphical SICM interface.
%
%% Usage
%
% To start the GUI, create an instance of this class by calling
% 
%%
%   gui = SICMTool()
%
%%
% or use the function |sicmtool| for this.
%
%% Information on the code
% 
% This class file uses the matlab syntax for publishing |.m|-files for
% Documentation.  I use the variable |self| to reference to the object,
% rather than |obj| or |app|, which is sometimes found in Matlab code and
% documentation. Furthermore, the following scheme is used: |camelCased|
% names (starting with a lowercase letter) are public,
% |names_with_underscores|  are private or protected. If a property or a
% method name is private, but only a single word, an underscore is added at
% the end.
%
%% Code
%

classdef SICMtool < matlab.mixin.Copyable
    %% Properties 
    properties (SetAccess = protected, GetAccess = public)
        %%
        % *GUI*
        %
        % The Gui components are defined in the class |SICMtoolGui|. An
        % instance of this class is available as the read-only property
        % |gui|. 
        gui % Holds the Gui components
        
        %% 
        % *History*
        %
        % The tool has a limited history for undoing operations. The
        % corresponding class instance is kept in the property |history|.
        history % holds the history
        
        %%
        % *Data*
        %
        % The property |data| stores an instance of |SICMtoolDataHandling|
        dataManager % Holds the data manager
        
        %% 
        % *Settings*
        %
        % The class that handles the settings
        
        settings % Holds the settings manager
        settings_filename = '../../config/sicmtool.cfg' % The file that stores the settings, relative to the path of this file
    end
    
    properties (SetAccess = protected, GetAccess = protected)
        %% 
        % *Menu*
        %
        % This struct holds the menu components.

        menu_data 
        
        %%
        % *Timer*
        %
        % We will have a timer that runs every 500ms. Use
        % |registerTimerCallback| to add a callback
        
        timer
        
        % The callbacks
        
        timer_cb
    end
    
    %% Methods - Constructor
    % 
    methods  (Access = public)
        
        function self = SICMtool()
        %%
        % Generate an instance of the SICMtoolGui class
            self.generate_menu();
            self.gui = SICM.SICMtoolGui( self.menu_data );
            
        % Generate an instance of the settings class
            [p, ~, ~] = fileparts(mfilename('fullpath'));
            self.settings = SICM.SICMtoolSettings(...
                fullfile(p, self.settings_filename));
            
        % Generate the timer
        self.timer = timer( ...
            'BusyMode', 'queue', ...
            'ExecutionMode', 'fixedSpacing',...
            'Name', 'SICMTool-timer',...
            'Period', .5, ...
            'TimerFcn', @self.execute_timer ...
        );
        
        % add additional components
        self.add_components();
        
        self.dataManager = SICM.SICMToolDataHandling();
        % 
        set(self.gui.main_figure, 'CloseRequestFcn', @self.onMainFigure_close);
        
        % Start the timer
        start(self.timer);
        end
    end
    
    methods (Access = protected)
    %% Methods - Callbacks for Main menu
    % The methods are stored in separate files. Use |doc SICMtool| to get
    % easy access to the single functions.

        % File Menu
        onMenu_File_New(self);
        onMenu_File_Open(self, elem, action);
        onMenu_File_Save(self, elem, action);
        onMenu_File_SaveAs(self, elem, action);
        onMenu_File_Export(self, elem, action);
        onMenu_File_ImportFromFile(self, elem, action);
        onMenu_File_ImportFromWorkspace(self, elem, action);
        onMenu_File_Close(self, elem, action);
        onMenu_File_Quit(self, elem, action);
    
        % View menu
        onMenu_View_OneAxis(self, elem, action);
        onMenu_View_TwoAxis_vertical(self, elem, action);
        onMenu_View_TwoAxis_horizontal(self, elem, action);
        onMenu_View_OneLargeAxis_top_twoSmallAxis_bottom(self, elem, action);      
        onMenu_View_2x2(self, elem, action);      
        onMenu_View_3x3(self, elem, action);      
        
    %% Methods - Setting the main menu
    % 
        generate_menu(self)
        
        
        function execute_timer(self, varargin)
            for cb = 1:length(self.timer_cb)
                self.timer_cb{cb}();
            end
        end
        function update_memory(self)
            r = java.lang.Runtime.getRuntime;
            free = r.freeMemory;
            used = r.totalMemory - free;
            con = get(self.gui.lower_hbox,'Contents');
            memoryIndicator = con(1);
            set(memoryIndicator, 'Width', [-1*used, -1*free]);
        end
        
        function add_components(self)
            self.registerTimerCallback(@self.update_memory);
            
        end
    end
    methods (Access = public)
        function registerTimerCallback(self, cb)
            self.timer_cb{ end + 1 } = cb;
        end
    
        function onMainFigure_close(self, varargin)
            self.delete();
        end
    
        function delete(self)
            stop(self.timer);
            delete(self.timer);
            delete(self.gui.main_figure);
        end
        
    end
end