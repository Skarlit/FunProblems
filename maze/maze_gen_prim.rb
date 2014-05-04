#Randomized Prim's algorithm

class Node
  attr_accessor :i, :j, :sym
  def initialize(i, j, sym = "*")
    @i, @j, @sym = i, j, sym
  end

  def wall?
    @sym == "*"
  end
end

class MazeGen


  def initialize(height, width)
    @height = height
    @width = width
    @maze = Array.new(height) {Array.new(width)}
    (0...height).each do |i|
      (0...width).each do |j|
        @maze[i][j] = Node.new(i,j)
      end
    end

    @wall_list = []
    @maze_list = Hash.new(false)

  end

  def generate
    start = @maze.sample.sample
    mark_as_maze(start)
    add_walls_of(start)
    while !@wall_list.empty?
      wall = @wall_list.sample  
      wall.

    end
  end

  def mark_as_maze(node)
    node.sym = " "
    @maze_list[node] = true
  end

  def in_bound?(i, j)
    (0...@height).cover?(i) && (0...@width).cover?(j)
  end

  def neighbor(node, dx, dy)
    if in_bound?(node.i+dx, node.j+dy)
      @maze[node.i+dx][node.j+dy]
    else
      nil
    end
  end

  def neighbors_nonwall(node)
    set = []
    set << @maze[node.i][node.j+1] if in_bound?(node.i, node.j+1) && !@maze[node.i][node.j+1].wall?
    set << @maze[node.i][node.j-1] if in_bound?(node.i, node.j-1) && !@maze[node.i][node.j-1].wall?
    set << @maze[node.i+1][node.j] if in_bound?(node.i+1, node.j) && !@maze[node.i+1][node.j].wall?
    set << @maze[node.i-1][node.j] if in_bound?(node.i=1, node.j) && !@maze[node.i-1][node.j].wall?
    set
  end

  def neighbors_wall(node)
    set = []
    set << @maze[node.i][node.j+1] if in_bound?(node.i, node.j+1) && @maze[node.i][node.j+1].wall?
    set << @maze[node.i][node.j-1] if in_bound?(node.i, node.j-1) && @maze[node.i][node.j-1].wall?
    set << @maze[node.i+1][node.j] if in_bound?(node.i+1, node.j) && @maze[node.i+1][node.j].wall?
    set << @maze[node.i-1][node.j] if in_bound?(node.i=1, node.j) && @maze[node.i-1][node.j].wall?
    set
  end


  def part_of_maze?(node)
    @maze_list[node]
  end

  def add_walls_of(node)
    [-1, 0, 1].each do |dx|
      [-1, 0, 1].each do |dy|
        if dx != 0 && dy !=0
          adj = neighbor(node, dx, dy)
          @wall_list << adj if adj.wall?
        end
      end
    end 
  end

end