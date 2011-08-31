#!/usr/bin/env ruby
require File.join(File.dirname(__FILE__), 'journal')

class JournalApp
  POLLING_INTERVAL = 15.0
  INSTRUCTIONS = "To quit, enter 'Q' at the command prompt, or type [Ctrl + C]."
  attr_accessor :input, :next_notification
  attr_reader :interval, :journal
  
  def initialize(interval=30)
    @interval = interval
    @next_notification = Time.now + @interval
    @journal = Journal.new
  end
  
  def run
    STDOUT.sync = true
    puts INSTRUCTIONS

    main_thread.join
    reminder_thread.join
  end

  def reminder_thread
    Thread.new { wait }
  end

  def main_thread
    Thread.new { while true; read; write; end }
  end
  
  def notify
    growl_notify("Time for a journal entry.")
  end
  
  def read
    @input = Readline.readline(' > ', true)
    exit if ( !@input || @input =~ /^\s*(q|exit)\s*$/i )
  end
  
  def write
    @journal << Entry.new(@input, Time.now)
    
    #we make this the #write's responsibility to ensure that a 
    #user is not prompted if he has already written an entry
    #during the last interval
    update_notification
    growl_notify("Next reminder at #{(@next_notification).strftime('%H:%M')}.")
  end
  
  def wait
    while true
      if Time.now > @next_notification      
        update_notification
        notify
      end
      sleep POLLING_INTERVAL
    end
  end  
  
private
  def growl_notify(message)
    `growlnotify Journal --message "#{message}"`
  end

  def update_notification
    @next_notification = Time.now + @interval
  end
end
 
@app = JournalApp.new
END {puts "\nExiting..."; @app.journal.save!; exit}
begin
  @app.run
#When the user hits Ctrl + C, exit a bit more gracefully...
rescue SignalException => e
  exit
end

