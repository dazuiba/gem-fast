# Welcome!

Gem-fast, let your gem installation swing!
see this blog: [为 gem install 按上翅膀 -- gem-fast](http://www.cnblogs.com/dazuiba/archive/2010/10/28/1863904.html)

![Screen cast](http://images.cnblogs.com/cnblogs_com/dazuiba//gem-fast-1.jpg "gem-fast")


# Known Issue:

1. Sometimes We need to expire local cache, i.e: latest_specs.4.8.gz
2. When user cancel an installation, local cache is hafe-downloaded, this will break the next installation
3. check curl installation before install gem-fast.gem \
   I need add a pre_install_book to Gem, but Rubygems have an bug here\
   see: http://help.rubygems.org/discussions/problems/378-gempre_install-does-not-working-as-it-named

# TODO:

* Reacting the Caching strategy

	1. change cache folder from gem/cache to somewhere else(so that we do not need sudo as least )  
	2. support mtime cacheing
