function varargout = subtractMin(self)
    % Subtract the minimum in the data set from all data points.
    %
    % Examples:
    %    obj.subtractMin()
    %   
    %    Subtracts the minimum value from obj.zdata_lin and
    %    obj.zdata_grid 
    %
    %    newobj = obj.subtractMin()
    %
    %    As above, but returns a new object and does not alter
    %    `obj`
    %
    % See also MIN
    if nargout == 0
        self.subtract_(min(self.zdata_lin));
    else
        o = SICM.SICMScan.fromSICMScan_(self);
        o.subtractMin();
        varargout{1} = o;
    end
end    

%+BEGIN GUIMETADATA: Do not delete
%+GMD Type: 'meth'
%+GMD Name: 'Subtract minimum'
%+GMD FixedArgs: {}
%+GMD VarArgs: {}
%+GMD Depends: {}
%+GMD Changes: {'z'}
%+GMD Immediate: 0
%+GMD Menu: 'Simple Manipulations'
%+END GUIMETADATA