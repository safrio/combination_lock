module LockPicker
  module Validator
    def validate
      raise 'Disc count does not correspond to "from" elements count' if @disc_count != @from.count
      # ...
    end
  end
end
