classdef OptiResultManager < handle
    properties
        results cell
        filepath string
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
        end

        function add_result(this, result)
            arguments
                this
                result OptiResult
            end
            this.results{end+1} = result;
        end

        function save(this)
            results = this.results;
            save(this.filepath, "results");
        end
    end
end