function subtract_(self, value)
% Internal function: Subractvalue from all z-data
    self.zdata_grid = self.zdata_grid - value;
    self.upd_zlin_()
end