require 'debugger'
require 'colorize'

class Chamber
  attr_accessor :ix,:jx, :iy,:jy, :hole1, :hole2, :hole3, :hole4

  def initialize(ix, jx, iy, jy)
    @ix, @jx, @iy, @jy = ix, jx, iy, jy
  end

  def width
    @jy - @jx
  end

  def height
    @iy - @ix
  end
end

class Maze
  attr_accessor :root_chamber

  def initialize(height, width)
    @height, @width = height, width
    @maze = Array.new(@height) { Array.new(@width) {" "}}


    @maze[0] = ["*"] * @width
    @maze[@height - 1] = ["*"] * @width
    (0...@height).each do |i| 
      @maze[i][0] = "*"
      @maze[i][@width - 1] = "*"
    end

    @root_chamber = Chamber.new(1,1, @height-2, @width-2)

  end


  def pp
     @maze.each do |row|
      row.each do |grid|
        print "  ".colorize(:background => :white) if grid == " "
        print "  ".colorize(:background => :red) if grid == "*"
      end
      print "\n"
    end
  end

  def recurse_slice(n = 1000)
    queue = [@root_chamber]
    n.times do 
      return if queue.empty?
      current_chamber = queue.shift
      new_chambers = random_slice(current_chamber)
      unless new_chambers.nil?
        new_chambers.each do |new_chamber|
          queue << new_chamber
        end
      end
    end
  end

  def random_slice(chamber) #returns 4 sub chambers
     #skip if chamber too small
     return nil if chamber.width < 4 || chamber.height < 4

     #generate random slice

     i_slice = chamber.ix + rand(1...chamber.height)
     until i_slice != chamber.hole3.to_i && i_slice != chamber.hole4.to_i
       i_slice = chamber.ix + rand(1...chamber.height)
     end

     j_slice = chamber.jx + rand(1...chamber.width)
     until j_slice != chamber.hole1.to_i && j_slice != chamber.hole2.to_i
       j_slice = chamber.jx + rand(1...chamber.width)
     end

     #slice horizontal
     (0..chamber.width).each do |del|
        @maze[i_slice][chamber.jx + del] = "*"
     end

     #slice vertical
     (0..chamber.height).each do |del|
        @maze[chamber.ix + del][j_slice] = "*"
     end

     #open wall horizontal
     hole1 = rand(chamber.jx...j_slice)
     hole2 = rand((j_slice + 1)...chamber.jy)
     @maze[i_slice][hole1] = " "  unless hole1.nil?
     @maze[i_slice][hole2] = " "  unless hole2.nil?

     #open wall vertical
     hole3 = rand(chamber.ix...i_slice)
     hole4 = rand((i_slice+1)...chamber.iy)
     @maze[hole3][j_slice] = " "  unless hole3.nil?
     @maze[hole4][j_slice] = " "  unless hole4.nil?


     #return horizontal chambers
     c1 = Chamber.new(chamber.ix, chamber.jx, i_slice - 1, j_slice - 1)
     c2 = Chamber.new(chamber.ix, j_slice + 1, i_slice - 1, chamber.jy)

     c3 = Chamber.new(i_slice + 1, chamber.jx, chamber.iy, j_slice - 1)
     c4 = Chamber.new(i_slice + 1, j_slice + 1, chamber.iy, chamber.jy)

     #set holes
     c1.hole1, c1.hole3 = hole1, hole3
     c2.hole3, c2.hole2 = hole3, hole2
     c3.hole1, c3.hole4 = hole1, hole4
     c4.hole2, c4.hole4 = hole2, hole4

     return [c1, c2, c3, c4]
  end

  def save(filename)
    File.open(filename,'w') do |f|
     f.puts @maze.map { |row| row.join("")}.join("\n")
    end
  end

  def set_random_endpoint
    @maze[rand(1...(@height-1))][rand(1...(@width-1))] = "E"
    @maze[rand(1...(@height-1))][rand(1...(@width-1))] = "S"    
  end

  def self.auto(width,height,slices, filename)
    a = Maze.new(width,height)
    a.recurse_slice(slices)
    a.pp
    a.set_random_endpoint
    a.save(filename)
  end

end



Maze.auto(50, 50, 1000, "maze_recurse_gen_30x30_randomized_start")