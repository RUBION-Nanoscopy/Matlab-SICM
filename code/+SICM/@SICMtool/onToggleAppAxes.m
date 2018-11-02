function onToggleAppAxes ( self, elem, ~ , varargin)
    if strcmp( get(elem,'Checked'), 'on') == 1
        to = 'off';
        h = 0;
    else
        to = 'on';
        h = -1;
    end
    if nargin == 4
        to = varargin{1};
        h = 0;
        if strcmp( to, 'on' ) == 0
            h = -1;
        end
    end
    set(elem, 'Checked', to );
    set( self.gui.layout.hboxAppAxes, 'Visible', to );
    set( self.gui.layout.vboxAxes, 'Height', [-1 h]);
    
    