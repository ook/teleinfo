module Teleinfo
  # Take an array of String to parse as a Téléinfo Frame
  class Frame
    attr_reader :errors

    def initialize(lines)
      fail ArgumentError.new('Must instanciate with a non empty array of String') if !lines.is_a?(Array) || lines.empty? || lines.any? { |line| !line.is_a?(String) }
      tokenize(lines)
    end

    def to_hash
      @data
    end

    def to_json
      @data.to_json
    end

    protected
    # Once parsed, @data and @errors are frozen since there's no need to alter them
    def tokenize(lines)
      @errors = []
      @data = {}
      lines.each do |line|
        case line
        when /^ADCO (\S{12}) ./
          @data[:adco] = $1
        when /^OPTARIF (....) ./
          @data[:optarif] = $1.sub(/\.+$/, '')
        when /^ISOUSC (\d{2}) ./
          @data[:isousc] = $1.to_i
        when /^BASE (\d{9}) ./ # BASE TARIF
          @data[:base] = $1.to_i
        when /^HCHC (\d{9}) ./ # HPHC TARIF
          @data[:hchc] = $1.to_i # HPHC TARIF
        when /^HCHP (\d{9}) ./ # HPHC TARIF
          @data[:hchp] = $1.to_i
        when /^PAPP (\d{5}) ./
          @data[:papp] = $1.to_i
        when /^PTEC (\S{4}) ./
          @data[:ptec] = $1.sub(/\.+$/, '')
        when /^IINST (\d{3}) ./
          @data[:iinst] = $1.to_i
        when /^IMAX (\d{3}) ./
          @data[:imax] = $1.to_i
        when /^HHPHC (\S{1})/ # HPHC TARIF
          @data[:hhphc] = $1
        when /^BBRHCJB (\d{9}) ./ # TEMPO Jour Bleu
          @data[:bbrhcjb] = $1.to_i
        when /^BBRHPJB (\d{9}) ./
          @data[:bbrhpjb] = $1.to_i # TEMPO Jour Bleu
        when /^BBRHCJW (\d{9}) ./
          @data[:bbrhcjw] = $1.to_i # TEMPO Jour Blanc
        when /^BBRHPJW (\d{9}) ./
          @data[:bbrhpjw] = $1.to_i # TEMPO Jour Blanc
        when /^BBRHCJR (\d{9}) ./
          @data[:bbrhcjr] = $1.to_i # TEMPO Jour rouge
        when /^BBRHPJR (\d{9}) ./
          @data[:bbrhpjr] = $1.to_i # TEMPO Jour rouge
        when /^DEMAIN (\S{4}) ./ # TEMPO lendemain
          @data[:bbrhpjr] = $1
        when /^ADPS (\d{3})/ # Alerte dépassement de seuil
          @data[:adps] = $1.to_i
        when /MOTDETAT/
          # always 00000…
        else
          @errors << "Can't parse: #{line}"
        end
      end
      @data.freeze
      @errors.freeze
    end
  end
end
