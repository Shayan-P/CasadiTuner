classdef ResultsVisualizer < handle
    properties
        fig
        activateResultCallback
        opti_result_manager
    end

    methods
        function this = ResultsVisualizer(opti_result_manager, activateResultCallback)
            this.opti_result_manager = opti_result_manager;
            this.activateResultCallback = activateResultCallback;


            fig = uifigure('Name', 'Results Panel');
            g = uigridlayout(fig); 
            g.ColumnWidth = {'1x'}; 
            g.RowHeight = {'1x'};
            % todo make a better UI here...

            t = uitree(g, 'Editable', 'on', ...
                'ClickedFcn', @(tree, ~) selectNode(tree.SelectedNodes),...
                'NodeTextChanged', @(node, ~) node.NodeData.setName(node.Text)); % todo check if callback works correctly
            t.Layout.Column = 1;
            t.Layout.Row = 1;

            % for i=1:length(this.opti_result_manager.results)
            %     opti_result = this.opti_result_manager{i};
            %     if opti_result.has_parent
            %         uitreenode(opti_result.parent_result.name, 'Text', string(i));
            %     else
            %         uitreenode(opti_result.parent_result.name, 'Text', string(i));
            %     end
            % end
            % nodes = {};
            % prev = t;
            % for i=1:30
            %     nodes{end+1} = uitreenode(prev, 'Text', string(i));
            %     prev = nodes{end};
            %     prev.NodeData = i;
            % end

            % expand(nodes{20});
        end
    end

    methods(Access=private)
        function selectNode(this, node)
            expand(node)
            this.activateResultCallback(node.NodeData);
        end
    end
end