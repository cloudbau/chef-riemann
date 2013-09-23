name              "riemann-server"
maintainer        "cloudbau GmbH"
maintainer_email  "h.volkmer@cloudbau.de"
license           "Apache v2.0"
description       "Installs a Riemann server with optional dashboard"
version           "1.1.0"

supports "Centos", ">= 6.4"
supports "Ubuntu"

depends "runit"
depends "java"
depends "rbenv", ">= 1.4.2" #riotgames

recipe "riemann-server::default", "Installs a Riemann server including the dashboard"
recipe "riemann-server::server", "Installs the Riemann server only"
recipe "riemann-server::dashboard", "Installs the Riemann dashboard only"

attribute 'riemann/server/version',
  :display_name => 'Riemann server version',
  :type => 'string',
  :default => '0.2.2',
  :recipes => [ 'riemann-server::server' ]

attribute 'riemann/ruby_version',
  :display_name => 'Ruby version for Riemann dashboard',
  :type => 'string',
  :default => '1.9.3-p286',
  :recipes => [ 'riemann-server::dash' ]
