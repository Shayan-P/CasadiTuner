classdef OptiResult < handle
    properties(SetAccess=immutable)
        opti_parameters OptiParameters
        parent_result OptiResult
        opti_x
        opti_p
        opti_lbg
        opti_ubg
    end

    properties(SetAccess=private)
        name
        count_children
    end

    methods
        function this = OptiResult(opti_gui, parent_result)
            arguments
                opti_gui OptiGUI
                parent_result OptiResult
            end
            if nargin == 2
                this.parent_result = parent_result;
                this.parent_result.count_children = this.parent_result.count_children + 1;
                this.name = this.parent_result.name + string(this.parent_result.count_children);
            else 
                this.name = "root";
            end

            this.opti_parameters = get_opti_parameters(opti_gui);

            opti = opti_gui.opti;
            this.opti_x = opti.value(opti.x);
            this.opti_p = opti.value(opti.x);
            this.opti_lbg = opti.value(opti.x);
            this.opti_ubg = opti.value(opti.ubg);
        end
    end

    methods(Static)
        function this = capture_opti_gui(opti_gui, parent_result)
            this = OptiResult(opti_gui, parent_result);
        end
        function this = capture_opti_gui_root(opti_gui)
            this = OptiResult(opti_gui);
        end
    end

    methods(Access=private)
        function opti_parameters = get_opti_parameters(opti_gui) 
            param_names = [];
            param_values = [];
            for i=1:length(opti_gui.parameters)
                param_names = [param_names, opti_gui.tuners{i}.name];
                param_values = [param_values, opti_gui.tuners{i}.getValue()];
            end
            opti_parameters = OptiParameters(param_names, param_values);
        end      

    end
end
