class Node

  attr_accessor :nodes, :start_node, :end_node, :open_list, :closed_list

  def initialize(textfile)
    @nodes = []
    create_nodes(textfile)
    @closed_list = [@start_node]
    @open_list = []
    assign_h_values
  end

  def create_nodes(textfile)
    grid = File.open(textfile, "r").each_line.collect{|line| line.chomp.chars}
    id = 0
    0.upto(grid.size - 1) do |row|
      0.upto(grid[0].size - 1) do |col|
        char = grid[row][col]
        pos = [row,col]
        @nodes << create_node(id, char, pos)
        id += 1
      end
    end
  end

  def create_node(id, char, pos)
    node = {:id => id, :text => char, :pos => pos}
    case char
    when "*"
      node[:type] = :wall
    when " "
      node[:type] = :empty
    when "S"
      node[:type] = :start
      node[:g] = 0
      node[:f] = 0
      @start_node = node
    when "E"
      node[:type] = :end
      @end_node = node
    end
    node
  end

  def assign_h_values
    @nodes.each do |node|
      node[:h] = calculate_h(node)
    end
  end

  def calculate_h(node)
    x1, y1 = *end_node[:pos]
    x2, y2 = *node[:pos]
    ((x2 - x1).abs + (y2 - y1).abs) * 10
  end

  def [](*pos)
    x, y = *pos
    y ? nodes.select{|node| node[:pos] == [x,y]}[0] : nodes[x]
  end
  
end
