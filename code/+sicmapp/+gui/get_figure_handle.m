function f = get_figure_handle(c)
    % get_figure_handle returns the figure handle of the `c`
    % 
    % input args:
    % c: graphical component within a figure
    %
    % The function returns the figure handle of the figure containing `c`.
    f = c;
    while ~isa(f, 'matlab.ui.Figure')
        f = f.Parent;
    end
end