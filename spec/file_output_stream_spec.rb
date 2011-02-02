require File.join(File.dirname(__FILE__), '..', 'lib', 'file_output_stream')
require File.join(File.dirname(__FILE__), 'output_stream_shared_example')

HALLOWEEN = DateTime.parse('2010-10-31T13:13:13')
SPEC_OUTPUT_PATH = './spec/tmp/file_output_stream/'

def remove_test_dir
  FileUtils.rm_rf(SPEC_OUTPUT_PATH) if File.directory?(File.expand_path(SPEC_OUTPUT_PATH))
end

def create_file_output_stream
  FileOutputStream.new(SPEC_OUTPUT_PATH)
end

describe FileOutputStream do
  it_should_behave_like "Output Stream"
  
  before(:each) { @stream = create_file_output_stream }
  describe '.new' do
    context 'given the path does not exist' do
      it 'should create the directory' do
        remove_test_dir
        create_file_output_stream
        File.directory?(SPEC_OUTPUT_PATH).should be_true
      end
    end
  end
  
  describe '#path' do
    it { should respond_to :path }
    it 'is a constructor parameter' do
      @stream.path.should == File.expand_path(SPEC_OUTPUT_PATH).to_s
    end
  
    it 'is "~/.journal" by default' do
      FileOutputStream.new.path.should == File.expand_path('~/.journal').to_s
    end
    
  end
  
  describe '#write' do
    describe 'given an entry' do
      before(:each) { @entry = mock('Entry', :time => HALLOWEEN, :to_s => 'entry.to_s') }
      
      describe 'given no file in the path with the entry\'s name exists' do
        before(:each) do 
          remove_test_dir
          create_file_output_stream.write(@entry)
        end
        
        it 'creates a file in the path with the entry\'s date as the file name' do
          Dir.new(File.expand_path(SPEC_OUTPUT_PATH)).entries.should include('2010_10_31.txt')
        end
        it 'writes the entry to the given file' do
          File.open(File.join(File.expand_path(SPEC_OUTPUT_PATH), '2010_10_31.txt'), 'r').read.should =~ /entry\.to_s/
        end
      end
    end
  end
  
  after(:all) { remove_test_dir }
end