# Gems
require 'rpi_gpio'
require 'json'

# Libraries
require_relative 'matrix.rb'

RPi::GPIO.set_numbering :bcm


def read_json
	json = File.read('json/capital_letters.json')
	JSON.parse(json)
	
end

# It clears the board and realeases the GPIO pins
def clear_board
	RPi::GPIO.reset
	puts 'The board has been cleared'
end

# Setup
rows    = [17, 27, 22, 05, 06, 13, 19, 26]
columns = [18, 23, 24, 25, 12, 16, 20, 21] 
matrix = Matrix.new rows, columns

capital_letters = read_json


begin
	while true
		# matrix.test
		capital_letters.each do |key, frame|
			puts "Writing #{key}"
			matrix.frame frame, 2
			sleep 0.5
		end
	end 
	rescue SignalException => e
    clear_board
end

