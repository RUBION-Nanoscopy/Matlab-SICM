classdef VAccordion < uix.VBoxFlex
    methods (Access = public)
        function self = VAccordion( varargin )
            %uix_add.VAccordion Vertical Accordion GUI element
            %
            %  acc = uix_add.VAccordion() constructs a vertical accordion.
            if nargin > 0
              %  uix.pvchk( varargin )
                set( self, varargin{:} )
                set( self, 'Spacing', 5);
            end
        end
    end
    methods ( Access = protected )

        function addChild( self, child )
            % Only boxpanels are allowed
            
            if ~isa(child, 'uix.BoxPanel')
                error( 'uix_add:InvalidChild', ...
                    'Only box Panels are allowed to be added to a VAccordion');
            end
            set(child, 'MinimizeFcn', @self.minimize_panel);
            addChild@uix.VBoxFlex( self, child );
        end
        function minimize_panel(self, event_src, ~)
            panels = get(self, 'children');
            panels = panels(end:-1:1);
            % loop through the parents until we find the box panel
            obj = event_src;    
            while ~any(panels == obj)
                obj = get(obj,'parent');
            end

            obj.Minimized = ~obj.Minimized;
            
            idx = find(panels == obj);
            heights = get(self, 'heights');
            
            if obj.Minimized 
                pos_obj = get(obj, 'position');
                get(obj,'Children');
                cum_pos = [0 0 0 0];
                for t = get(obj,'Children')
                    cum_pos = cum_pos + get(t, 'Position');
                end
                    
                heights(idx) = pos_obj(4)-cum_pos(4);

                
            else
                heights(idx) = -1;
            end

            set(self, 'Heights', heights);
            
            
        end
    end
end