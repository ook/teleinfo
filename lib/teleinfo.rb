require 'teleinfo/version'
require 'teleinfo/frame'

require 'json'

module Teleinfo
  class Parser
    def initialize(file)
      fail ArgumentError.new('Must respond to #readline') unless file.respond_to?('readline')
      @file = file
      @frames = []
      @fully_parsed = false # indicate EOF readched
    end

    def next(only_valid = true)
      begin
        frame = []
        until @line =~ /ADCO/
          @line = @file.readline
        end
        frame << @line.chomp if @line.length > 6
        @line = @file.readline
        until @line =~ /ADCO/
          frame << @line.chomp if @line.length > 6
          @line = @file.readline
        end
        teleinfo_frame = Teleinfo::Frame.new(frame)
        if teleinfo_frame.errors.empty?
          @frames << teleinfo_frame
        elsif only_valid && !@fully_parsed
          raise teleinfo_frame.errors.inspect
          teleinfo_frame = self.next(true)
        end
        teleinfo_frame
      rescue EOFError => error
        @fully_parsed = true
        @frames.freeze
        nil
      end
    end

    # Warning: for STDIN, will wait for EOF
    def read_all
      unless @fully_parsed
        last_frame = self.next(true)
        until last_frame.nil? || @fully_parsed
          self.next(true)
        end
      end
      @frames.length
    end

    def each
      until (frame = self.next).nil?
        yield frame if block_given?
      end
    end

    def frames
      @fully_parsed ? @frames : @frames.dup
    end
  end
end
