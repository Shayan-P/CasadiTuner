classdef ParametersVisualizer < handle
    properties
        fig
        tuners
    end

    methods
        function this=ParametersVisualizer(opti_gui)
            this.fig = uifigure('Name', 'Parameter Panel');
            this.tuners = opti_gui.tuners;

            % Set the figure size
            this.fig.Position(3:4) = [500, 500];

            N = length(this.tuners);
            
            grid = uigridlayout(this.fig, [N, 3], 'Scrollable', 'on');
            grid.RowHeight = repmat({40}, 1, N);
            grid.ColumnWidth = {'1x', '1x', '1x'};
            grid.Padding = [10, 10, 10, 10];

            for row = 1:N
                this.tuners{row}.add_name_value_editor(grid);
            end
        end
    end

    methods(Access=public)
        function update(this, opti_parameters)
            arguments
                this
                opti_parameters OptiParameters
            end
            
            N = opti_parameters.N;
            assert(length(this.tuners) == N, "tuners have " + length(this.tuners) + " parameters but opti_parameters have ", N, "parameters");
            for i=1:N
                tuner = this.tuners{i};
                tuner.update(opti_parameters.get_value(tuner.name));
            end
        end
    end
end
