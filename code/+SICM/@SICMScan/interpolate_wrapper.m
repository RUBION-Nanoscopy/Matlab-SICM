function varargout = interpolate_wrapper( self, method, steps )
% wrapper for the interpolation method with arguments in different order,
% as required for the GUI.

if nargout > 0
    varargout{1} = self.interpolate( steps, method );
else
    self.interpolate( steps, method );
end


%+BEGIN GUIMETADATA: Do not delete
%+GMD Type: 'meth'
%+GMD Name: {'by cubic splines', 'by nearest neighbour'}
%+GMD FixedArgs: {'spline', 'nearest'}
%+GMD VarArgs: {struct('type','int','desc','Interpolation steps'),struct('type','int','desc','Interpolation steps')}
%+GMD Depends: {}
%+GMD Changes: {'x','y','z'}
%+GMD Immediate: 0
%+GMD Menu: 'Interpolation'
%+END GUIMETADATA