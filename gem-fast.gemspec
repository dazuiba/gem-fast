$LOAD_PATH.unshift 'lib'
require "gem-fast/version" 
Gem::Specification.new do |s|
  s.name = %q{gem-fast}
  s.version = GemFast::VERSION
  s.has_rdoc = true
  s.required_ruby_version = ">= 1.8.7"
  s.platform = "ruby"
  s.required_rubygems_version = ">= 0"
  s.author = "dazuiba"
  s.email = %q{come2u@gmail.com}
  s.summary = %q{Gem for the rest}
  s.homepage = %q{http://github.com/dazuiba/gem-fast.git}
  s.description = %q{Gem-fast, make your gem install faster!, Replace gem fetcher with curl }
  s.executables = %w(gem-fast)
  
  s.files = %w( README.md )
  s.files += Dir.glob("lib/**/*")
  s.files += Dir.glob("commands/**/*")
  s.files += Dir.glob("bin/*")
end
