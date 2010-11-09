require File.join(File.dirname(__FILE__), 'entry')
require 'fileutils'
class Journal
  attr_reader :entries
  
  def initialize(path=nil)
    path ? read(path) : @entries = []
  end
  
  def << entry
    @entries << entry
    @entries.sort! {|x, y| x.time - y.time}
  end
  
  def save!(directory = File.join(File.expand_path('~'), '.journal') )
    FileUtils.mkdir_p(directory) 
    @entries.each do |entry|
      File.open(File.join(directory, entry.file_name), 'a') {|f| f.write(entry.to_s) }
    end
  end
  
end