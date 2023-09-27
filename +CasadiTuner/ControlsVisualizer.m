classdef ControlsVisualizer < handle
    properties (SetAccess=private)
        is_busy_buttons (1,:)
    end
    
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

            this.is_busy_buttons = zeros(1, n);

            for i=1:n
                name = callback_names{i};
                callback_ = callbacks{i};
                callback = @() callback_(opti_gui);
                uicontrol('Style', 'pushbutton', 'String', name, 'Parent', box,...
                          'Callback', @(button, ~) this.handle_button(callback, button, name, i));
            end
        end
    end

    methods(Access=private)
        function handle_button(this, callback, button, name, idx)
            if this.is_busy_buttons(idx)
                return
            end

            button.String = "Processing...";
            this.is_busy_buttons(idx) = 1;
            try
                callback();
            catch ME
                button.String = "Failed: " + name;
                this.is_busy_buttons(idx) = 0;
                rethrow(ME);
            end
            this.is_busy_buttons(idx) = 0;
            button.String = name;
        end
    end
end
