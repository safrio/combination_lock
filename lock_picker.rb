require 'set'

module LockPicker
  class Walker
    def initialize(from:, to:, exclude:)
      @from = from
      @to = to
      @exclude = Set.new(exclude)
    end

    def call
      queue = [[@from]]
      visited = Set.new

      until queue.empty?
        path = queue.shift
        current = path.last

        return path if current == @to

        current.each_with_index do |val, position|
          [-1, 1].each do |diff|
            copy_current = current.dup
            copy_current[position] = normalize(val + diff)

            next if visited.include?(copy_current) || @exclude.include?(copy_current)

            visited.add(copy_current)
            queue << (path + [copy_current])
          end
        end
      end

      nil
    end

    protected

    def normalize(num)
      return 9 if num.negative?
      return 0 if num > 9

      num
    end
  end
end
