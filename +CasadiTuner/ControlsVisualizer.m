classdef ControlsVisualizer < handle
    properties
        panel
    end
    properties (SetAccess=private)
        is_busy_buttons (1,:)
    end
    
    methods
        function this=ControlsVisualizer(parent, opti_gui, callback_names, callbacks)
            arguments
                parent
                opti_gui CasadiTuner.OptiGUI
                callback_names cell
                callbacks cell
            end

            n = length(callbacks);
            assert(length(callbacks) == length(callback_names), "length of callbacks and callback_names should be equal");
        
            box = uiflowcontainer('v0', 'FlowDirection', 'BottomUp', 'Parent', parent);
            this.panel = box;

            this.is_busy_buttons = zeros(1, n);

            for i=1:n
                name = callback_names{i};
                callback_ = callbacks{i};
                callback = @() callback_(opti_gui);
                uicontrol('String', name, 'Parent', box,...
                          'Callback', @(button, ~) this.handle_button(callback, button, name, i));
            end
        end
    end

    methods(Access=private)
        function handle_button(this, callback, button, name, idx)
            button.String = "Processing...";
            this.is_busy_buttons(idx) = 1;
            button.Enable = 'inactive';
            try
                callback();
            catch ME
                button.String = "Failed: " + name;
                this.is_busy_buttons(idx) = 0;
                button.Enable = 'on';
                rethrow(ME);
            end
            this.is_busy_buttons(idx) = 0;
            button.Enable = 'on';
            button.String = name;
        end
    end
end
