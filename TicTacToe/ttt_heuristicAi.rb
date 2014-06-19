class Board
  attr_accessor :board, :checks, :remaining_move
  def initialize
    @board=Array.new(3){Array.new(3){ " " }}
    @checks = [
      #Rows
      [@board[0][0], @board[0][1], @board[0][2]],
      [@board[1][0], @board[1][1], @board[1][2]],
      [@board[2][0], @board[2][1], @board[2][2]],
      #Columns
      [@board[0][0], @board[1][0], @board[2][0]],
      [@board[0][1], @board[1][1], @board[2][1]],
      [@board[0][2], @board[1][2], @board[2][2]],
      #Diagonals
      [@board[0][0], @board[1][1], @board[2][2]],
      [@board[0][2], @board[1][1], @board[2][0]]
    ]
    @remaining_move = 9
  end

  def pp
    @board.each do |row|
      print row
      print "\n"
    end
    print "\n"
   # p @checks
  end

  def won?
    @checks.any? { |spot| spot == ["x","x","x"] } || @checks.any? { |spot| spot == ["o","o","o"] }
  end
  
  def end_game?
    @remaining_move == 0
  end

  def empty?(pos)
    @board[pos.first][pos.last] == " "
  end

  def place_mark(pos,mark)
    if empty?(pos)
      @board[pos.first][pos.last].replace(mark)
      @remaining_move -= 1
    end
  end
end

class Game
  def initialize(player1,player2)
    @player1 = player1
    @player2 = player2
    @player1.mark = "o"
    @player1.opponent_mark="x"
    @player2.mark = "x"
    @player2.opponent_mark="o"
    @board = Board.new
    @player1_turn = true
  end

  def play
    while true
      if @player1_turn
        @player1.move(@board)
        @board.pp
      else
        @player2.move(@board)
        @board.pp
      end
      break if winner!="in_game"
      @player1_turn = !@player1_turn
    end
  end

  def winner  #return "in_game", or draw, or x or o
    if @board.won?
      if @player1_turn
        return "player 1 win"
      else
        return "player 2 win"
      end
    else
      if @board.end_game?
        return "draw"
      else
        return "in_game"
      end
    end
  end
end

class Player
  attr_accessor :mark, :opponent_mark, :is_bot

  def initialize(is_bot = false)
    @is_bot = is_bot
  end

  def move(board)
    if is_bot
      bot_move(board)
    else
      puts "Enter i j to place mark: "
      i,j = gets.chomp.split
      board.place_mark([i.to_i,j.to_i],self.mark)
    end
  end

  def defensive_move(board)
    critical_move(board,@opponent_mark,@mark)
  end

  def aggressive_move(board)
    critical_move(board,@mark,@mark)
  end

  def strategic_move(board)
     pattern_1 = [self.mark," "," "]
     pattern_2 = [" ",self.mark, " "]
     pattern_3 = [" ", " ", self.mark]
     board.checks.any? do |check|
        if check == pattern_1
          check[1].replace(self.mark)
          board.remaining_move -= 1
          break
        end
        if check == pattern_2
          check[0].replace(self.mark)
          board.remaining_move -= 1
          break
        end
        if check == pattern_3
          check[1].replace(self.mark)
          board.remaining_move -= 1
          break
        end
     end
  end

  def strategic_able?(board)
     pattern_1 = [self.mark," "," "]
     pattern_2 = [" ",self.mark, " "]
     pattern_3 = [" ", " ", self.mark]
     board.checks.any? do |check|
        return true if check == pattern_1
        return true if check == pattern_2
        return true if check == pattern_3
      end
      return false
  end

  def null_move(board)
    [[0,0],[0,2],[2,0],[2,2]].each do |pos|
      if board.empty?(pos)
        board.place_mark([pos.first,pos.last],self.mark)
        break
      end
    end
  end

  def about_to_lose?(board)
    about_to?(board,self.opponent_mark)
  end

  def about_to_win?(board)
    about_to?(board,self.mark)
  end

  def bot_move(board)
    if board.remaining_move==9 #first to move
      board.place_mark([1,1],self.mark)
    elsif board.remaining_move==8
        if board.empty?([1,1])
          board.place_mark([1,1],self.mark)
        else
          null_move(board)
        end
    else
      if about_to_win?(board)
        aggressive_move(board)
      elsif about_to_lose?(board)
        defensive_move(board)
      #elsif strategic_able?(board)
      # strategic_move(board)
      else
        null_move(board)
      end
    end 
  end

  private
  def about_to?(board,mark)
    pattern_1=[mark, mark," "]
    pattern_2=[mark," ",mark]
    pattern_3=[" ",mark,mark]
    board.checks.any? do |check| 
      if check == pattern_1 || check == pattern_2 || check == pattern_3
         return true
      end
    end
    return false
  end

  def critical_move(board,mark1,mark2)
    pattern_1=[mark1, mark1," "]
    pattern_2=[mark1," ",mark1]
    pattern_3=[" ",mark1,mark1]
    board.checks.any? do |check| 
      if check == pattern_1
        check[2].replace(mark2)
        board.remaining_move -= 1
        return true
      elsif check == pattern_2
        check[1].replace(mark2)
        board.remaining_move -= 1
        return true

      elsif check == pattern_3
        check[0].replace(mark2)
        board.remaining_move -= 1
        return true
      end
    end
    return false
  end
end

# P1= Player.new
# P2= Player.new(true)

# g=Game.new(P2,P1)
# g.play