function zgrid = planeCorrection(xdata, ydata, zdata, c1,c2,c3)

dx = (zdata(c2(1),c2(2)) - zdata(c1(1), c1(2)))/(xdata(c2(1),c2(2))-xdata(c1(1),c1(2)))
dy = (zdata(c3(1),c3(2)) - zdata(c1(1), c1(2)))/(ydata(c3(1),c3(2))-ydata(c1(1),c1(2)))

zgrid = zdata;
for i = 1:numel(xdata)
    zgrid(i) = zgrid(i)-dx*xdata(i)-dy*ydata(i);
end