classdef ControlsVisualizer < handle
    methods
        function this=ControlsVisualizer(opti_gui, callback_names, callbacks)
            arguments
                opti_gui CasadiTuner.OptiGUI
                callback_names cell
                callbacks cell
            end

            n = length(callbacks);
            assert(length(callbacks) == length(callback_names), "length of callbacks and callback_names should be equal");
        
            fig = uifigure("Name", "Control Panel");
            box = uiflowcontainer('v0', 'FlowDirection', 'TopDown', 'Parent', fig);
            for i=1:n
                name = callback_names{i};
                callback = callbacks{i};
                uicontrol('Style', 'pushbutton', 'String', name, 'Parent', box,...
                          'Callback', @(~, ~) callback(opti_gui));
            end
        end
    end
end
