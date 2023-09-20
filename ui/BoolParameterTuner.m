classdef BoolParameterTuner < ParameterTuner
    properties (SetAccess = immutable)
        updateCallback
        uiControlElement
    end

    methods
        function this = BoolParameterTuner(name, default_value, updateCallback)
            assert(default_value == 0 || default_value == 1, 'default value should be 0 or 1');
            this.uiControlElement = uicontrol('Style', 'checkbox', 'String', name, 'Callback', @(element, action) updateCallback(element.Value));
            this.uiControlElement.Value = default_value;
        end

        function addToParent(this, parent)
            this.uiControlElement.Parent = parent;
        end

        function output = getValue(this)
            output = this.uiControlElement.Value;
        end
    end
end
