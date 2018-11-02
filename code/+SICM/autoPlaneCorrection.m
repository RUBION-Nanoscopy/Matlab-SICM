function czgrid = autoPlaneCorrection(zgrid, varargin)
    % -
    %
    % SICM.autoPlaneCorrection
    % ========================
    %
    % -------------------------------------
    % |                                   |    
    % |  NOTE: Function is experimental!  |
    % |                                   |            
    % -------------------------------------
    %
    % This function is dated 2014/10/18. I will update this line in new
    % versions. It is helpful if you do the same...
    % 
    % This function tries to auto-detect a linear slope in each single row
    % of pixels and removes it. This does not only remove a plane, but also
    % flattens the data. Since several steps are included to auto-detect
    % the cell in the image, this method might fail. If it fails, you might
    % have to dive into the code...
    %
    % The auto-detecion is similiar to the steps described in <a
    % href="matlab:web('http://www.mathworks.de/help/images/examples/detecting-a-cell-using-image-segmentation.html')">
    % the image processing toolbox description</a>[1]. First, edges are
    % detected via the canny algorithm and then, as in the article, the
    % edges are widened end filled. This is the used to mask data when
    % trying to fit straight lines to the data.
    %
    % The data resulting from this fit is then used again. This time a
    % threshold is applied to exclude data.
    %
    % For future versions, on option might be implemented that allows
    % selecting the area covered by the object(s) manually. This might help
    % a lot if the auto detection fails. However, this also might be
    % implemented in a second function.
    %
    % Synopsis:
    %
    %   corrected = SICM.autoPlaneCorrection(zgrid)
    %
    %     Returns the plane-corrected data from the grid zgrid. zgrid
    %     should be arragend in a way such that zgrid(i,:) gives a line of
    %     the data along the fast scanning axis, mostly x. For the
    %     threshold, a value of .1 is used.
    %
    %   corrected = SICM.autoPlaneCorrection(zgrid, threshold)
    % 
    %     As above, but this time the threshold is specified in the function call.
    %
    %   corrected = SICM.autoPlaneCorrection(zgrid, threshold, debug)
    %
    %     If called with three arguments (independent from the value of the
    %     third argument), the code is run in debug mode. that means, it
    %     displays all steps of the segmentation (object recognition)
    %     process. See the code.
    % 
    %     For future version, I suggest to use something which converts to
    %     a logical true for the verbose parameter.
    %
    % Links:
    %
    %   [1] The link to the image processing toolbox description is
    %       http://www.mathworks.de/help/images/examples/detecting-a-cell-using-image-segmentation.html
    %       just in case the automatic link formation in the documentation
    %       does not work.
    %
    %   See also: edge, strel, imdilate, imfill, fit
    
    
    
    
czgrid = ones(size(zgrid)) * NaN;
debug = 2;
threshold = .100;
if nargin > 1 && ~isnan(varargin{1})
    threshold = varargin{1};
end


% Detect the edges in the image using the canny method

bw = edge(zgrid, 'canny');

if nargin > debug
    figure, imshow(bw), title('Result of canny');
end

se90 = strel('line', 3, 90);
se0 = strel('line', 3, 0);

BWsdil = imdilate(bw, [se90 se0]);
if nargin > debug
    figure, imshow(BWsdil), title('Result of dilation');
end
BWsdil = imfill(BWsdil, 'holes');
if nargin > debug
    figure, imshow(BWsdil), title('Result of filling');
end
mask= imdilate(BWsdil, [se90 se0]);
if nargin > debug
    figure, imshow(BWsdil), title('Final mask');
end
for i = 1:size(zgrid,2)
   data = zgrid(i,:);
   x = (1:numel(data))';
   exclude = mask(i,:) == 1;
   if sum(~exclude) > 2 && sum(~exclude) > numel(exclude)/3
    f = fit(x,data','poly1','Exclude',mask(i,:) == 1);%,...
        %'StartPoint',[(data(end)-data(1))/x(end) data(1)]);
   end;
   corr = f(x);
   czgrid(i,:) = zgrid(i,:)-corr';  
end

% Now we try harder...

for i = 1:size(czgrid,2)
    data = czgrid(i,:);
    exclude = data > threshold;
    x = (1:numel(data))';
    if sum(~exclude) > 2 && sum(~exclude) > numel(exclude)/4
        f = fit(x,data','poly1','Exclude',exclude);
    end
    corr = f(x);
    czgrid(i,:) = data - corr';  
end




