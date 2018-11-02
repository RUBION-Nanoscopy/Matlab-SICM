function varargout = scaleZDefault(self)
    % Scales the z-data
    %
    % Scales the data by the factor 100/2^16, as we use it for our SICM.
    %
    % Examples:
    %    obj.scaleZDefault()

    if nargout == 0
        self.scaleZ(100/2^16);
    else
        o = SICM.SICMScan.fromSICMScan_(self);
        o.scaleZDefault;
        varargout{1} = o;
    end
end

%+BEGIN GUIMETADATA: Do not delete
%+GMD Type: 'meth'
%+GMD Name: 'Apply default scale'
%+GMD FixedArgs: {}
%+GMD VarArgs: {}
%+GMD Depends: {}
%+GMD Changes: {'z'}
%+GMD Immediate: 0
%+GMD Menu: 'Simple Manipulations'
%+END GUIMETADATA