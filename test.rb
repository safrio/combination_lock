require_relative 'lock_picker'

class Test
  class << self
    def call
      singleton_methods.each do |test|
        next if test == :call

        send(test)
      end
    end

    def assert_success
      disc_count = 3
      from = [0, 0, 0]
      to = [1, 1, 1]
      exclude = [[0, 0, 1], [1, 0, 0], [0, 0, 9]]
      result = LockPicker::Walker.new(from: from, to: to, exclude: exclude).call
      expected = [
        [0, 0, 0],
        [0, 1, 0],
        [1, 1, 0],
        [1, 1, 1]
      ]
      puts "#{__method__} #{result == expected}"
    end

    def assert_no_solution
      disc_count = 2
      from = [0, 0]
      to = [1, 1]
      exclude = [[0, 1], [1, 0], [0, 9], [9, 0]]
      result = LockPicker::Walker.new(from: from, to: to, exclude: exclude).call
      expected = nil
      puts "#{__method__} #{result == expected}"
    end
  end
end

Test.call
