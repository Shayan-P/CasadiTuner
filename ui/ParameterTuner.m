classdef (Abstract) ParameterTuner
    properties (Abstract, SetAccess=immutable)
        updateCallback
    end

    methods (Abstract)
        addToParent(this, parent)
        output = getValue(this)
    end
end
