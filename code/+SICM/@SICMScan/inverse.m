function varargout = inverse(self)
% This function inverses the z-data of the object.
%
% Examples:
%    obj.inverse()
%       The data of obj is inversed.
%
%    newobj = obj.inverse()
%
%    Returns a new object with the inversed data of obj. obj is not
%    modified.

    % If an output argument is specified, copy the object and call
    % the inverse() method of this object. Then return it and leave the
    % method.
    if nargout == 1
       o = SICM.SICMScan.fromSICMScan_(self);
       o.inverse();
       varargout{1} = o;
       return
    end

    % now do the work:
    self.multiply_(-1);
end