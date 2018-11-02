function varargout = imagesc(self)

    a = imagesc(self.zdata_grid);
    
    if nargout == 1
        varargout{1} = a;
    end
end
