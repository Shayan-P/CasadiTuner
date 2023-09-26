classdef ScalarParameterTuner < CasadiTuner.ParameterTuner
    properties (SetAccess = immutable)
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
        function this = ScalarParameterTuner(name, lbound, default_value, ubound)
            assert(lbound <= default_value && default_value <= ubound, "lbound <= default_value <= ubound should hold");

            this.name = name;
            this.lbound = lbound;
            this.default_value = default_value;
            this.ubound = ubound;
        end

        function add_name_value_editor(this, parent)
            % Name label
            uilabel(parent, 'Text', this.name);
            
            % Value label
            this.valueField = uilabel(parent, 'Text', string(this.default_value));
            
            % Slider (uislider)
            this.slider = uislider(parent);
            this.slider.Limits = [this.lbound this.ubound];
            this.slider.Value = this.default_value;
            
            % Add a ValueChangedFcn to update the value
            addlistener(this.slider, 'ValueChanged', @(src, event) this.update(this.getValue()));
        end

        function output = getValue(this)
            output = this.slider.Value;
        end
    end

    methods(Access=public)
        function update(this, value)
            this.slider.Value = value;
            this.valueField.Text = string(value);
        end
    end
end
