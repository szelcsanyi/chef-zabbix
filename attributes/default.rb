# agent
default['zabbix']['server_addresses'] = []

# register_client
default['zabbix']['proxy_id'] = 0
default['zabbix']['url'] = 'https://example.com/api_jsonrpc.php'
default['zabbix']['user'] = 'api'
default['zabbix']['password'] = ''

# proxy
default['zabbix']['proxy']['server_address'] = '127.0.0.1'
default['zabbix']['proxy']['server_port'] = '10051'
default['zabbix']['proxy']['pollers'] = '10'
default['zabbix']['proxy']['dbsyncers'] = '4'
default['zabbix']['proxy']['cachesize'] = '16M'
default['zabbix']['proxy']['pingers'] = '2'
default['zabbix']['proxy']['historycachesize'] = '16M'
# in failover environment set this to false
default['zabbix']['proxy']['autostart'] = true
