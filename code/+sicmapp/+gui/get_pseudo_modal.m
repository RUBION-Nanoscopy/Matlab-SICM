function f = get_pseudo_modal(fig, sz)
    % get_pseudo_modal  returns a modal figure
    %
    % input args:
    %   fig: handle to a figure or a graphical component in a figure.
    %   sz: two-element vector containing the desired size of the new
    %   figure
    %
    % returns a handle to an invisible figure positioned at the center of
    % `fig` with WindowStyle 'modal'. Can be used to fake dialogs. Size of
    % the figure is `sz` (width, height)
    f = uifigure('Visible', 'off', 'WindowStyle', 'modal');
    fig = sicmapp.gui.get_figure_handle(fig);
    pos = fig.Position;
    cx = pos(1) + pos(3)/2;
    cy = pos(2) + pos(4)/2;
    f.Position = [cx - sz(1)/2, cy - sz(2)/2, sz(1), sz(2)];
end