class Entry
  attr_accessor :text
  attr_reader   :time
  
  def initialize(text=nil, time=nil)
    @text = text
    @time = time || Time.now
  end
  
  def file_name
    @time.strftime('%Y_%m_%d') + '.txt'
  end
  
  def to_s
    @time.strftime("%H:%M:%S") + "\t" + text.gsub(/\n+/, "\n") + "\n\n"
  end
end