classdef hiddenHandle < handle
    % This class inherits from the handle class and hides most of its
    % methods. The handle class simplifies the programming since it
    % circumvents the lazy copying that Matblab uses, but it is annyoing
    % that all the automatically generated docs comprise the methods of the
    % handle class. This class circumvents this as much as possible.
    %
    % See also HANDLE
    
    %
    % The following overrides the methods from the handle class and hides
    % them. This removes most of the methods from being listed in automated
    % documentation and autocompletion.
    methods(Hidden)
      function lh = addlistener(varargin)
         lh = addlistener@handle(varargin{:});
      end
      function notify(varargin)
         notify@handle(varargin{:});
      end
      function delete(varargin)
         delete@handle(varargin{:});
      end
      function Hmatch = findobj(varargin)
         Hmatch = findobj@handle(varargin{:});
      end
      function p = findprop(varargin)
         p = findprop@handle(varargin{:});
      end
      function TF = eq(varargin)
         TF = eq@handle(varargin{:});
      end
      function TF = ne(varargin)
         TF = ne@handle(varargin{:});
      end
      function TF = lt(varargin)
         TF = lt@handle(varargin{:});
      end
      function TF = le(varargin)
         TF = le@handle(varargin{:});
      end
      function TF = gt(varargin)
         TF = gt@handle(varargin{:});
      end
      function TF = ge(varargin)
         TF = ge@handle(varargin{:});
      end
%      function TF = isvalid(varargin)
%         TF = isvalid@handle(varargin{:});
%      end
    end
end