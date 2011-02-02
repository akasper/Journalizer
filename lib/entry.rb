class UnwritableEntryException < Exception
end

class Entry
  attr_accessor :text
  attr_reader   :time, :output_stream
  
  def initialize(text=nil, time=nil)
    @text = text
    @time = time || Time.now
  end  
  
  def to_s
    @time.strftime("%H:%M:%S") + "\t" + text.gsub(/\n+/, "\n") + "\n"
  end
end

