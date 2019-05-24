function make_buttons( self, bboxes  )
            
    btns = struct();
    btns.RestoreOriginal = uicontrol(...
        'Parent', bboxes{1}, 'String', 'Restore Original Data');
    btns.SwitchSlowFast = uicontrol(...
        'Parent', bboxes{1}, 'String', 'Switch slow/fast');

    btns.SelectNextLine = uicontrol(...
        'Parent', bboxes{3}, 'String', 'Next line (Page Down)' ); 
    btns.SelectPrevLine = uicontrol(...
        'Parent', bboxes{3}, 'String', 'Previous line (Page Up)' ); 

    self.GUI.Controls.Btns = btns;
end