require "gem-fast"

Gem.pre_install do
  curl_ok = false
  begin
    if `curl --version`.strip.size > 0
      curl_ok = true
    end
  rescue Exception => e
  end
  
  if !curl_ok
    raise Gem::InstallError, "You should install curl first! If you already install it , please add it to your $PATH\n OR you can run 'gem uninstall gem-fast' to return back."
  end
end

Gem::RemoteFetcher.instance_variable_set "@fetcher", GemFast::RemoteFetcher.new(Gem.configuration[:http_proxy])