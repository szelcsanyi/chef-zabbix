name             'L7-zabbix'
maintainer       'Gabor Szelcsanyi'
maintainer_email 'szelcsanyi.gabor@gmail.com'
license          'All rights reserved'
description      'Installs/Configures zabbix, automatic client registration'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '1.0.11'
source_url       'https://github.com/szelcsanyi/chef-zabbix'
issues_url       'https://github.com/szelcsanyi/chef-zabbix/issues'

supports 'ubuntu', '= 14.04'

depends 'L7-firewall'
