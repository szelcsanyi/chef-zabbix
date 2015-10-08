package 'zabbix-agent' do
  action :install
end

directory '/var/log/zabbix' do
  action :create
  owner 'zabbix'
  group 'zabbix'
  mode '0755'
end

template '/etc/zabbix/zabbix_agentd.conf' do
  source '/etc/zabbix/zabbix_agentd.conf.erb'
  variables(zabbix_server: node['zabbix']['server_addresses'])
  owner         'root'
  group         'root'
  mode          '0644'
  notifies :restart, 'service[zabbix-agent]'
end

remote_directory '/etc/zabbix/mon.d' do
  source 'mon.d'
  files_backup 0
  files_owner 'root'
  files_group 'root'
  files_mode '0755'
  owner 'root'
  group 'root'
  mode '0755'
end

service 'zabbix-agent' do
  provider Chef::Provider::Service::Init::Debian
  action [:enable, :start]
  supports [restart: true, reload: true, status: true]
  status_command '/etc/init.d/zabbix-agent status'
end

`mount`.split("\n").grep(/(ext|xfs)/).map { |x| x.split(' ')[2] }.each do |fs|
  file "#{fs}/.zabbix.fs.writable" do
    owner 'zabbix'
    group 'zabbix'
    mode '0644'
    action :create
  end
end

node['zabbix']['server_addresses'].each do |server|
  firewall_rule 'Allow zabbix check' do
    rule "-s #{server} --dport 10050"
    proto 'tcp'
    jump 'ACCEPT'
    chain 'WHITELIST'
  end
end
