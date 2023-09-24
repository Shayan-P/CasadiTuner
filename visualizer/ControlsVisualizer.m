classdef ControlsVisualizer < handle
    methods
        function this=ControlsVisualizer(opti_gui, callbacks, callback_names)
            n = length(callbacks);
            assert(length(callbacks) == length(callback_names), "length of callbacks and callback_names should be equal");
        
            fig = uifigure("Name", "Control Panel");
            box = uiflowcontainer('v0', 'FlowDirection', 'TopDown', 'Parent', fig);
            for i=1:n
                name = callback_names{i};
                callback = callbacks{i};
                uicontrol('Style', 'pushbutton', 'String', name, 'Parent', box,...
                          'Callback', @(~, ~) opti_gui.handle_callback(@callback));
            end
        end
    end
end
