gem_file = 'zabbixapi-2.4.2.gem'
dest_gem_file = "#{Chef::Config['file_cache_path']}/#{gem_file}"
c = cookbook_file dest_gem_file do
  source "gems/#{gem_file}"
  action :nothing
end
c.run_action(:create_if_missing)

r = gem_package 'zabbixapi' do
  action :nothing
  version '2.4.2'
  source dest_gem_file
  if ::File.exist?('/opt/chef/embedded/bin/gem')
    gem_binary '/opt/chef/embedded/bin/gem'
  end
end

r.run_action(:install)
Gem.clear_paths

if Gem::Specification.find_all_by_name('zabbixapi').empty?
  Chef::Log.info('Zabbixapi gem is not available!')
else
  require 'zabbixapi'

  begin
    zbx = ZabbixApi.connect(
      url: node['zabbix']['url'],
      user: node['zabbix']['user'],
      password: node['zabbix']['password'],
      debug: false
    )
  rescue => e
    Chef::Log.info("[Zabbix] Cannot connect to Zabbix api! (#{e.message})")
    return
  end

  # version = zbx.query(
  #  :method => "apiinfo.version",
  #  :params => {}
  # )
  # Chef::Log.info("[Zabbix] Api version: #{version}")

  begin
    zbxnodeid = zbx.hosts.get_id(host: node['fqdn'])
    if zbxnodeid.nil?
      Chef::Log.info("[Zabbix] Host #{node.fqdn} is not registered in Zabbix. Registering...")

      if node['public_ipaddress'].empty?
        interfaces = [{ type: 1, main: 1, ip: node['ipaddress'], dns: node['fqdn'], port: 10_050, useip: 1 }]
      else
        interfaces = [{ type: 1, main: 1, ip: node['public_ipaddress'], dns: node['fqdn'], port: 10_050, useip: 1 }]
      end
      interfaces << { type: 1, main: 0, ip: node['public_ip6address'], dns: node['fqdn'], port: 10_050, useip: 1 } unless node['public_ip6address'].empty?
      zbxnodeid = zbx.query(
        method: 'host.create',
        params: {
          available: 1,
          groups: [
            { groupid: zbx.hostgroups.get_or_create(name: node['location']['org']) },
            { groupid: zbx.hostgroups.get_or_create(name: "#{node['location']['org']}/#{node['location']['group']}") }
          ],
          host: node['fqdn'],
          templates: [{ templateid: zbx.templates.get_id(host: 'Linux') }],
          interfaces: interfaces,
          proxy_hostid: node['zabbix']['proxy_id']
        }
      )['hostids'][0].to_i

      if zbxnodeid.nil?
        Chef::Log.info('[Zabbix] Failed to register!')
      else
        Chef::Log.info("[Zabbix] Registered with id: #{zbxnodeid}")
      end
    else
      Chef::Log.info("[Zabbix] Host #{node.fqdn} is already registered (#{zbxnodeid})!")
    end

    tmpls = zbx.templates.get_ids_by_host(hostids: [zbxnodeid])
    Chef::Log.info('[Zabbix] Host has templates: ' + tmpls.join(', '))

    roletmpls = []
    node['roles'].each do |role|
      Chef::Log.info("[Zabbix] Checking for associated: #{role}")
      roleid = zbx.templates.get_id(host: role)
      if roleid.nil?
        Chef::Log.info("[Zabbix] #{role} not found!")
      else
        roletmpls.push(roleid.to_s)
        Chef::Log.info("[Zabbix] #{role} found! (#{roleid})")
      end
    end

    Chef::Log.info('[Zabbix] Host has associated roles: ' + roletmpls.join(', '))
    neededtmpls = roletmpls - tmpls

    unless (neededtmpls).empty?
      Chef::Log.info('[Zabbix] Adding templates to host: ' + neededtmpls.join(', '))
      zbx.templates.mass_add(
        hosts_id: [zbxnodeid],
        templates_id: neededtmpls
      )
    end
  rescue => e
    Chef::Log.info("[Zabbix] Zabbix api request failed! #{e}")
    return
  end
end
