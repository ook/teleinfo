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

    def next(only_valid: true, store_frame: false)
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
          @frames << teleinfo_frame if store_frame
        elsif only_valid && !@fully_parsed
          raise teleinfo_frame.errors.inspect
          teleinfo_frame = self.next(true)
        end
        teleinfo_frame
      rescue EOFError => error
        @fully_parsed = true
        @frames.freeze if store_frame
        nil
      end
    end

    # Warning: for STDIN, will wait for EOF
    def read_all
      unless @fully_parsed
        last_frame = self.next(store_frame: true)
        until last_frame.nil? || @fully_parsed
          self.next(store_frame: true)
        end
      end
      @frames.length
    end

    def stop!
      @fully_parsed = true
      self
    end

    def each
      count = 0
      until (frame = self.next).nil? || @fully_parsed
        yield frame if block_given?
        count += 1
      end
      count
    end

    def frames
      @fully_parsed ? @frames : @frames.dup
    end
  end
end
