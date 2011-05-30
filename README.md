# Welcome!

Gem-fast, let your gem installation swing!
see this blog: [为 gem install 按上翅膀 -- gem-fast](http://www.cnblogs.com/dazuiba/archive/2010/10/28/1863904.html)

![Screen cast](http://images.cnblogs.com/cnblogs_com/dazuiba//gem-fast-1.jpg "gem-fast")


# Changelog

0.0.6.3

Expire local cache for latest_specs.4.8.gz when it 's too old(7 days download once)


# Known Issue:

1. When user cancel an installation, local cache is hafe-downloaded, this will break the next installation
2. check curl installation before install gem-fast.gem, gave user some hit to install curl , especially windows users