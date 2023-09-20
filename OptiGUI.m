classdef OptiGUI < handle
    properties (SetAccess=private)
        opti casadi.Opti
        optimize_callback function_handle
        parameters (:, 1)
        tuners cell
    end

    methods
        function this = OptiGUI(opti, optimize_callback)
            arguments
                opti casadi.Opti
                optimize_callback function_handle
            end
            this.opti = opti;
            this.optimize_callback = optimize_callback;            
            this.parameters = [];
            this.tuners = {};
        end

        function param = parameter_bool(this, name, default_value)
            arguments
                this
                name string
                default_value
            end
            
            param = this.opti.parameter();
            this.default_update_callback(param, default_value);
            tuner = BoolParameterTuner(name, default_value, @(value) this.default_update_callback(param, value));
            this.add_parameter_(param, tuner);
        end

        function param = parameter_scalar(this, name, lbound, default_value, ubound)
            arguments
                this
                name string
                lbound
                default_value
                ubound
            end

            param = this.opti.parameter();
            this.default_update_callback(param, default_value);
            tuner = ScalarParameterTuner(name, lbound, default_value, ubound, @(value) this.default_update_callback(param, value));
            this.add_parameter_(param, tuner);
        end

    end

    methods (Access=private)
        function add_parameter_(this, param, tuner)
            arguments
                this OptiGUI
                param % todo type of this is casadi.MX but what about casadi.SX?
                tuner ParameterTuner
            end
            this.parameters = [this.parameters; param];
            this.tuners{end+1} = tuner;
        end

        function default_update_callback(this, param, value)
            this.opti.set_value(param, value); % todo is set initial correct?
        end
    end

    methods
        function tune(this)
            fig = figure('Name', 'CasadiTuner', 'NumberTitle', 'off');
            % movegui(fig, 'center');

            main_box = uiflowcontainer('v0', 'FlowDirection', 'TopDown');

            for i=1:length(this.tuners)
                this.tuners{i}.addToParent(main_box);
            end

            optimizeButton = uicontrol('Style', 'pushbutton', 'String', 'optimize!',...
                                        'Callback', @(~, ~) this.optimize_callback(this.opti));
        
            waitfor(fig);
        end
    end
end