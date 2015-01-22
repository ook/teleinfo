module Teleinfo
  class Frame
    def initialize(lines)
      fail ArgumentError.new('Must instanciate with a non empty array of String') if !lines.is_a?(Array) || lines.empty? || lines.any? { |line| !line.is_a?(String) }
      @lines = lines
    end
  end
end
