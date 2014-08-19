#Vipruby
Ruby Library for ViPR  

####Install and usage:
-gem install vipruby  
-require 'vipruby'  


####Example usage files:
-SBUX.rb  
-settings.conf  


####Create an vipr object:
    vipr = Vipruby.new([base_url]:[port],[user],[password])


####Methods:
-vipr.add_host  
-vipr.add_initiators  
-vipr.add_host_and_initators  
-vipr.host_exists?  
