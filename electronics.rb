# frozen_string_literal: true

# Gems
require 'rpi_gpio'
require 'json'

# Libraries
require_relative 'matrix.rb'

RPi::GPIO.set_numbering :bcm

# It clears the board and realeases the GPIO pins
def clear_board
  RPi::GPIO.reset
  puts 'The board has been cleared'
end

# Setup
rows    = [17, 27, 22, 0o5, 0o6, 13, 19, 26]
columns = [18, 23, 24, 25, 12, 16, 20, 21]
matrix = Matrix.new rows, columns

begin
  loop do
  end
rescue SignalException => e
  clear_board
end
