# Copyright 2015, Gabor Szelcsanyi <szelcsanyi.gabor@gmail.com>

define :L7_zabbix_check, command: '', enabled: true do

  t = nil
  begin
    t = resources(template: '/etc/zabbix/mon.d/customcheck')
  rescue Chef::Exceptions::ResourceNotFound
    t = template '/etc/zabbix/mon.d/customcheck' do
      mode '0755'
      owner 'root'
      group 'root'
      source 'etc/zabbix/mon.d/customcheck.erb'
      cookbook 'L7-zabbix'
      variables(userparameters: [])
    end
  end

  t.variables[:userparameters] = t.variables[:userparameters].reject do
    |h| params[:name] == h[:name]
  end << {
    name: params[:name],
    command: params[:command],
    enabled: params[:enabled]
  }

end
