function [tree, container] = uitree(varargin)
% uitree - wrapper around the undocumented uitree function
% use as uitree, but omit the 'v0', which is added by this function

[tree, container] = uitree('v0', varargin{:});