# Description

This cookbook is used to install the Riemann server and/or the dashboard as [runit](http://smarden.org/runit/) services.

It supports RPM- and DEB-based installation and makes use of the packages provided on [`riemann.io`](http://riemann.io).

# Requirements

## Platform:

* Centos (>= 6.4)
* Ubuntu

## Cookbooks:

* runit
* java
* rbenv (1.4.2)

# Attributes

* `node['riemann']['server']['version']` - . Defaults to `0.2.2`.
* `node['riemann']['ruby_version']` - . Defaults to `1.9.3-p286`.

# Recipes

* riemann-server::default - Installs the Riemann server only
* riemann-server::server - Installs the Riemann server only
* riemann-server::dashboard - Installs the Riemann dashboard only

# License and Maintainer

Maintainer:: cloudbau GmbH (<h.volkmer@cloudbau.de>)

License:: Apache v2.0
