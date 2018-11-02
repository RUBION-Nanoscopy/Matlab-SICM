function rmse = rmse(self)
% Computes the root of the mean of the squared error of the scan.
% Note that no flattening is applied. 
%
% This function is save to be used with NaNs in the data. 

mean_ = nanmean(self.zdata_grid(:));
diff_ = self.zdata_grid(:) - mean_;

rmse = sqrt(nanmean(diff_.^2));