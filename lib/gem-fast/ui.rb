module GemFast
  module UI
    class RetryError < RuntimeError
    end
    
    class Input < String
      include UI
      def process_default(options={})
        if is?("q")
          exit(0)
        elsif is?("h")||is?("?")
          display options[:help]||"no help"
          raise RetryError
        else
          raise RetryError
        end
      end
      
      
      def yes?
        self.is?("y")
      end
      
      def is?(str)
        return if str.nil?
        self.downcase.strip == str.downcase.strip
      end
    end
    
    def display(msg, new_line = true)
      msg = msg.to_s.gsub(/_/) { ' ' }
      if new_line
        STDOUT.puts msg
      else
        STDOUT.print msg
      end
      STDOUT.flush
    end
    
    def error(msg="error")
      display msg
      exit(1)
    end
    
    def display2(msg)
      display(msg,false)
    end
    
    def confirm(message=nil, options={})
      if message.nil?
        message = "Are you sure you wish to continue?"
      end
      
      message << "(y/q/h)"
      
      ask_loop(message) do |input|
        if input.yes?
          yield
        else
          input.process_default(:help=>options[:help])
        end
      end
      ask.downcase == 'y'
    end

    def format_date(date)
      date = Time.parse(date) if date.is_a?(String)
      date.strftime("%Y-%m-%d %H:%M %Z")
    end
    
    def ask_loop(message,&block)
      display2 message+" "
      begin
        yield Input.new(ask)
      rescue RetryError => e
        display2 message
        retry
      end
    end
    
    def ask
      gets.strip
    end

    def shell(cmd)
      FileUtils.cd(Dir.pwd) {|d| return `#{cmd}`}
    end
  end
end