function handle_keypress(self, event, keydata)
    keydata
    if isempty(keydata.Modifier)
        switch keydata.Key
        	case 'pagedown'
            	self.change_linepointer(1);
            case 'pageup'
            	self.change_linepointer(-1);
            case 'downarrow'
                self.change_threshold([-1 -1]);
            case 'uparrow'
                self.change_threshold([1 1]);
            case 'space'
                self.threshold = [.2 .2];
                self.manual_selection(:) = 0;
            case 'return'
                self.do_fit(true);
            case 'home'
                self.change_threshold([Inf Inf]);
            case 'end'
                self.change_threshold([-Inf -Inf]);
        end
       
    elseif numel(keydata.Modifier) == 1
        modifier = keydata.Modifier{1};
        if strcmp('control', modifier)
            switch keydata.Key
            	case 'downarrow'
                    self.change_threshold([ -1 0])
                case 'uparrow'
                            self.change_threshold([ 1 0 ])
            end
        elseif strcmp('alt', modifier)
            switch keydata.Key
                case 'downarrow'
                	self.change_threshold([ 0 -1])
                case 'uparrow'
                    self.change_threshold([ 0 1 ])
            end
        end
    end
end