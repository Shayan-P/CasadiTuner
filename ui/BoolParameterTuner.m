classdef BoolParameterTuner < ParameterTuner
    properties (SetAccess = immutable)
        name
    end
    properties (SetAccess = private)
        default_value
        valueField
        checkbox
    end

    methods
        function this = BoolParameterTuner(name, default_value)
            assert(default_value == 0 || default_value == 1, 'default value should be 0 or 1');
            this.name = name;
            this.default_value = default_value;
        end

        function add_name_value_editor(this, parent)
            % Name label
            uilabel(parent, 'Text', this.name);
            
            % Value label
            this.valueField = uilabel(parent, 'Text', string(this.default_value));

            % editor
            this.checkbox = uicontrol(parent, 'Style', 'checkbox', 'String', 'turn on', 'Callback', @(element, action) this.update(this.getValue()));
            this.checkbox.Value = this.default_value;
        end

        function output = getValue(this)
            output = this.checkbox.Value;
        end
    end

    methods(Access=public)
        function update(this, value)
            this.checkbox.Value = value;
            this.valueField.Text = string(value);
        end
    end
end
