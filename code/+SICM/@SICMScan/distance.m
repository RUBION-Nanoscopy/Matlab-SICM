function h = distance (self)
% Determination of the distance between two points (in pixel). 
%
% Uses the imdistline function of matlab.
%
    figure; 
    self.imagesc();
    h = imdistline(gca);
end

%+BEGIN GUIMETADATA: Do not delete
%+GMD Type: 'meth'
%+GMD Name: 'Measure Distance'
%+GMD FixedArgs: {}
%+GMD VarArgs: {}
%+GMD Depends: {}
%+GMD Changes: {}
%+GMD Immediate: 0
%+GMD Menu: 'Measurements'
%+END GUIMETADATA