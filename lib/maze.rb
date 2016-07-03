require_relative 'node'

class Maze
   
   attr_accessor :nodes, :start_node, :end_node, :open_list, :closed_list, :path, :unsolvable, :textfile
   
   def initialize(textfile)
       @textfile = textfile
       @nodes = Node.new(textfile)
       @start_node = nodes.start_node
       @end_node = nodes.end_node
       @open_list = []
       @closed_list = [start_node]
       @path = []
       @unsolvable = false
   end
   
   def solve
       loop do
        fill_open_list
        add_closed_list
        break if solved?
       end
       find_path(end_node)
       print_solution
   end
   
   def solved?
       closed_list.last[:type] == :end || unsolvable
   end
   
   def print_solution
       solved_textfile = textfile.split(".").join("-solved.")
        File.open(solved_textfile,"w") do |new_file|
            i = 0
            File.open(textfile, "r").each_line do |line|
                j = 0
                line.chars.each do |char|
                    if path.include?([i,j])
                        new_file.print "X"
                    else
                        new_file.print char
                    end
                    j += 1
                end
                i += 1
            end
        end
   end
   
   #private
   
   def find_min_f_node_from_open_list
        min_f = open_list.collect{|node| node[:f]}.min
        open_list.sort_by!{|node| node[:h]}
        open_list.find{|node| node[:f] == min_f}
   end
   
   def fill_open_list
       adj_nodes = find_adj_nodes
       parent = closed_list[-1]
       assign_values(parent, adj_nodes)
       adj_nodes.each{|node| open_list << node unless open_list.include?(node)}
   end
   
   def find_adj_nodes
        x, y = *closed_list.last[:pos]
        adj_nodes = []
        adj_nodes << nodes[x - 1, y]
        adj_nodes << nodes[x + 1, y]
        adj_nodes << nodes[x, y - 1]
        adj_nodes << nodes[x, y + 1]
        adj_nodes.compact.select{|node| (node[:type] == :empty || node[:type] == :end) && !closed_list.include?(node)}
   end
  
  def assign_values(parent, adj_nodes)
      adj_nodes.each do |node|
          next if closed_list.include?(node)
          if open_list.include?(node)
            analyze_included_open_list_node(parent,node)
          else
            assign_g_value(parent, node)
            assign_f_value(node)
            node[:parent] = parent[:pos]
          end
      end
  end
  
  def analyze_included_open_list_node(parent,node)
    if parent[:g] + 10 < node[:g]
        assign_g_value(parent, node)
        assign_f_value(node)
        node[:parent] = parent[:pos]
    end
  end

  def assign_g_value(parent, node)
      node[:g] = parent[:g] + 10
  end
  
  def assign_f_value(node)
      node[:f] = node[:g] + node[:h]
  end
  
  def add_closed_list
      min_node = find_min_f_node_from_open_list
      closed_list << min_node
      open_list.delete(min_node)
  end
  
  def shortest_movement(parent, node)
    x1, y1 = *node[:pos]
    x2, y2 = *start_node[:pos]
    ((x2 - x1).abs + (y2 - y1).abs) * 10
  end
  
  def find_path(node)
      return if node[:g] == 10
      path << node[:parent]
      x, y = node[:parent]
      find_path(nodes[x,y])
  end
  
end
