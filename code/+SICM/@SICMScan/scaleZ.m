function varargout = scaleZ(self, factor, varargin)
    % Scales the z-data
    %
    % Scales the data by `factor`
    %
    % Examples:
    %    obj.scale(factor)
    %
    %    Scales the data by `factor`.
    %
    %    newobj = obj.scale(factor)
    %     
    %    As above, but returns a new object instead of altering
    %    obj.
    %
    %    newobj = obj.scale(2, offset)
    %
    %    This first subtracts `offset` from the data, than scales
    %    it by a factor of 2.
    %    This is useful to transfer the data from binary values to
    %    micrometers. Assume that in a setup the DC card  maps -10V
    %    to 10V to 2^16 bits. The piezo maps 0V to 10V to 100µm.
    %    The data will be between 2^15 and 2^16. To transfer the
    %    data from binary to true lengths, use:
    %    obj.scale(100/(2^16-2^15), 2^15)
    if nargout == 0
        if nargin > 2
            self.subtract_(varargin{1});
        end
        self.multiply_(factor);
    else
        o = SICM.SICMScan.fromSICMScan_(self);
        o.scaleZ(factor, varargin{:});
        varargout{1} = o;
    end
end