classdef DataTree < matlab.mixin.Copyable
    
    properties (Access = public)
        uitree
        root_node
        selected_node
    end
    
    properties (Access = private)
        node_id_counter
    end
        
    
    properties (Dependent, Access = public)
        free_node_id    
    end
        
    methods (Access = public)
        function self = DataTree(parent, varargin)
            uix.pvchk( varargin );
            self.root_node = uix_add.uitreenode(self.free_node_id, 'Data', [], false);
            [self.uitree, container] = uix_add.uitree(...
                'root', self.root_node, ...
                'SelectionChangeFcn', @self.handle_selection_changed);
            set(container, 'Parent', parent);
        end
        
        function newDataSet(self, name)
            self.root_node.add(uix_add.uitreenode(self.free_node_id, name, [], false));
            self.uitree.reloadNode(self.root_node);
        end
        
        function newData (self, dataset, name)
            n = self.get_node(dataset);
            n.add(uix_add.uitreenode(self.free_node_id, name, [], false));
            self.uitree.reloadNode(n);
        end
    end
    
    methods
        function id = get.free_node_id(self)
            self.node_id_counter
            if isempty(self.node_id_counter)
                self.node_id_counter = 1;
            else
                self.node_id_counter = self.node_id_counter + 1;
            end
            id = sprintf('%i', self.node_id_counter);
        end
    end
    methods (Access = protected)
        function node = get_node(self, nvalue, varargin)
            node = NaN;
            
            if nargin < 3
                rn = self.root_node;
            else 
                rn = varargin{1};
            end
            if strcmp(get(rn, 'value'), nvalue) == 1
                node = rn;
                return
            end
            c = 0;
            while c < rn.getChildCount();
                n = rn.getNextNode();
                
                c = c + 1;
                
                if  strcmp(get(n, 'value'), nvalue) == 1
                    node = n;
                    return
                end
                if n.getAllowsChildren() == 1
                    % recursively run through the tree...
                    node = self.get_node(nvalue, n);
                    if isa(node, 'com.mathworks.hg.peer.UITreeNode')
                        return
                    end
                end
            end
        end
        
        function handle_selection_changed(self, tree, event)
            snodes = self.uitree.getSelectedNodes();
            self.selected_node = snodes(1);
        end
    end
    
    
end