function y = averageFilter(d, varargin)
% SICM.averageFilter
%
% Smoothes data by calculating the avarage of adjacent data points for 
% one-dimensional vectors. 
% 
%
% y = SICM.averageFilter(data)
% 
% Substitutes every data point n with the average of n-1, n and n+1. The 
% returned vector has a sized reduced by 2.
% 
% y = SICM.averageFilter(data, l)
%
% Substitutes every data point n with the average of n-l, n-l+1, .., n,
% n+l-1, n+l. The returned vector has a sized reduced by 2l.
%
% See also FSPECIAL, FILTER

l = 1;
if nargin == 2
    l = varargin{1};
end;
y = zeros(length(d)-2*l, 1);
for i = l+1:length(d)-l
    y(i-l) = mean(d(i-l:i+l));
end

