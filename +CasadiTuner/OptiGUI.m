classdef OptiGUI < handle
    properties (SetAccess=private)
        opti casadi.Opti
        parameters (:, 1)
        tuners cell
        manager CasadiTuner.OptiResultManager
    end
    properties
        callback_names
        callbacks
    end
    properties
        control_panel
        parameter_panel
        results_panel
    end

    methods
        function this = OptiGUI(opti, save_path)
            arguments
                opti casadi.Opti
                save_path string = "opti_gui_results.mat"
            end
            this.opti = opti;
            this.parameters = [];
            this.tuners = {};
            this.manager = CasadiTuner.OptiResultManager(save_path);
            this.callback_names = {};
            this.callbacks = {};

            % optimize callback. added automatically
            % todo: is this better or should we let the user add it manually?
            this.add_callback("optimize", @(opti_gui) CasadiTuner.OptiGUI.optimize_callback(opti_gui));
        end

        function param = parameter_bool(this, name, default_value)
            arguments
                this
                name string
                default_value
            end
            
            param = this.opti.parameter();
            tuner = CasadiTuner.BoolParameterTuner(name, default_value);
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
            tuner = CasadiTuner.ScalarParameterTuner(name, lbound, default_value, ubound);
            this.add_parameter_(param, tuner);
        end
    end

    methods(Access=public)
        function add_callback(this, callback_name, callback)
            this.callback_names{end+1} = callback_name;
            this.callbacks{end+1} = callback;
        end
    end

    methods (Access=private)
        function add_parameter_(this, param, tuner)
            arguments
                this CasadiTuner.OptiGUI
                param % todo type of this is casadi.MX but what about casadi.SX?
                tuner CasadiTuner.ParameterTuner
            end
            this.parameters = [this.parameters; param];
            this.tuners{end+1} = tuner;
        end
    end

    methods (Access=public)
        function set_tuner_parameters(this)
            for i=1:length(this.tuners)
                p = this.parameters(i);
                tuner = this.tuners{i};
                this.opti.set_value(p, tuner.getValue());
            end
        end

        function set_opti_result(this, opti_result)
            arguments
                this
                opti_result CasadiTuner.OptiResult
            end
            this.opti.set_initial(this.opti.x, opti_result.opti_x);
            this.opti.set_value(this.opti.p, opti_result.opti_p);
        end
    end

    methods(Static)
        function optimize_callback(opti_gui)
            % set previous result
            last_result = opti_gui.results_panel.last_selected_opti_result;
            if last_result ~= false
                opti_gui.set_opti_result(last_result);
            end

            % set parameters
            opti_gui.set_tuner_parameters();

            % solve optimization
            sol = opti_gui.opti.solve();

            % get opti result
            if last_result == false
                opti_result = CasadiTuner.OptiResult.capture_opti_gui_root(opti_gui);
            else
                opti_result = CasadiTuner.OptiResult.capture_opti_gui(opti_gui, last_result);
            end

            % add new result in manager. automatically gets selected in visualizer
            opti_gui.manager.add_result(opti_result);
        end
    end

    methods
        function fig = tune(this)
            fig = uifigure("Name", "Casadi Tuner");
            grid = uigridlayout(fig, [1 3]);
            grid.ColumnWidth = {'4x', '2x', '1x'};

            this.control_panel = CasadiTuner.ControlsVisualizer(grid, this, this.callback_names, this.callbacks);
            this.control_panel.panel.Layout.Column = 3;
            this.control_panel.panel.Layout.Row = 1;

            this.parameter_panel = CasadiTuner.ParametersVisualizer(grid, this);
            this.parameter_panel.panel.Layout.Column = 2;
            this.parameter_panel.panel.Layout.Row = 1;

            this.results_panel = CasadiTuner.ResultsVisualizer(grid, this.manager, ...
                                @(opti_result) this.parameter_panel.update(opti_result.opti_parameters));
            this.results_panel.panel.Layout.Column = 1;
            this.results_panel.panel.Layout.Row = 1;

            % todo. move this to parent class?
            fig.CloseRequestFcn = @(src, ~) this.askForSaveBeforeClose(src); % todo make this optional?
        end
    end

    methods(Access=private)
        function askForSaveBeforeClose(this, src)
            choice = questdlg('save before closing? (location: ' + this.manager.filepath + ')', ...
                  'Save Result', ...
                  'Yes', 'No', 'Yes');
            if strcmp(choice, 'Yes')
                this.manager.save();
            end
            delete(src);
        end
    end
end