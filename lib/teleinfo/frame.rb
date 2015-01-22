module Teleinfo
  class Frame
    attr_reader :errors

    def initialize(lines)
      fail ArgumentError.new('Must instanciate with a non empty array of String') if !lines.is_a?(Array) || lines.empty? || lines.any? { |line| !line.is_a?(String) }
      @lines = lines
      tokenize
    end

    def to_hash
      @data
    end

    def to_json
      @data.to_json
    end

    protected
    def tokenize
      @errors = []
      @data = {}
      @lines.each do |line|
        case line
        when /^ADCO (\S{12}) ./
          @data[:adco] = $1
        when /^OPTARIF (....) ./
          @data[:optarif] = $1.sub(/\.+$/, '')
        when /^ISOUSC (\d{2}) ./
          @data[:isousc] = $1.to_i
        when /^HCHC (\d{9}) ./
          @data[:hchc] = $1.to_i
        when /^HCHP (\d{9}) ./
          @data[:hchp] = $1.to_i
        when /^PAPP (\d{5}) ./
          @data[:papp] = $1.to_i
        when /^PTEC (\S{4}) ./
          @data[:ptec] = $1.sub(/\.+$/, '')
        when /^IINST (\d{3}) ./
          @data[:iinst] = $1.to_i
        when /^IMAX (\d{3}) ./
          @data[:imax] = $1.to_i
        when /^HHPHC (\S{1})/
          @data[:hhphc] = $1
        else
          @errors << "Can't parse: #{line}"
        end
      end
      @data.freeze
      @errors.freeze
    end
  end
end
