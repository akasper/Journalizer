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
    STDOUT.sync = true
    puts "To quit, enter 'Q' at the command prompt, or type [Ctrl + C]."
    #Reminder thread
    reminder = Thread.new { while true; wait; prompt; end }
    main     = Thread.new { while true; read; write; end }
    reminder.join
    main.join
  end
  
  def prompt
    growl_notify("Time for a journal entry.")
  end
  
  def read
    print " > "; @input = gets
    exit if @input =~ /^\s*(q|exit)\s*$/i
  end
  
  def write
    @journal << Entry.new(@input, Time.now)
    growl_notify("Next reminder at #{(Time.now + wait_time).strftime('%H:%M')}.")
  end
  
  def wait
    `sleep #{wait_time.to_s}`
  end  
  
  private
  def growl_notify(message)
    `growlnotify Journal --message "#{message}"`
  end
  
  def wait_time
    @interval - Time.now.to_i % @interval
  end
end
 
@app = JournalApp.new
END {puts "\nExiting..."; @app.journal.save!}
begin
  @app.run
#When the user hits Ctrl + C, exit a bit more gracefully...
rescue SignalException => e
  exit
end

