classdef (Abstract) ParameterTuner
    properties (Abstract, SetAccess=immutable)
        updateCallback
        name
    end

    methods (Abstract)
        output = getValue(this)
        add_name_value_editor(this, parent)
        update(this, value)
    end
end
