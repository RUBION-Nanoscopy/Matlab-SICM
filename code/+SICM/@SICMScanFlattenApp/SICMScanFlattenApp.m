classdef SICMScanFlattenApp < handle
% SICMSCANFLATTENAPP A GUI that allows to manually flatten a SICM scan. 
% 
%
    properties
        Orig SICM.SICMScan
        Scan SICM.SICMScan
        Fits
        Figure matlab.ui.Figure
        GUI = struct()
        ROIs = {}         
        
    end
    
    properties % Callbacks
        CloseCallback
    end
    properties ( SetAccess = protected )
        line
        selection
        old_selection
        manual_selection
        linemarker
        
        excluded
    end
    
    properties ( SetAccess = protected, SetObservable )
        linepointer int16
        Result
        threshold = [NaN NaN]
        
    end

        

    
    methods
        function self = SICMScanFlattenApp( scan )
            self.Orig = scan;
                
            self.GUI.Controls = struct();
            self.GUI.Axes = struct();
            
            self.init();
            
            self.Figure.Visible = true;
        end
        
    end
    
    methods ( Access = protected )
        % This App is intended to be just a short one. I don't use the MVC
        % approach here. GUI is based on uix-classes.
        
        
        function init( self )
            self.build_GUI();
            self.Scan = self.Orig;
            self.Result = self.Scan.zdata_grid - self.Scan.min;
            self.Fits = zeros(size(self.Result, 1), 2);
            self.update_scan();
            self.update_result();
            self.linepointer = 1;
            self.update_profile();
            
            self.set_callbacks();
        end
        
        % GUI buildung
        
        build_GUI(self)
        make_menu( self )
        make_toolbar( self )
        make_buttons( self, bboxes  )
        set_callbacks( self )
        
            
        
        
        
        % Event handlers
        handle_keypress(self, event, keydata)
        exec_close_request(self)
        
        % Update functions 
        
        function update( self ); end
        
        update_result ( self )
        update_scan( self )
        update_profile( self )
        
        
        
        update_threshold(self)
        
        
        % Change internal properties
        
        change_linepointer( self, amount )
        change_threshold(self, dirs)
        
        % Changing base data
        
        result_as_base(selfg)
        
        scan = result_as_SICMScan(self)
        % filtering
        
        filter( self, filter, varargin )
        % Plot functions
        plot_line(self, varargin)
        plot_threshold_marker (self, x, y, direction)
        varargout = surface(self, ax, xg,yg,zg) 
        
        % Fitting
        
        varargout = do_fit ( self, apply )
        do_fit_lines( self )
        fit_magic( self )
        % ROI handling
        
        add_roi( self, ax )
    end
    
end