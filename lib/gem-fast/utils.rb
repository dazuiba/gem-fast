module GemFast
  module Util
    include Gem::UserInteraction

    def curl *args
      begin
        safe_system 'curl', '-f#LA', RUBYGEMPLUS_USER_AGENT, *args unless args.empty?
      rescue ExecutionError => e
        if GemFast.curl?
          raise e
        else
          not_install_curl
        end
      rescue Errno::ENOENT => e  
        not_install_curl
      end
      
    end
    
    def not_install_curl
      alert_error("use: 'gem uninstall gem-fast' to return back, Curl not installed on your mathine!")
      exit(1)
    end
    
    def safe_system cmd, *args
      raise ExecutionError.new(cmd, args, $?)  unless system(cmd, *args)
    end

    def system cmd, *args
      yield if block_given?
      args.collect!{|arg| arg.to_s}
      `#{cmd} #{args.join(" ")}`
      $?.success?
    end


    class ExecutionError <RuntimeError
      attr :exit_status
      attr :command

      def initialize cmd, args = [], es = nil
        @command = cmd
        super "Failure while executing: #{cmd} #{pretty(args)*' '}"
        @exit_status = es.exitstatus rescue 1
      end

      def was_running_configure?
        @command == './configure'
      end

      private

      def pretty args
        args.collect do |arg|
          if arg.to_s.include? ' '
            "'#{ arg.gsub "'", "\\'" }'"
          else
            arg
          end
        end
      end
    end

    class BuildError <ExecutionError
      attr :env

      def initialize cmd, args = [], es = nil
        super
        @env = ENV.to_hash
      end
    end
  end
end