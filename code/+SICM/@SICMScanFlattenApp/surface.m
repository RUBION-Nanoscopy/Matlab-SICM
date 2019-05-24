function varargout = surface(self, ax, xg, yg, zg) 
    cla(ax);    
    plottype = 'height';
    if ax == self.GUI.Axes.Scan
        if strcmp(self.GUI.Controls.Menu.DataDisplaySlopeSlow.Checked, 'on')
            plottype = 'slow';
        end
        if strcmp(self.GUI.Controls.Menu.DataDisplaySlopeFast.Checked, 'on')
            plottype = 'fast';
        end
    elseif ax == self.GUI.Axes.Result
        if strcmp(self.GUI.Controls.Menu.ResultDisplaySlopeSlow.Checked, 'on')
            plottype = 'slow';
        end
        if strcmp(self.GUI.Controls.Menu.ResultDisplaySlopeFast.Checked, 'on')
            plottype = 'fast';
        end
    end
    switch plottype
        case 'height'
            pxg = xg; pyg = yg; pzg = zg;
        case 'fast'
            pxg = xg(:, 1:end-1); pyg = yg(:, 1:end-1); 
            pzg = diff(zg, 1, 2);
        case 'slow'
            pxg = xg(1:end-1, :); pyg = yg(1:end-1, :); 
            pzg = diff(zg, 1, 1);
            
    end
    ax.NextPlot = 'replace';
    sf = imagesc( ax, pzg );%surface(ax,pxg,pyg,pzg);
    %    sf.EdgeColor = 'none';
    %ax.XLim = [min(pxg(:)), max(pxg(:))];
    %ax.YLim = [min(pyg(:)), max(pyg(:))];
    %ax.DataAspectRatio = [1 1 1];
    ax.Position(3:4) = size(pzg);
    ax.Visible = 'off';
    ax.YDir = 'reverse';
    if ~strcmp(plottype, 'height')
        colormap(ax,gray);
        st = std(pzg(:));
        ax.CLim = [-st st];
    else
        ax.CLim = [min(pzg(:)) max(pzg(:))];
        colormap(ax,parula);
    end
    if nargout > 0
        varargout{1} = sf;
    end
end