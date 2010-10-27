require 'rubygems'
require 'gem-fast/patcher'
module GemFast::Command
  class Revert < Base
    def index
      GemFast::Patcher.new.revert
    end
    
  end
end