Vipruby
=======

Ruby Library for ViPR


gem install vipruby

require 'vipruby'


example files:

SBUX.rb

settings.conf


vipr = Vipruby.new([base_url]:[port],[user],[password])


Methods:

vipr.add_host

vipr.add_initiators

vipr.add_host_and_initators

vipr.host_exists?
