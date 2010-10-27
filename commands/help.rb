module GemFast::Command
  class Help < Base  
    def index
      display usage
    end 
  end
end