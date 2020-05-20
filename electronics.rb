# Gems
require 'rpi_gpio'

# Libraries
require_relative 'matrix.rb'

RPi::GPIO.set_numbering :bcm

# RPi::GPIO.setup PIN_NUM, :as => :output, :initialize => :high



def clear_board
	RPi::GPIO.reset
	puts 'The board has been cleared'
end


# Setup
rows    = [17, 27, 22, 05, 06, 13, 19, 26]
columns = [18, 23, 24, 25, 12, 16, 20, 21] 
matrix = Matrix.new rows, columns

frame = [# 1  2  3  4  5  6  7  8
					[0, 0, 0, 0, 0, 0, 0, 0], # 1
					[0, 1, 1, 0, 0, 1, 1, 0], # 2
					[0, 1, 1, 0, 0, 1, 1, 0], # 3
					[0, 0, 0, 1, 1, 0, 0, 0], # 4
					[0, 0, 0, 1, 1, 0, 0, 0], # 5
					[0, 1, 0, 0, 0, 0, 1, 0], # 6
					[0, 0, 1, 1, 1, 1, 0, 0], # 7
					[0, 0, 0, 0, 0, 0, 0, 0]  # 8				
]

begin
	while true
		# matrix.test
		matrix.frame frame
	end 
	rescue SignalException => e
    clear_board
end

