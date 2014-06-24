require './ttt.rb'
require 'debugger'
class TicTacToeNode
  attr_accessor :board, :mark, :children, :cost
  @@opponent_of = { :o => :x , :x => :o}
  def initialize (board, mark = nil, cost = 0)
    @board = board 
    @mark = mark
    @opponent_mark = @@opponent_of[@mark]
    @cost = cost
    @children = []
  end

 #general children
  def build_tree
    current_position = self.board
    if not current_position.over?
      (0...3).each do |i|
        (0...3).each do |j|
          if current_position[[i,j]].nil?
            child_board = current_position.dup
            child_board[[i,j]]=@mark
            child_TTTNode = TicTacToeNode.new(child_board, @@opponent_of[self.mark])
            @children << child_TTTNode
          end
        end
      end
    end
    @children.each do |child|
      child.build_tree
    end
  end

  def losing_node?(player = :o)
    self.board.winner == @@opponent_of[player] ? true : false
  end

  def winning_node?(player = :o)
    self.board.winner == player ? true : false
  end

  def tied?
    self.board.tied? ? true : false
  end

  def display
    self.board.rows.each { |row| p row }
  end
end

class TTTtree
  attr_accessor :root, :current_node, :player_mark
  #base_board is a board
  def initialize(base_state, player_mark = nil)
    @player_mark = player_mark
    @root = TicTacToeNode.new(base_state, @player_mark)
    @current_node = @root
    @root.build_tree
    minimax_indexing(@root)  #index the nodes
  end
 
  #This uses minimax method to set the cost for each node
  def minimax_indexing(current_node)
    if current_node.board.over?
      return current_node.cost = 1 if current_node.winning_node?(@player_mark) 
      return current_node.cost = -1 if current_node.losing_node?(@player_mark)
      return current_node.cost = 0 if current_node.tied?
    end
  
    if current_node.mark == @player_mark  #self's turn, find the max among children
      max_cost = -1
      current_node.children.each do |child|
        tmp = minimax_indexing(child) 
        max_cost = tmp if tmp > max_cost
      end
      current_node.cost = max_cost
      return current_node.cost 
    else                                 #opponent's turn, find the min among children
      min_cost = 1
      current_node.children.each do |child|
       tmp = minimax_indexing(child) 
       if tmp < min_cost
         min_cost = tmp
       end
      end
      current_node.cost = min_cost
      return current_node.cost
    end
  end
  
end

class SuperComputerPlayer < ComputerPlayer

  def initialize
    super
    @game_tree = nil
  end

  def move(game, mark)
    @mark = mark
    puts "remaining #{moves_left(game.board)} moves"
    if moves_left(game.board) == 9
      return [1,1]
    elsif moves_left(game.board) == 8
      if game.board.empty?([1,1])
        return [1,1] 
      else
        return [0,0]
      end
    elsif moves_left(game.board) == 7
      if game.board.empty?([1,1])
        return [1,1]
      else
        return [0,2]
      end
    ############################################################
    #The first few moves can reduce search size by factor of 600 
    ############################################################
    elsif moves_left(game.board) == 6 || moves_left(game.board) == 5
      @game_tree = TTTtree.new(game.board, @mark)
      return self_move
    else
      opponent_move(game)
      return self_move
    end 
  end

  def moves_left(board)
    num = 0
    (0...3).each do |i|
      (0...3).each do |j|
         num += 1 if board.empty?([i,j])
      end
    end
    return num
  end
  
  #update current_node to match game state
  def opponent_move(game)
    @game_tree.current_node = compare(game, @game_tree.current_node)
  end
  
  #find the child that matches the current game state and move to it
  def compare(game, current_node)
    current_node.children.each do |child|
      if same?(child.board, game.board)
        return child 
      end
    end
    raise "can't find path to game_state" 
  end
   
  def same?(board1,board2)
    (0...3).each do |i|
      (0...3).each do |j|
        return false if board1[[i,j]] != board2[[i,j]]
      end
    end
    return true
  end
  #takes in current game board
  #find the child has max value, move current_node to that child 
  # return pos
  def self_move
    max_child = nil
    max_value = -1
    @game_tree.current_node.children.each do |child|
      if child.cost > max_value
        max_child = child
        max_value = child.cost
      end
    end
     #compare boards to find pos and update current_node in game_tree
    (0...3).each do |i|
      (0...3).each do |j|
        if @game_tree.current_node.board[[i,j]] != max_child.board[[i,j]]
          @game_tree.current_node = max_child
          return [i,j]
        end
      end
    end
  end

end

t = TTTtree.new(Board.new([[:o,nil,:o],[nil,:x,nil],[nil,nil,nil]]), :x)

p1 = HumanPlayer.new("me")
p2 = SuperComputerPlayer.new
game = TicTacToe.new(p1,p2)
game.run


