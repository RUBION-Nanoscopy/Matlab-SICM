function varargout = filter(self, method, varargin)
% This function applies a filter to the Approach curve data. The syntax is:
% 
%   obj.filter(methods, params);
%
% which applies the filter in `method` with parameters `params` to the
% data. To receive a new object instead of modyfying the origina lone, use 
%
%   newobj = obj.filter(methods, params);
%
% The following filter methods and params are available:
%
%   method       params     description 
%
%   'median'  :   /width/    Applies a median filter to the data with the 
%                            speecified /width/
%   'mean'    :   /width/    Applies a mean filter to the data with the 
%                            specified /width/
%   'highpass':   /freq/     Applies a sharp highpass filter cutting
%                            frequencies below /freq/
%   'lowpass':    /freq/     Applies a sharp lowpass filter cutting
%                            frequencies above /freq/
%   'bandpass':   /freq/, /freq2/     
%                            Applies a sharp bandpass filter cutting
%                            frequencies below /freq/ and above /freq2/
    if nargout == 1
        o = SICM.SICMAppCurve.fromSICMAppCurve_(self);
        o.filter(method, varargin{:});
        varargout{1} = o;
        return;
    end
    
    switch method
        case 'median'
            [self.xdata, ...
             self.ydata] = local_filterMedian(self, varargin{:});
        case 'mean'
            [self.xdata, ...
             self.ydata] = local_filterMean(self, varargin{:});
        case 'lowpass'
            [self.xdata, ...
             self.ydata] = local_filter_bandpass(self, varargin{:});
        case 'highpass'
            [self.xdata, ...
             self.ydata] = local_filter_bandpass(self, 0, varargin{:}); 
        case 'bandpass'
            [self.xdata, ...
             self.ydata] = local_filter_bandpass(self, varargin{:});
        otherwise
            error('SICMAPPCurve:UnknownFilterMethod',...
                'The filter method %s is not implemeted', method);
    end
end

function [x,y] = local_filterMedian(obj, varargin)
    width = round(varargin{1});
    if mod(width, 2) ~= 1
        width = width + 1;
        warning('SICMAppCurve:filterWidthAdjusted',...
            'Filter width must be odd, adjusted to %s', width);
    end
    offset = floor(width/2);
    x = obj.xdata(offset+1:end-offset);
    y = zeros(length(obj.ydata) - 2* offset, 1);
    for i = 1:length(obj.ydata) - width
        y(i) = median(obj.ydata(i:i+width));
    end
    
end
function [x,y] = local_filterMean(obj, varargin)
    width = round(varargin{1});
    if mod(width, 2) ~= 1
        width = width + 1;
        warning('SICMAppCurve:filterWidthAdjusted',...
            'Filter width must be odd, adjusted to %s', width);
    end
    offset = floor(width/2);
    x = obj.xdata(offset+1:end-offset);
    y = zeros(length(obj.ydata) - 2* offset, 1);
    
    for i = 1:length(obj.ydata) - width
        y(i) = mean(obj.ydata(i:i+width));
    end
end

function [x,y] = local_filter_bandpass(obj, varargin)
    try
        sr = obj.SamplingRate;
    catch
        error('SICMAppCurve:filter',...
            'To apply a (high|low|band)pass filter, the object requires a samling rate');
    end
    if isnan(sr)
        error('SICMAppCurve:filter',...
            'To apply a (high|low|band)pass filter, the object requires a samling rate');
    end
    high = inf;
    low = varargin{1};
    if nargin > 2
        high = varargin{2};
    end
    
    if high < low 
        tmp = low;
        low = high;
        high = tmp;
    end
    
    Y = fft(obj.ydata);
    
    
    %real_part = Y(1:floor(length(obj.ydata)/2)+1);
    dFrq = sr / length(obj.ydata);
    freq = 0 : dFrq :sr/2;

    % semilogx(freq, abs(real_part));

    fl_half = freq < low | freq > high;
    
    if low > 0 && high < Inf
        fl_half = ~fl_half;
    end
    fl = zeros(size(Y));
    off = 0
    if length(Y) < 2*length(fl_half)
        off = 1
    end
    fl(1:length(fl_half)) = fl_half;
    length(fl(length(fl_half)+1:end))
    length(fl_half(end-off:-1:1))
    fl(length(fl_half)+1:end) = fl_half(end-off-1:-1:1);
    %figure;
    %plot(fl);
    %title('Filter')
    %figure;
    %plot(abs(Y(2:end-1)).*fl(2:end-1) );
    %title('Filtered spektrum');
    ny = real(ifft(Y.*fl));
    %figure;
    %plot(obj.xdata, ny);
    %title('Filtered data');
    x = obj.xdata;
    y = ny;
end
