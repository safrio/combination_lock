require_relative 'lock_picker'

class Test
  class << self
    def call
      singleton_methods.each do |test|
        next if test == :call

        send(test)
      end
    end

    def assert_disc_not_correspond
      result = nil
      expected = 'Disc count does not correspond to "from" elements count'
      disc_count = 3
      from = [0, 0]
      to = [1, 1]
      exclude = []
      LockPicker::Walker.new(disc_count: disc_count, from: from, to: to, exclude: exclude).call
    rescue RuntimeError => e
      result = e.message
    ensure
      puts "#{__method__} #{result == expected}"
    end

    def assert_no_solution
      disc_count = 2
      from = [0, 0]
      to = [1, 1]
      exclude = [[0, 1], [1, 0], [0, 9], [9, 0]]
      result = LockPicker::Walker.new(disc_count: disc_count, from: from, to: to, exclude: exclude).call
      expected = 'There is no solution'
      puts "#{__method__} #{result == expected}"
    end

    def assert_success
      disc_count = 3
      from = [0, 0, 0]
      to = [1, 1, 1]
      exclude = [[0, 0, 1], [1, 0, 0], [0, 0, 9]]
      result = LockPicker::Walker.new(disc_count: disc_count, from: from, to: to, exclude: exclude).call
      expected = [
        [0, 0, 0],
        [0, 1, 0],
        [0, 1, 1],
        [1, 1, 1]
      ]
      puts "#{__method__} #{result == expected}"
    end
  end
end

Test.call
