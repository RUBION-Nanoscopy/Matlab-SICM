function multiply_(self, factor)
% Internal function: Multiply every z-value by factor
    self.zdata_grid = self.zdata_grid*factor;
    self.upd_zlin_();
end