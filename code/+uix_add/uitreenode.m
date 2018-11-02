function n = uitreenode(varargin)
% uitreenode - wrapper around the undocumented uitreenode function
% use as uitreenode, but omit the 'v0', which is added by this function

n = uitreenode('v0', varargin{:});