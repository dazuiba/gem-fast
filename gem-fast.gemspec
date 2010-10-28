$LOAD_PATH.unshift 'lib'
require "gem-fast/version" 
Gem::Specification.new do |s|
  s.name = %q{gem-fast}
  s.version = GemFast::VERSION
  s.has_rdoc = true
  s.required_ruby_version = ">= 1.8.6"
  s.platform = "ruby"
  s.required_rubygems_version = ">= 0"
  s.author = "dazuiba"
  s.email = %q{come2u@gmail.com}
  s.summary = %q{Gem for the rest}
  s.homepage = %q{http://github.com/dazuiba/gem-fast.git}
  s.description = %q{Gem-fast, make your gem install faster!, Replace gem fetcher with curl }
  s.post_install_message = <<MESSAGE

  ========================================================================

    Thanks for installing Gem-Fast!
    Gem-Fast will use curl to make your gem install faster!
    
    Try it now use:  gem install rails    

  ========================================================================

MESSAGE
  s.files = %w( README.md )
  s.files += Dir.glob("lib/**/*")
end
