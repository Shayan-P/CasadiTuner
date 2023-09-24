classdef BoolParameterTuner < ParameterTuner
    properties (SetAccess = immutable)
        name
    end
    properties (SetAccess = private)
        default_value
        valueField
        checkbox
        value
    end

    methods
        function this = BoolParameterTuner(name, default_value)
            assert(default_value == 0 || default_value == 1, 'default value should be 0 or 1');
            this.name = name;
            % to make sure it is numeric and not true/false
            if default_value == 0
                this.default_value = 0;
            else
                this.default_value = 1;
            end
        end

        function add_name_value_editor(this, parent)
            % Name label
            uilabel(parent, 'Text', this.name);
            
            % Value label
            this.valueField = uilabel(parent, 'Text', string(this.default_value));

            % editor
            this.checkbox = uibutton(parent, 'push');         
            this.checkbox.ButtonPushedFcn = @(element, action) this.update(1-this.getValue());
            this.update(this.default_value);
        end

        function output = getValue(this)
            output = this.value;
        end
    end

    methods(Access=public)
        function update(this, value)
            this.value = value;
            if this.value == 0
                this.checkbox.Text = "turn on";
            else
                this.checkbox.Text = "turn off";
            end
            this.valueField.Text = string(value);
        end
    end
end
