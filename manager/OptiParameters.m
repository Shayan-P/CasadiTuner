classdef OptiParameters
    properties(SetAccess=immutable)
        N
        names
        values
    end

    methods
        function this = OptiParameters(names, values)
            this.N = length(names);
            assert(this.N == length(values), "length of names and values should match");
            this.names = names;
            this.values = values;
            % todo check if names are unique
        end
    end
end
