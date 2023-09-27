classdef OptiResult < handle
    properties(SetAccess=immutable)
        opti_parameters CasadiTuner.OptiParameters
        opti_x
        opti_p
        opti_lbg
        opti_ubg
        has_parent
    end

    properties(SetAccess=private)
        parent_result CasadiTuner.OptiResult
    end

    properties(SetAccess=private)
        name
        count_children
    end

    properties
        data  % for user to store information here. should discard when load/save happens
    end

    methods (Access=private)
        function this = OptiResult(opti_gui, optional_parent_result)
            arguments
                opti_gui CasadiTuner.OptiGUI
                optional_parent_result cell
            end

            this.count_children = 0;
            if isempty(optional_parent_result)
                this.name = "root";
                this.has_parent = false;
            else
                this.parent_result = optional_parent_result{1};
                this.parent_result.count_children = this.parent_result.count_children + 1;
                this.name = this.parent_result.name + string(this.parent_result.count_children);
                this.has_parent = true;    
            end

            this.opti_parameters = CasadiTuner.OptiParameters.from_opti_gui(opti_gui);

            opti = opti_gui.opti;
            this.opti_x = opti.value(opti.x);
            this.opti_p = opti.value(opti.p);
            this.opti_lbg = opti.value(opti.lbg);
            this.opti_ubg = opti.value(opti.ubg);
        end
    end

    methods
        function setName(this, name)
            arguments
                this
                name string
            end
            this.name = name;
        end
    end

    methods(Static)
        function this = capture_opti_gui(opti_gui, parent_result)
            this = CasadiTuner.OptiResult(opti_gui, {parent_result});
        end
        function this = capture_opti_gui_root(opti_gui)
            this = CasadiTuner.OptiResult(opti_gui, {});
        end
    end
end
