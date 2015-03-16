require 'spec_helper'

StringFrame = [
                'ADCO 424242424242 E',
                'OPTARIF HC.. <',
                'ISOUSC 30 9',
                'BASE 101597537 1',
                'HCHC 023995979 ;',
                'HCHP 038653523 6',
                'PTEC HP..  ',
                'IINST 008 _',
                'IMAX 041 D',
                'PAPP 01770 0',
                'HHPHC D'
             ]

describe Teleinfo::Frame do
  it 'should instanciate only with a non empty Array of String' do
    expect{ Teleinfo::Frame.new() }.to raise_error
    expect{ Teleinfo::Frame.new(nil) }.to raise_error
    expect{ Teleinfo::Frame.new([]) }.to raise_error
    expect{ Teleinfo::Frame.new([nil]) }.to raise_error
    expect{ Teleinfo::Frame.new([:pouet]) }.to raise_error
    expect{ Teleinfo::Frame.new(['ok']) }.not_to raise_error
    expect{ Teleinfo::Frame.new(['ok', 'ok', 'ok']) }.not_to raise_error
  end

  it 'should have no error when parsing a correct frame' do
    frame = Teleinfo::Frame.new(StringFrame)
    expect(frame.errors).to eq([])
  end

  it 'should return valid Hash on #to_hash' do
    frame = Teleinfo::Frame.new(StringFrame)
    expect(frame.to_hash).to eq({
                                  :adco=>"424242424242",
                                  :optarif=>"HC",
                                  :isousc=>30,
                                  :base=>101597537,
                                  :hchc=>23995979,
                                  :hchp=>38653523,
                                  :ptec=>"HP",
                                  :iinst=>8,
                                  :imax=>41,
                                  :papp=>1770,
                                  :hhphc=>"D"
                                 })
  end
end
