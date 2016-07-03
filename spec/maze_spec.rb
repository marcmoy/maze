require 'board'
require 'rspec'

describe Board do
  let(:textfile) { "maze1.txt" }
  let(:board) { Board.new(textfile) }
  let(:node4) { {:id=>4,:text=>"*",:pos=>[0,4],:type=>:wall} }
  let(:node18) { {:id=>18,:text=>" ",:pos=>[1,2],:type=>:empty} }
  let(:node53) { {:id=>53,:text=>"*",:pos=>[3,5],:type=>:wall} }

  describe "#initialize" do
    it "takes a text file and creates 2d array of hash nodes" do
      expect(board.nodes[4]).to include(node4)
      expect(board.nodes[18]).to include(node18)
      expect(board.nodes[53]).to include(node53)
    end

    it "finds the start node" do
      expect(board.start_node[:id]).to eq(97)
      expect(board.start_node[:pos]).to eq([6,1])
    end

    it "finds the end node" do
      expect(board.end_node[:id]).to eq(30)
      expect(board.end_node[:pos]).to eq([1,14])
    end

    it "creates a #closed_list" do
      expect(board.closed_list).to eq([board.start_node])
    end

    it "creates an empty #open_list" do
      expect(board.open_list).to eq([])
    end
  end
end
