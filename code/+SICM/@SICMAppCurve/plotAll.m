function plotAll(self)
% Plots the data and the fit, if available
plot(self.xdata, self.ydata);
if ~isempty(self.fitobject)
    hold on;
    m = max([self.fitobject.D+0.001 min(self.xdata)]);
    x = linspace(m, max(self.xdata), 200);
    plot(x,feval(self.fitobject,x),'r--');
    hold off;
end
