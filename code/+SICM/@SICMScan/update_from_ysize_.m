function update_from_ysize_(self)
% Internal function: Updates every data related to the y-coordinate
    self.stepy = self.ysize / self.ypx;
    [xg, yg] = self.generate_xygrids_();
    self.ydata_grid = yg';
    self.ydata_lin = self.ydata_grid(:);
end