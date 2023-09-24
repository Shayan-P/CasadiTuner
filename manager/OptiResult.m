classdef OptiResult < handle
    properties(SetAccess=immutable)
        opti_parameters OptiParameters
        parent_result OptiResult
        opti_x
        opti_p
        opti_lbg
        opti_ubg
        has_parent
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
            if nargin == 2  % todo make sure nargin == 2 is correct
                this.parent_result = parent_result;
                this.parent_result.count_children = this.parent_result.count_children + 1;
                this.name = this.parent_result.name + string(this.parent_result.count_children);
                this.has_parent = true;
            else 
                this.name = "root";
                this.has_parent = false;
            end

            this.opti_parameters = OptiParameters.from_opti_gui(opti_gui);

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
end
