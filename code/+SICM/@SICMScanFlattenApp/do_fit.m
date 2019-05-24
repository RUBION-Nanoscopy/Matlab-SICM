function varargout = do_fit( self, apply )

    x = 1:numel(self.line);
    p = polyfit(x(self.selection), self.line(self.selection), 1);
               
    if apply
        self.Fits(self.linepointer, :) = p;
        self.Result(self.linepointer, :) = self.line - polyval(p, x);
        self.GUI.Axes.Profile.NextPlot = 'add';
        x2 = [min(x)-10 max(x)+10];
        plot(self.GUI.Axes.Profile, x2, polyval(p, x2), 'b-');
        self.GUI.Axes.Profile.NextPlot = 'replace';
    end
    if nargout > 0
        varargout{1} = polyval(p, x);
    end
    if nargout > 1
        varargout{2} = x;
    end
end