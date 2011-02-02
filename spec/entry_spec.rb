require File.join(File.dirname(__FILE__), '..', 'lib', 'entry')

describe Entry do
  before :each do
    @entry = Entry.new
  end
  
  describe '#text' do
    it { should respond_to :text }

    it 'can be assigned' do
      @entry.text = 'foo'
      @entry.text.should == 'foo'
    end
    
    it 'can be the first parameter of the constructor' do
      @entry = Entry.new('foo')
      @entry.text.should == 'foo'
    end
  end
  
  describe '#time' do
    it { should respond_to :time }

    it 'is not writable' do
      lambda {@entry.time = mock('Time')}.should raise_error
    end
    
    it 'is assigned by default' do
      @entry.time.should_not be_nil
    end
    
    it 'can be the second parameter of the constructor' do
      time = mock('DateTime')
      @entry = Entry.new(nil, time)
      @entry.time.should == time
    end
  end
  
  describe '#to_s' do
    before :each do
      time = mock('DateTime', :strftime => 'time')
      @entry = Entry.new('message', time)
    end
    it 'contains the time' do
      @entry.to_s.should =~ /time/
    end
    it 'contains the text' do
      @entry.to_s.should =~ /message/
    end
  end
end
