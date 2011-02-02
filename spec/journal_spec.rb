require File.join(File.dirname(__FILE__), '..', 'lib', 'journal')
describe Journal do
  HALLOWEEN = DateTime.parse('2010-10-31T13:13:13')
  NEW_YEAR  = DateTime.parse('2010-01-01T00:00:00')
  NEW_YEAR_NOON = DateTime.parse('2010-01-01T12:00:00')
  
  DEFAULT_OUTPUT_PATH = File.join(File.expand_path('.'), 'spec', 'tmp', '.journal')
  
  before :each do 
    @output = mock('Output Stream')
    @input = mock('Input Stream')
    @journal = Journal.new(@output, @input)
  end
  
  describe '#input_stream' do
    it { should respond_to :input_stream }
    
    it 'is defined in the constructor' do
      @journal.input_stream.should be @input
    end
  end
  
  describe '#output_stream' do
    it { should respond_to :output_stream }    
    
    it 'is defined in the constructor' do
      @journal.output_stream.should be @output
    end
  end
  
  describe '#entries' do
    it { should respond_to :entries }
    it 'returns an iterable object' do
      @journal.entries.should respond_to(:each)
    end
    it 'returns a collection' do
      @journal.entries.should respond_to(:length)
    end
    it 'is empty by default' do
      @journal.entries.length.should == 0
    end
    it 'sorts entries by time' do
      @journal << @entry1 = mock('First Entry', :time => HALLOWEEN)
      @journal << @entry2 = mock('Second Entry', :time => NEW_YEAR)
      @journal << @entry3 = mock('Third Entry', :time => NEW_YEAR_NOON)
      @journal.entries.should == [@entry2, @entry3, @entry1] 
    end
  end
  
  describe '#<<' do
    it { should respond_to :<< }

    it 'inserts an entry into the list of entries' do
      @journal << mock('Entry')
      @journal.entries.length.should == 1
    end
  end
  
  describe '#save!' do
    before(:each) do
      @journal << @entry = mock('Entry', :time => Time.now)
    end
    it { should respond_to :save! }
    
    it 'writes all entries to the output stream' do
      @journal << mock('Another Entry', :time => Time.now)
      @journal.output_stream.should_receive(:write).exactly(2).times 
      @journal.save!
    end
  end
  
  after :each do 
    `rm -rf #{DEFAULT_OUTPUT_PATH}`
  end
  
end