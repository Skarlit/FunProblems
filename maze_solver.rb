class MazeSolver

  def initialize(filename, welcome = false)
	@memo = Hash.new(false)
	@maze = Maze.new(filename)
	greet if welcome
	@solution = []
  end

  def greet
  	puts "Target Maze loaded..."
  	@maze.pp(true)
  end

  def dfs_solver
  	puts "Solving maze with Depth First Search...."
    solver("pop")
  end

  def bfs_solver
  	puts "Solving maze with Breath First Search...."
    solver("shift")
  end

  def solver(method)
	@root = Node.new(nil, @maze.start)
	queue = [@root]

	while !queue.empty?
	  current_node = queue.send(method)
	  if current_node.pos == @maze.finish
		backtrack!(current_node)
		break
	  else
		expand_at!(current_node).each do |child_node|
		@memo[child_node.pos] = true
		queue << child_node
		end
	  end
	end
  end

  def clear
  	@memo = Hash.new(false)
  	@solution = []
  end

  def backtrack!(finished_node)
	current = finished_node
	while current.pos != @maze.start
	  current = current.parent
	  @solution << current.pos 
	end
	@solution.pop  #without overwritting the "S" in maze
  end

  def print_solution
	duplicate = @maze.dup
	@solution.each do |pos|
	  duplicate[pos] = 'X'
	end
	duplicate.pp
  end

  def expand_at!(node)
	i, j = node.pos.first, node.pos.last
	directions = [[i+1,j],[i-1,j],[i,j+1],[i,j-1]]
	expandable = []
	directions.each do |dir|
	  if @maze.in_bound?(dir) && (not @maze.wall?(dir)) && (not in_memo?(dir))
		child_node = Node.new(node,dir)
		expandable << child_node
		node.children << child_node
	  end
    end
	return expandable
  end

  def in_memo?(pos)
	return @memo[pos]
  end
end

class Node
  attr_accessor :parent,:children, :pos
  def initialize(parent,pos)
    @parent = parent
	@pos = pos
	@children =[]
  end

  def add_node(node)
	node.parent = self
	@children << node
  end
end

class Maze
  attr_accessor :start, :finish, :maze
  def initialize(filename)
	@filename = filename
	@maze = File.readlines(@filename).map do |line|
	  line.chomp.split('')
	end
	@maze.each_with_index do |array, row|
	  array.each_with_index do |spot, col|
		if spot == 'S'
		  @start = [row,col]
		elsif spot == 'E'
		  @finish = [row,col]
		end
	  end
	end

	@height = @maze.length
	@width = @maze[0].length
  end

  def dup
	duplicate = Maze.new(@filename)
	return duplicate
  end

  def [](pos)
	return @maze[pos.first][pos.last]
  end

  def []=(pos,val)
    @maze[pos.first][pos.last] = val
  end

  def in_bound?(pos)
	(0...@height).cover?(pos.first) && (0...@width).cover?(pos.last)
  end

  def wall?(pos)
	self[pos] == '*'
  end

  def pp(descript = false)
	puts "Start from #{@start} to #{@finish}" if descript
	@maze.each do |row|
	  puts row.join(" ")
	end
  	puts "\n"
  end		
end

 m = MazeSolver.new('maze1.txt',true)
 m.dfs_solver
 m.print_solution
 m.clear
 m.bfs_solver
 m.print_solution