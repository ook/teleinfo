require 'teleinfo/version'

module Teleinfo
  class Parser
    def initialize(file)
      fail ArgumentError.new('Must respond to #readline') unless file.respond_to?('readline')
      @file = file
      @frames = []
      @fully_parse = false # indicate EOF readched
    end

    def next(_only_valid = false)
      frame = []
      until @line =~ /ADCO/
        @line = @file.readline
      end
      frame << @line.chomp if @line.length > 2
      @line = @file.readline
      until @line =~ /ADCO/
        @line = @file.readline
      end
      frame
    end

    # Warning: for STDIN, will wait for EOF
    def read_all
      unless @fully_parse
        begin
          while true
            @frames << self.next(true)
          end
        rescue EOFError => eof
          @fully_parsed = true
          @frames.freeze
        end
      end
      @frames.length
    end

    def frames
      @fully_parsed ? @frames : @frames.clone(true)
    end
  end
end
