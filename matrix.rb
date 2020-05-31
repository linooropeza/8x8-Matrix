# frozen_string_literal: true

require 'rpi_gpio'

class LED_Matrix
  DELAY = 0.0000000001

  def initialize(rows, columns)
    # Rows and columns are arrays containing the pin values
    # of the rows and columns of the LED Matrix
    # This class assumes that the rows are connected to the anodes
    # of the LEDs and the columns to the cathodes
    @rows = rows
    @columns = columns
    @letters_capital = read_json 'capital_letters.json'

    # Setting up the Matrix to off
    @rows.each do |pin|
      RPi::GPIO.setup pin, as: :output, initialize: :low
    end
    @columns.each do |pin|
      RPi::GPIO.setup pin, as: :output, initialize: :high
    end
   end

  # TODO: Modify Test Method to work with binary numbers
  def test
    count = 0
    @rows.each do |row|
      RPi::GPIO.set_high row
      @columns.each do |column|
        RPi::GPIO.set_low column
        count += 1
        puts "Count is #{count}"
        sleep DELAY
        RPi::GPIO.set_high column
      end
      RPi::GPIO.set_low row
    end
 end

  def string(string, delay)
    words = string.split(' ')
    words.each do |word|
      letters = word.chars
      letters.each do |letter|
        frame @letters_capital[letter.upcase], delay
      end
      sleep delay
    end
  end

  def frame(frame, delay)
    # The frame is a matrix with the same ammount of rows and columns
    # than the marix
    time_start = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    loop do
      @rows.length.times do |row|
        @columns.length.times do |column|
          next unless ((frame[row] << column) & 0b10000000).positive?

          RPi::GPIO.set_high @rows[row]
          RPi::GPIO.set_low @columns[column]
          sleep DELAY
          RPi::GPIO.set_low @rows[row]
          RPi::GPIO.set_high @columns[column]
        end
      end

      time_current = Process.clock_gettime(Process::CLOCK_MONOTONIC)
      break if time_current - time_start > delay
    end
  end

  private

  def read_json(json_file)
    directory = __dir__
    directory = File.join directory, 'json'
    json = File.read File.join(directory, json_file)
    characters = JSON.parse(json)
    characters.map { |k, v| [k, v.map { |num| num.to_i(2) }] }.to_h
  end
end
