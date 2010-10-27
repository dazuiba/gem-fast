require 'gem-fast/ui'
module GemFast
  module Command
    class Base
      include GemFast::UI
      attr_accessor :args   
      
      def initialize(args)
        @args = args             
      end          
      
      def usage
    <<-EOTXT
=== Command List:
sudo gem-fast patch apply,  apply patch to rubygems then you will use curl to download gems
sudo gem-fast patch revert, revert back to original


EOTXT
    	end
      
    end
    class InvalidCommand < RuntimeError; end
    class CommandFailed  < RuntimeError; end

    class << self
      
      include GemFast::UI
      def run(command, args, retries=0)
        begin         
          run_internal(command, args.dup)
        rescue InvalidCommand
          error "Unknown command. Run 'autoweb help' for usage information."
        rescue CommandFailed => e
          error e.message
        rescue Interrupt => e
          error "\n[canceled]"
        end
      end

      def run_internal(command, args)
        klass, method = parse(command)
        runner = klass.new(args)
        raise InvalidCommand unless runner.respond_to?(method)
        runner.send(method)
      end

      def parse(command)
        parts = command.split(':')
        case parts.size
          when 1
            begin
              return eval("GemFast::Command::#{command.capitalize}"), :index
            #rescue NameError, NoMethodError
            #  return Autoweb::Command::Help, command
            end
          when 2
            begin
              return GemFast::Command.const_get(parts[0].capitalize), parts[1]
            rescue NameError
              raise InvalidCommand
            end
          else
            raise InvalidCommand
        end
      end
    end
  end
end

Dir["#{File.dirname(__FILE__)}/../../commands/*.rb"].each { |c| 
	unless (/_helper\.rb$/=~c)
		require c 
	end
}