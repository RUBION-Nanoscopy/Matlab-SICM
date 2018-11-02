function t = fduration(self, varargin)
% Returns a formatted string of the duration of the scan.
% 
%    Examples: 
%    
%      obj.fduration(format_string)
%        
%        Returns a string representation of the duration of the scan
%        according to format_string. Within this format string, the
%        following values are replaced with their respective counterparts:
%      
%        %n: The duration in milliseconds (as in the durattion-property)
%        %s: The duration in seconds, rounded
%        %m: The duration in minutes, rounded
%        %h: The duration in hours, rounded
%  
%        The next replacements express the duration as HH:MM:SS:NNN, where
%        HH is the amount of hours, MM the amount of minutes, SS the amount
%        of seconds and NNN the amount of milliseconds. 
%
%        %N: NNN of the above
%        %S: SS of the above
%        %M: MM of the above
%        %H: HH of the above
%
%      obj.fduration()
%        
%        Uses the default format string '%H:%M:%S.%N'
%
%   Note the following:
%
%      % Generate an empty SICMScan object:
%      foo = SICM.SICMScan();
%      % Set its duration to 4h, 35m, 21s and 123ms:
%      foo.duration = 60*60*1e3 * 4  ... % Hours
%                   + 60*1e3    * 35 ... % Minutes
%                   + 1e3       * 21 ... % Seconds     
%                   +             123   % Millisecodns
%
%   
%
%     foo.fduration('%m')
%     ans =   
%     275
% 
%     % This is the duration in minutes
%
%     foo.fduration('%M')
%     ans = 
%     35
%
%     % The minutes-part of the total duration 

    if isnan (self.duration) 
        t = '';
        return;    
    end
    duration = struct();
    duration.n = self.duration;
    duration.s = round(self.duration/1000);
    duration.m = round(duration.s/60);
    duration.h = round(duration.m/60);
    
    
    duration.H = floor(self.duration / ( 60*60*1000));
    tmp_d = self.duration - duration.H * 60*60*1000;
    duration.M = floor(tmp_d / (60*1000));
    tmp_d = tmp_d - duration.M * 60*1000;
    duration.S = floor(tmp_d/1000);
    duration.N = mod(self.duration, 1000);
    
    if nargin > 1
        format = varargin{1};
    else
        format = '%H:%M:%S.%N';
    end
    %
    % Alas, the follwing does not wark as I would expect
    %
    %t = strrep(format, ...
    %    { '%n', '%s', '%m', '%h', '%H', '%M', '%S', '%N'}, ...
    %    { ...
    %        num2str(duration.n), ...
    %        num2str(duration.s), num2str(duration.m), num2str(duration.h), ...
    %        num2str(duration.H), num2str(duration.M), num2str(duration.S), ...
    %        num2str(duration.N) ...
    %    });
    %
    % So I have to call strrep manually for every field:
    
    t = format;
    fnames = fieldnames(duration);
    for needle = fnames'
        t = strrep(t, ['%', needle{1}], num2str(duration.(needle{1})) );
    end
    
end