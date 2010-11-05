require File.join(File.dirname(__FILE__), '..', 'lib', 'journal')
describe Journal do
  HALLOWEEN = Time.parse('2010-10-31T13:13:13')
  NEW_YEAR  = Time.parse('2010-01-01T00:00:00')
  NEW_YEAR_NOON = Time.parse('2010-01-01T12:00:00')
  
  DEFAULT_OUTPUT_PATH = File.join(File.expand_path('.'), 'spec', 'tmp', '.journal')
  
  before :each do 
    @journal = Journal.new
  end
  
  describe '#entries' do
    it 'is a valid method' do
      @journal.should be_respond_to(:entries)
    end
    it 'returns a collection' do
      @journal.entries.should be_a(Array)
    end
    it 'sorts entries by time' do
      @journal << (@entry1 = Entry.new('I\'m spooked out!', HALLOWEEN))
      @journal << (@entry2 = Entry.new('I am making resolutions', NEW_YEAR))
      @journal << (@entry3 = Entry.new('I am hung over.', NEW_YEAR_NOON))
      @journal.entries.should == [@entry2, @entry3, @entry1] 
    end
  end
  
  describe '#<<' do
    it 'is a valid method' do
      @journal.should be_respond_to(:<<)
    end
    
    it 'inserts an entry into the list of entries' do
      @journal << Entry.new
      @journal.entries.length.should == 1
    end
  end
  
  describe '#save!' do
    before(:each) do
      @journal << Entry.new('I am a ghost', HALLOWEEN)
    end
    it 'is a valid method' do
      @journal.should be_respond_to(:save!)
    end
    
    it 'creates files in the output path' do
      @journal.save!(DEFAULT_OUTPUT_PATH)
      Dir[DEFAULT_OUTPUT_PATH + "/*"].size.should == 1
    end
  end
  
  after :each do 
    `rm -rf #{DEFAULT_OUTPUT_PATH}`
  end
  
end