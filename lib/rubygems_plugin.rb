require "gem-fast"

# see http://help.rubygems.org/discussions/problems/378-gempre_install-does-not-working-as-it-named
# Gem.pre_install do
#   if !GemFast.curl?
#     raise Gem::InstallError, "You should install curl first! If you already install it , please add it to your $PATH\n\t OR you can run 'gem uninstall gem-fast' to return back."
#   end
# end

Gem::RemoteFetcher.instance_variable_set "@fetcher", GemFast::RemoteFetcher.new(Gem.configuration[:http_proxy])