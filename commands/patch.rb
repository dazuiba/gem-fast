require 'rubygems'
require 'gem-fast/patcher'
module GemFast::Command
  class Patch < Base
    def index
      GemFast::Patcher.new.patch
    end
    
  end
end