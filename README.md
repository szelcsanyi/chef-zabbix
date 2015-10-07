# L7-zabbix cookbook
[![Build Status](https://travis-ci.org/szelcsanyi/chef-zabbix.svg?branch=master)](https://travis-ci.org/szelcsanyi/chef-zabbix)
[![security](https://hakiri.io/github/szelcsanyi/chef-zabbix/master.svg)](https://hakiri.io/github/szelcsanyi/chef-sysfs/master)
[![Cookbook Version](https://img.shields.io/cookbook/v/L7-zabbix.svg?style=flat)](https://supermarket.chef.io/cookbooks/L7-zabbix)

## Description

Configures [zabbix](http://zabbix.com) agent and proxy via Opscode Chef

## Supported Platforms

* Ubuntu 14.04+

## Recipes

* `L7-zabbix` - The default no-op recipe.
* `L7-zabbix::agent` - Set up zabbix-agent
* `L7-zabbix::proxy` - Set up zabbix-proxy
* `L7-zabbix::register_client` - Registers client to zabbix szerver via api


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License

* Freely distributable and licensed under the [MIT license](http://szelcsanyi.mit-license.org/2015/license.html).
* Copyright (c) 2015 Gabor Szelcsanyi

[![image](https://ga-beacon.appspot.com/UA-56493884-1/chef-zabbix/README.md)](https://github.com/szelcsanyi/chef-zabbix)

