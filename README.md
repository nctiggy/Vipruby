[![Gem Version](https://badge.fury.io/rb/vipruby.svg)](http://badge.fury.io/rb/vipruby)  

###This repo has been moved to @emccode
###Link to new repo: https://github.com/emccode/Vipruby

# ViPRuby
### A Ruby library for EMCs ViPR
------

## How to use:

#### Install and usage:
```ruby
gem install vipruby  
require 'vipruby'
```

#### Create a ViPR object:
```ruby
base_url = 'vipr.mydomain.com'
user_name = 'root'
password = 'mypw'
verify_cert = false

vipr = Vipr.new(base_url,user_name,password,verify_cert)
   ```

#### Methods Exist for:
1. vCenter
   * Add vCenters (to root or specific tenant)
   * Remove vCenters
   * Get vCenter Information
2. Hosts
   * Add Hosts
   * Add Host Initators
   * Remove Hosts
   * Get Host Information
3. Storage Systems
   * Add Storage Arrays

For all methods, see the [Gem Documentation for all code samples](http://rubygems.org/gems/vipruby)

####To Do:
* Add more methods for more controller specific actions.
* Add methods for blob specific actions
