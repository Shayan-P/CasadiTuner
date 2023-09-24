classdef OptiResultManager < handle
    properties
        results cell
        filepath string
    end
    properties
        update_callbacks cell
    end

    methods
        function this = OptiResultManager(filepath)
            this.filepath = filepath;
            if exist(filepath, 'file') == 2
                data = load(filepath);
                this.results = data.results;
            else
                this.results = {};
            end
            this.update_callbacks = {};
        end

        function add_result(this, result)
            arguments
                this
                result OptiResult
            end
            this.results{end+1} = result;
            this.execute_callbacks(result);
        end

        function add_update_callback(this, callback)
            this.update_callbacks{end+1} = callback;
        end

        function save(this)
            results = this.results;
            save(this.filepath, "results");
        end
    end

    methods(Access=private)
        function execute_callbacks(this, result)
            for i=1:length(this.update_callbacks)
                this.update_callbacks{i}(result);
            end
        end
    end
end