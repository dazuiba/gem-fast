== Welcome!
Gem-fast, let your gem installation swing!

see this blog: http://www.cnblogs.com/dazuiba/archive/2010/10/28/1863904.html


== Known Issue:
1. Sometimes We need to expire local cache, i.e: latest_specs.4.8.gz
2. When user cacel an installation, local cache is hafe-downloaded, this will break the next installtion
3 check curl installtion before install gem-fast.gem 
   I need add a pre_install_book to Gem, but Rubygems have an bug here
   see: http://help.rubygems.org/discussions/problems/378-gempre_install-does-not-working-as-it-named

== TODO:
* Refactor the Caching strategy
	1. change cache folder from gem/cache to somewhere else(so that we do not need sudo as least )  
  2. support mtime cacheing
