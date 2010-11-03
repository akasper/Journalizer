#!/usr/bin/env ruby
require File.join(File.dirname(__FILE__), 'journal')
class JournalApp
  attr_accessor :input
  attr_reader :interval, :journal
  
  def initialize(interval=1800)
    @interval = interval
    @journal = Journal.new
  end
  
  def run
    puts "To quit, enter 'Q' at the command prompt, or type [Ctrl + C]"
    while true
      self.prompt
      self.read
      self.write
      self.wait
    end
  end
  
  def prompt
    `growlnotify Journal --message "Time for a journal entry!"`
    print "\nWhat are you working on right now? > "
  end
  
  def read
    @input = gets
    exit if @input =~ /^\s*q\s*$/i
  end
  
  def write
    @journal << Entry.new(@input, Time.now)
  end
  
  def wait
    wait_time = @interval - Time.now.to_i % @interval
    puts "Next entry at #{(Time.now + wait_time).strftime('%H:%M')}."
    `sleep #{wait_time.to_s}`
  end  
end
 
@app = JournalApp.new
END {puts "\nExiting..."; @app.journal.save!}
begin
  @app.run
#When the user hits Ctrl + C, exit a bit more gracefully...my
rescue SignalException => e
  exit
end

