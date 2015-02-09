[![Gem Version](https://badge.fury.io/rb/vipruby.svg)](http://badge.fury.io/rb/vipruby)  

###This repo has been moved to @emccode
###Link to new repo: https://github.com/emccode/Vipruby

# ViPRuby
### A Ruby library for EMCs ViPR
------

## How to use:

### Install and usage:
```ruby
gem install vipruby  
require 'vipruby'
```

### Create a ViPR object:
```ruby
base_url = 'vipr.mydomain.com'
user_name = 'root'
password = 'mypw'
verify_cert = false

vipr = Vipr.new(base_url,user_name,password,verify_cert)
   ```

### Methods Exist for:
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

## Licensing

Licensed under the Apache License, Version 2.0 (the “License”); you may not use this file except in compliance with the License. You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an “AS IS” BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License


## To Do:
* Add more methods for more controller specific actions.
* Add methods for blob specific actions
