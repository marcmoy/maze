class Maze
   
   attr_accessor :nodes, :start_node, :end_node, :open_list, :closed_list
   
   def initialize(textfile)
       @nodes = Node.new(textfile)
       @start_node = nodes.start_node
       @end_node = nodes.end_node
       @open_list = []
       @closed_list = [start_node[:id]]
   end
    
end