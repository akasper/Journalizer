require File.join(File.dirname(__FILE__), '..', 'lib', 'entry')
describe Entry do
  before :each do
    @entry = Entry.new
  end
  
  describe '#text' do
    it 'is a valid method' do
      @entry.should be_respond_to(:text)
    end
    
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
    it 'is a valid method' do
      @entry.should be_respond_to(:time)
    end
    
    it 'cannot be assigned' do
      lambda {@entry.time = Time.now}.should raise_error
    end
    
    it 'is assigned by default' do
      @entry.time.should_not be_nil
    end
    
    it 'is a time by default' do
      @entry.time.should be_a Time
    end
    
    it 'can be the second parameter of the constructor' do
      time = Time.parse('2010-01-01')
      @entry = Entry.new(nil, time)
      @entry.time.should == time
    end
  end
end