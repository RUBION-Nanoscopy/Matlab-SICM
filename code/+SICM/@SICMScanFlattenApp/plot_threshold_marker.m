function plot_threshold_marker(self, x, y, direction)
    width = 10; height = 5;
    self.GUI.Axes.Profile.Units = 'pixels';
    % Pixels per unit
    ppux = self.GUI.Axes.Profile.Position(3) / diff(self.GUI.Axes.Profile.XLim);
    ppuy = self.GUI.Axes.Profile.Position(4) / diff(self.GUI.Axes.Profile.YLim);
    if direction > 0
        X = [ x-width/ppux, x-width/ppux, x];
        Y = [ y-height/ppuy, y+height/ppuy, y];
    else
        X = [ x+width/ppux,  x+width /ppux, x];
        Y = [ y+height/ppuy, y-height/ppuy, y];
    end
    patch(self.GUI.Axes.Profile, ...
        'XData', X, ...
        'YData', Y, ...
        'FaceColor', [0 0 0] ...
    );
end