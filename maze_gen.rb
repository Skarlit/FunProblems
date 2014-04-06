class MazeGen
  attr_accessor :maze

  def initialize(opts={})
  	@size = opts[:size]
  	@maze = Maze.new(@size)
  	@entrance = [-1,0] || opts[:entrance]-1
  	@exit = [@size, @size-1] || opts[:exit]-1

  	@maze[@entrance] = 'S'
  	@maze[@exit] = 'E'
  end

  def p_maze
  	self.maze.pp
  end

end


class Maze
  attr_accessor :maze

  def initialize(size)
	   @maze = Array.new(size+2){Array.new(size+2){"*"}}
  end

  def pp
  	self.maze.each do |row|
  		print row.join(" ") + "\n"
  	end
  end

  def [](pos)
  	return self.maze[pos.first+1][pos.last+1]
  end

  def []=(pos,val)
  	return self.maze[pos.first+1][pos.last+1]=val
  end

end

m=MazeGen.new({size: 16})
m.p_maze