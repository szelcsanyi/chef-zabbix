package 'zabbix-proxy-sqlite3' do
  action :install
end

package 'snmp-mibs-downloader' do
  action :install
end

Chef::Log.info("[Zabbix] Proxy autostart: #{node['zabbix']['proxy']['autostart']}")

service 'zabbix-proxy' do
  supports status: true, restart: true, reload: true
  if node['zabbix']['proxy']['autostart']
    action :enable
  else
    action :disable
  end
end

template '/etc/zabbix/zabbix_proxy.conf' do
  source 'etc/zabbix/zabbix_proxy.conf.erb'
  owner 'root'
  group 'root'
  mode '0644'
end
