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
                callback_ = callbacks{i};
                callback = @() callback_(opti_gui);
                uicontrol('Style', 'pushbutton', 'String', name, 'Parent', box,...
                          'Callback', @(button, ~) this.handle_button(callback, button, name));
            end
        end
    end

    methods(Access=private)
        function handle_button(~, callback, button, name)
            button.String = "Processing...";
            try
                callback();
            catch ME
                button.String = "Failed: " + name;
                rethrow(ME);
            end
            button.String = name;
        end
    end
end
