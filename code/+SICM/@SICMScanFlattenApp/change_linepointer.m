function change_linepointer( self, amount )
    sgn = sign(amount);
    sz = size(self.Scan.zdata_grid);
            
    tmp = self.linepointer + sgn;
            
    if tmp > sz(2) 
    	tmp = 1;
    elseif tmp < 1
    	tmp = sz(2);
    end
            
    self.linepointer = tmp;
end