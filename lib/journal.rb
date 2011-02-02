require File.join(File.dirname(__FILE__), 'entry')
require File.join(File.dirname(__FILE__), 'file_output_stream')

# require 'fileutils'
class Journal
  attr_reader :entries, :input_stream, :output_stream
  
  def initialize(output_stream=FileOutputStream.new, input_stream=STDIN)
    @input_stream = input_stream
    @output_stream = output_stream
    @entries = []
  end
  
  def << entry
    @entries << entry
    @entries.sort! {|x, y| x.time - y.time}
  end
  
  def save!
    @entries.each { |entry| output_stream.write(entry) }
  end
end
