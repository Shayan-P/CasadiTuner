classdef ScalarParameterTuner < ParameterTuner
    properties (SetAccess = immutable)
        updateCallback
        uiControlElement
    end

    methods
        function this = ScalarParameterTuner(name, lbound, default_value, ubound, updateCallback)
            assert(lbound <= default_value && default_value <= ubound, "lbound <= default_value <= ubound should hold");

            % this.uiControlElement = uislider('String', name, 'Callback', @(element, action) updateCallback(element.Value));
            
            this.uiControlElement = uicontrol('String', name, 'Style','Slider','Min', lbound,'Max', ubound,'SliderStep', [(ubound - lbound) / 100 (ubound - lbound)/50]);
            this.uiControlElement.Callback = @(element, action) updateCallback(element.Value);

            % this.uiControlElement.Limits = [lbound ubound];
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
