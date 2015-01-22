require 'spec_helper'

describe Teleinfo::Parser do
  RAW_TELEINFO_FILE = File.expand_path(File.dirname(__FILE__)) + '/raw/teleinfo_HCHP_anon'
  let(:raw_file) do
    File.new(RAW_TELEINFO_FILE.to_s)
  end

  it 'has a version number' do
    expect(Teleinfo::VERSION).not_to be nil
  end

  context 'On initialization' do
    it 'should initialize with a File' do
      expect{Teleinfo::Parser.new(raw_file)}.not_to raise_error
      expect{Teleinfo::Parser.new(nil)}.to raise_error
    end
  end

  context 'On parsing a stream' do
    before do
      @parser = Teleinfo::Parser.new(raw_file)
    end

    it 'should return TeleinFo::Frame instances' do
      @parser.read_all
      expect(@parser.frames.all? { |f| f.is_a?(Teleinfo::Frame) }).to be true
    end

    it 'should be able to tell how many frame are present' do
      expect(@parser.read_all).to eq(60)
    end

    it 'should keep in cache every frame read' do
      frame = @parser.next
      @parser.read_all
      expect(@parser.frames[0]) == frame # striclty the same object
    end

    it 'should give the "next" frame' do
      frame = @parser.next
      expect(frame).to be_a(Teleinfo::Frame)
    end
  end
end
