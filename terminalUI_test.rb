
module MyUI
require 'io/wait'

	def clear_screen ()  print "\e[2J"           end
	def clear_line()     print "\e[2K"           end
	def reset_cursor()   print "\e[H"            end
	def move_cursor(i,j) print "\e[#{i};#{j}H"   end
	def forward(n=1)     print "\e[#{n}C"        end
	def backward(n=1)    print "\e[#{n}D"	     end
	def up(n=1)          print "\e[#{n}A"        end
	def down(n=1)        print "\e[#{n}B"        end
	def erase_display()  print "\e[2J"           end
	def key_press
	  system("stty raw -echo")  #raw mode on
	  key = STDIN.getc.chr
	  system("stty -raw echo")  #raw mode off
	  return key
	end


end

while 1
	print key_press
end
]
