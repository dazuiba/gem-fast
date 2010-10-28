require 'rubygems'
require 'rubygems/user_interaction'
require "rubygems/remote_fetcher"
$:.unshift File.dirname(__FILE__)+"/../lib"

require 'gem-fast/utils'
require 'gem-fast/remote_fetcher'
module GemFast
  RUBYGEMPLUS_CACHE = File.join((File.writable?(Gem.dir) ? Gem.dir : Gem.user_dir), 'cache')
  RUBYGEMPLUS_USER_AGENT = "rubygem-gemfast"
 
end


