function l = reviewAllApproachCurves(self)
% Displays every approach curve and asks whether the index of the curve
% should be saved. an array of the saved indices will be returned.

    sz = size(self.approachcurves);
    l = ones(1,length(self.zdata_lin)) * NaN;
    for i = 1:length(self.zdata_lin)
        plot(self.approachcurves{sub2ind(sz,i)});
        choice = questdlg('Save the index of the curve?', ...
            'Review approach curves', ...
            'Yes','No','Cancel','No');
        
        switch choice
            case 'Yes'
                l(i) = 1;
        
            case 'Cancel'
            	return
        end
        l = find(l==1);
    end
end