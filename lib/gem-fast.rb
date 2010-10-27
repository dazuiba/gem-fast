require 'rubygems'
require 'rubygems/user_interaction'
require 'gem-fast/utils'
require "rubygems/remote_fetcher"
require 'gem-fast/download_strategy'
module GemFast
  RUBYGEMPLUS_CACHE = File.join((File.writable?(Gem.dir) ? Gem.dir : Gem.user_dir), 'cache')
  RUBYGEMPLUS_USER_AGENT = "rubygem-gemfast"
  Gem::RemoteFetcher.instance_variable_set "@fetcher", GemFastRemoteFetcher.new(Gem.configuration[:http_proxy])
end
