function v = volume(self)
% Computes the volume of the data in the scan. Note: The data is taken as
% it is, nothing is subtracted first!
%
% Examples:
%    vol = obj.volume()
% 
%      Computes the volume of the data in `obj`
%      
%  If you want the volume without the z-offset, use:
%
%    obj.subtractMin()
%    vol = obj.volume()

v = self.stepx * self.stepy * sum(self.zdata_lin);


%+BEGIN GUIMETADATA: Do not delete
%+GMD Type: 'prop'
%+GMD Name: 'Volume'
%+GMD Depends: {'x','y','z'}
%+GMD Changes: {}
%+GMD Immediate: 1
%+END GUIMETADATA