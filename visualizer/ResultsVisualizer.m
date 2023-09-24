classdef ResultsVisualizer < handle
    properties
        fig
        tree
        set_result_callback
        opti_result_manager
    end
    properties
        last_selected_opti_result
    end

    methods
        function this = ResultsVisualizer(opti_result_manager, set_result_callback)
            arguments
                opti_result_manager OptiResultManager
                set_result_callback function_handle
            end

            this.opti_result_manager = opti_result_manager;
            this.set_result_callback = set_result_callback;
            this.last_selected_opti_result = false;

            fig = uifigure('Name', 'Results Panel');
            g = uigridlayout(fig); 
            g.ColumnWidth = {'1x'}; 
            g.RowHeight = {'1x'};
            % todo make a better UI here...

            this.tree = uitree(g, 'Editable', 'on', ...
                'ClickedFcn', @(tree, ~) this.clickCallback(),...
                'NodeTextChanged', @(~, event) this.nodeTextChangeCallback(event)); % todo check if callback works correctly
            this.tree.Layout.Column = 1;
            this.tree.Layout.Row = 1;

            for i=1:length(this.opti_result_manager.results)
                opti_result = this.opti_result_manager{i};
                this.add_result(opti_result);
            end

            opti_result_manager.add_update_callback(@(opti_result) this.add_result_and_select(opti_result));
        end

        function tree_node = add_result(this, opti_result)
            if opti_result.has_parent
                tree_node = uitreenode(opti_result.parent_result.data, 'Text', opti_result.name);
            else
                tree_node = uitreenode(this.tree, 'Text', opti_result.name);
            end
            tree_node.NodeData = opti_result;
            opti_result.data = tree_node;
        end

        function tree_node = add_result_and_select(this, opti_result)
            tree_node = this.add_result(opti_result);
            if opti_result.has_parent
                expand(opti_result.parent_result.data)
            end
            this.selectNode(tree_node);
        end
    end

    methods(Access=private)
        function clickCallback(this)
            if ~isempty(this.tree.SelectedNodes)
                this.selectNode(this.tree.SelectedNodes);
            end
        end

        function nodeTextChangeCallback(~, event)
            node = event.Node;
            text = event.Text;
            node.NodeData.setName(text);
        end

        function selectNode(this, node)
            expand(node);
            this.tree.SelectedNodes = node;
            this.last_selected_opti_result = node.NodeData;
            this.set_result_callback(node.NodeData);
        end
    end
end