# L7-zabbix cookbook
[![Build Status](https://travis-ci.org/szelcsanyi/chef-zabbix.svg?branch=master)](https://travis-ci.org/szelcsanyi/chef-zabbix)
[![security](https://hakiri.io/github/szelcsanyi/chef-zabbix/master.svg)](https://hakiri.io/github/szelcsanyi/chef-zabbix/master)
[![Cookbook Version](https://img.shields.io/cookbook/v/L7-zabbix.svg?style=flat)](https://supermarket.chef.io/cookbooks/L7-zabbix)

## Description

Configures [zabbix](http://zabbix.com) agent and proxy via Opscode Chef

## Supported Platforms

* Ubuntu 14.04
* Debian 7

## Recipes

* `L7-zabbix` - The default no-op recipe.
* `L7-zabbix::agent` - Set up zabbix-agent
* `L7-zabbix::proxy` - Set up zabbix-proxy
* `L7-zabbix::register_client` - Registers client to zabbix server using zabbix api

## Definations

* `L7_zabbix_check` - Custom zabbix check with UserParameter

* name: The key name for the zabbix item.
* command: cli command to run.
* enabled: true/false value (default: true)

```ruby
L7_zabbix_check 'app.hits' do
	command '/usr/bin/redis-cli --raw -p 6381 -h 127.0.0.1 llen hits'
	enabled false
end
```

Then you can add an item in zabbix with key: `customcheck[app.hits]`

## Attributes
* for agent:
* `default['zabbix']['server_addresses']` - array if of ips where the agent accepts connection from

* for register_client
* `default['zabbix']['proxy_id']` - id of the zabbix proxy (default: 0)
* `default['zabbix']['url']` - zabbix api url (default: https://example.com/api_jsonrpc.php)
* `default['zabbix']['user']` - zabbix api username (default: api)
* `default['zabbix']['password']` - zabbix api password

* for proxy:
* `default['zabbix']['proxy']['server_address']` - where to send data by proxy (default: '127.0.0.1')
* `default['zabbix']['proxy']['server_port']` - zabbix server port (default: 10051)
* `default['zabbix']['proxy']['pollers']` - zabbix proxy pollers (default: 10)
* `default['zabbix']['proxy']['dbsyncers']` - zabbix proxy db syncers (default: 4)
* `default['zabbix']['proxy']['cachesize']` - zabbix proxy cache (default: 16M)
* `default['zabbix']['proxy']['pingers']` - zabbix proxy pingers (default: '2')
* `default['zabbix']['proxy']['historycachesize']` - zabix proxy history cache (default: 16M)
* `default['zabbix']['proxy']['autostart']` - should zabbix proxy start at boot? (default: true)

## Automatic client registartion to Zabbix server

The register_client recipe tries to register a new host using zabbix api. If a proxy id is set then the host will be created with an additional proxy settings to be checked via that proxy.
A 'Linux' template will be automatically assigned to the new host. Additional templates can be added. If a host has a chef role like 'web' and a zabbix template called 'web' also exists then it will be assigned to the host too.
It helps to monitor all the things if an applicaion is scaled out to new machines. No new machines will be left unmonitored and abandoned!

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

