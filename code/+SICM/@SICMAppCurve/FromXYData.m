function o = FromXYData(x,y)
% Returns a SCIMAppCurve object with the x and y data as provided by the
% two input arguments.

    o = SICM.SICMAppCurve;
    o.xdata = x;
    o.ydata = y;
