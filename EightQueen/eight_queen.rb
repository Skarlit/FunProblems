class EightQueen
  attr_reader :board
  def initialize(n)
    @board=Array.new(n){ Array.new(n){ '*' } }
    @history=[]
    @size=n
  end

  def place(i,j)
    if valid?(i,j)
      @board[i][j]='Q'
      return true
    else
      return false
    end
  end

  def valid?(i,j)
    return false if j > @size - 1
    #if diagonals valid
    return false if valid_diag?(i,j,1) == false
    return false if valid_diag?(i,j,2) == false
    return false if valid_diag?(i,j,3) == false
    return false if valid_diag?(i,j,4) == false
    #if horizontal or vertical valid
    return false if @board[i].include? 'Q'
    @board.each do |row|
      return false if row[j].include? 'Q'
    end
    #it is valid otherwise
    return true
  end

  def valid_diag?(i,j,opts)
    if in_bound?(i) && in_bound?(j)
      if @board[i][j] == 'Q' 
      return false
      else
      case opts
      when 1
        valid_diag?(i + 1,j + 1,1)
      when 2
        valid_diag?(i - 1,j - 1,2)
      when 3
        valid_diag?(i + 1,j - 1,3)
      when 4
        valid_diag?(i - 1,j + 1,4)
      end
      end
    end
  end

  def in_bound?(index)
    return (0...@size).cover?(index)
  end

  def solver_recursive(i=0,j=0)   
    # if i out of bound, solution is found
    if i>=@size
      pp
      return true
    end
      
    #if place returns true
    if place(i,j)
      save(i,j)
      if i < @size
      solver_recursive(i + 1, 0)
      else
      return true #solution
      end
    #can't place but j not out of bound, advance j
    elsif j < @size - 1
      solver_recursive(i,j + 1)
    #j out of bound, need to backtrack 
    else
      pre_i,pre_j = undo
      solver_recursive(pre_i,pre_j + 1)
    end
  end

  def solver_non_recursive(i = 0,j = 0)
    while i != @size
      if place(i,j)
        save(i,j)
        if i < @size
          i += 1
          j = 0
        end
      elsif j < @size - 1
        j += 1
      else
        pre_i , pre_j = undo
        i , j = pre_i , pre_j + 1
      end
    end
    pp
  end

  def save(i,j)
    @history << [i,j]
  end

  def undo
    pre_i , pre_j = @history.pop
    @board[pre_i][pre_j] = '*'
    return [pre_i,pre_j]
  end

  def pp #pretty print
    @board.each do |row|
      print row.join(" ")
      print "\n"
    end
    puts "\n"
  end
end

print "Enter board size: "
size=gets.chomp
puts "Non-recursive:"
start=Time.now
Q8= EightQueen.new(size.to_i)
Q8.solver_non_recursive
finish=Time.now

puts "Time: #{(finish-start)}s"

print "\n"

puts "Recursive:"
start=Time.now
Q9= EightQueen.new(size.to_i)
Q9.solver_recursive
finish=Time.now

puts "Time: #{(finish-start)}s"