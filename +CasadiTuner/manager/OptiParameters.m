classdef OptiParameters
    properties(SetAccess=immutable)
        N
        names cell
        values cell
    end

    methods
        function this = OptiParameters(names, values)
            this.N = length(names);
            assert(this.N == length(values), "length of names and values should match");
            this.names = names;
            this.values = values;
            % todo check if names are unique
        end

        function new_this = updated(this, name, value)
            for i=1:this.N
                if name == this.names{i}
                    new_names = this.names;    % todo make sure this is copying 
                    new_values = this.values;  % todo make sure this is copying
                    new_values{i} = value;
                    new_this = OptiParameters(new_names, new_values);
                    return;
                end
            end
            assert(false, "name=" + name + " was not found in the parameters");
        end

        function result = get_value(this, name)
            % todo make map here to make it faster
            for i=1:this.N
                if this.names{i} == name
                    result = this.values{i};
                    return;
                end
            end
            assert(false, "no parameter with name='" + name + "' found");
        end
    end

    methods(Static)
        function this = from_opti_gui(opti_gui)
            param_names = {};
            param_values = {};
            for i=1:length(opti_gui.parameters)
                param_names{end+1} = opti_gui.tuners{i}.name;
                param_values{end+1} = opti_gui.tuners{i}.getValue();
            end
            this = OptiParameters(param_names, param_values);
        end
    end
end
