require_relative 'lock_picker/validator'

module LockPicker
  class Walker
    include LockPicker::Validator

    FAIL_MSG = 'There is no solution'.freeze

    def initialize(disc_count:, from:, to:, exclude:)
      @disc_count = disc_count
      @from = from
      @to = to
      @exclude = exclude
      @route = {}

      validate
    end

    def call
      queue = [@from]
      visited = []
      until queue.empty?
        current = queue.pop
        visited << current
        return calc_route if current == @to

        current.each_with_index do |val, position|
          [-1, 1].each do |increment|
            copy_current = current.dup
            copy_current[position] = normalize(val + increment)

            next if visited.include?(copy_current) || @exclude.include?(copy_current)

            @route[copy_current] = current
            visited << copy_current
            queue << copy_current
          end
        end
      end

      FAIL_MSG
    end

    protected

    def calc_route
      res = [@to]
      step = @route[@to]
      until step.nil?
        res.unshift(step)
        step = @route[step]
      end
      res
    end

    def normalize(num)
      return 9 if num.negative?
      return 0 if num > 9

      num
    end
  end
end
