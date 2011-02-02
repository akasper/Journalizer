require 'fileutils'

class FileOutputStream
  attr_reader :path
  def initialize(path='~/.journal')
    FileUtils.mkdir_p(@path = File.expand_path(path).to_s)
  end
  
  def write(entry)
    File.open(File.expand_path(File.join(path, file_name(entry.time))), 'a') { |f| f.puts entry.to_s }
  end

  def file_name(time)
    time.strftime('%Y_%m_%d') + '.txt'
  end
end
