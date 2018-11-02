function reviewProblematicFits(self, varargin)
% Displays every approach curve the fitproblems property of which indicates
% fit problems. Shows a yes|no|cancel button to indicate whter the fit is
% ok.
    figure;
    sz = size(self.approachcurves);
    for i = 1:length(self.zdata_lin)
        app = self.getAppCurve(i);
        if app.fitproblems == 1
            app.plotAll();
            title(sprintf('Approach curve index %g (%g, %g)', ...
                i, ind2sub(sz,i)));
            if nargin == 2
                l = get(gca, 'XLim');
                t = varargin{1} * app.fitobject.I0;
                plot(l, [t t], 'k--');
            end
            hold off;
            choice = questdlg('Is the fit ok?', ...
            'Review fits', ...
            'Yes','No (Launch fit tool)','Cancel','No (Launch fit tool)');
        
            switch choice
                case 'Yes'
                    self.approachcurves{i}.fitIsOk();
                case 'No (Launch fit tool)'
                    app.fittool();
                    return
                case 'Cancel'
                    return
            end
        end
    end
end