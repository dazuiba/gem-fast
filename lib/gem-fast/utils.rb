module GemFast
  module Util
    include Gem::UserInteraction
    def detect_download_strategy url
      CurlDownloadStrategy
    end


    def curl *args
      safe_system 'curl', '-f#LA', RUBYGEMPLUS_USER_AGENT, *args unless args.empty?
    end

    def safe_system cmd, *args
      raise ExecutionError.new(cmd, args, $?)  unless system(cmd, *args)
    end

    def system cmd, *args
      #puts "#{cmd} #{args*' '}"
      fork do
        yield if block_given?
        args.collect!{|arg| arg.to_s}
        exec(cmd, *args) rescue nil
        exit! 1 # never gets here unless exec failed
      end
      Process.wait
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