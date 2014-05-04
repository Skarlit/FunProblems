require 'debugger'
class Pos

  attr_accessor :i,:j

  def initialize(i,j) @i,@j = i, j end

  def +(new_pos) Pos.new(@i + new_pos.i, @j + new_pos.j) end

  def -(new_pos) Pos.new([@i - new_pos.i, @j - new_pos.j]) end

  def ==(new_pos)
    return false if new_pos.nil?
    @i == new_pos.i && @j == new_pos.j
  end

  def to_a() [@i, @j] end

  def is_diag?(end_pos)
    self.right_diag_to?(end_pos) || self.left_diag_to?(end_pos)
  end

  def horizontal_to?(end_pos) end_pos.i == @i end

  def vertical_to?(end_pos) end_pos.j == @j end

  def right_diag_to?(end_pos)  @i - end_pos.i == end_pos.j - @j end

  def left_diag_to?(end_pos) @i - end_pos.i == @j - end_pos.j end

  def lower_right_diag_to?(end_pos) 
    (@i - end_pos.i == end_pos.j - @j) && @j < end_pos.j 
  end

  def upper_right_diag_to?(end_pos)
      (@i - end_pos.i == end_pos.j - @j) && @j > end_pos.j
  end

  def upper_left_diag_to?(end_pos)
     (@i - end_pos.i == @j - end_pos.j) && @i < end_pos.i
  end

  def lower_left_diag_to?(end_pos)
     (@i - end_pos.i == @j - end_pos.j) && @i > end_pos.i
  end
end

#  p1 = Pos.new(3,4)
#  p2 = Pos.new(6,7)
#  p3 = Pos.new(3,1)
#  p4 = Pos.new(1,3)
#  p5 = Pos.new(1,7)
#  p6 = Pos.new(1,-20)

# p p1.upper_left_diag_to?(p2)
# p p1.lower_left_diag_to?(p2)
# p p3.upper_right_diag_to?(p4)
# p p3.lower_right_diag_to?(p4)
