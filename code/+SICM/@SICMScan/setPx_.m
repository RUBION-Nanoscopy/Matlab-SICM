function setPx_(self, xpx, ypx)
% Internal function: Sets properties xpx and ypx and the corresponding
% grids
    self.xpx = xpx;
    self.ypx = ypx;
    self.generate_xygrids_();
end
