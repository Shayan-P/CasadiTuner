classdef ScalarParameterTuner < ParameterTuner
    properties (SetAccess = immutable)
        updateCallback
        name
    end
    properties (SetAccess = private)
        default_value
        lbound
        ubound
        valueField
        slider
    end

    methods
        function this = ScalarParameterTuner(name, lbound, default_value, ubound, updateCallback)
            assert(lbound <= default_value && default_value <= ubound, "lbound <= default_value <= ubound should hold");

            this.name = name;
            this.lbound = lbound;
            this.default_value = default_value;
            this.ubound = ubound;
            this.updateCallback = updateCallback;
        end

        function add_name_value_editor(this, parent)
            % Name label
            uilabel(parent, 'Text', tuners.name);
            
            % Value label
            this.valueField = uilabel(parent, 'Text', string(this.getValue()));
            
            % Slider (uislider)
            this.slider = uislider(parent);
            this.slider.Limits = [this.lbound this.ubound];
            this.slider.Value = this.default_value;
            
            % Add a ValueChangedFcn to update the value
            addlistener(this.slider, 'ValueChanged', @(src, event) this.update(this.getValue()));
        end

        function output = getValue(this)
            output = this.uiControlElement.Value;
        end
    end

    methods(Access=public)
        function update(this, value)
            this.slider.Value = value;
            this.valueField.Text = string(value);
            this.updateCallback(value);
        end
    end
end
