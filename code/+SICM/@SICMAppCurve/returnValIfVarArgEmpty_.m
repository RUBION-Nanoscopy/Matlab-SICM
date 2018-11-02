function b = returnValIfVarArgEmpty_(self, val, varargin)
% Internal function
%
% Returns `val`if varargin is empty, varargin{1} otherwise.

if nargin == 2
    b = val;
else 
    b = varargin{1};
end