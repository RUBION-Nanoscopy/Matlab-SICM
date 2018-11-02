function update_from_xsize_(self)
% Internal function: Updates every data related to the x-coordinate.
    self.stepx = self.xsize / self.xpx;
    [xg, yg] = self.generate_xygrids_();
    self.xdata_grid = xg';
    self.xdata_lin = self.xdata_grid(:);
end