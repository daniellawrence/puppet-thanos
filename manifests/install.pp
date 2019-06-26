# thanos::install
#
# Install's Thanos
#
# @summary A short summary of the purpose of this class
#
# @example
#   include thanos::install
class thanos::install (
  String $version = '0.5.0',
) {

  $source_url = "https://github.com/improbable-eng/thanos/releases/download/v${version}/thanos-${version}.linux-amd64.tar.gz"

  file { [
    '/usr/local/thanos/',
    "/usr/local/thanos/${version}"
  ]:
    ensure => 'directory',
    mode   => '0755',
  }

  archive { "/usr/src/thanos-${version}.linux-amd64.tar.gz":
    ensure       => present,
    extract      => true,
    extract_path => "/usr/local/thanos/${version}",
    source       => $source_url,
    creates      => "/usr/local/thanos/${version}/thanos-${version}.linux-amd64/thanos",
    cleanup      => false,
  }

  file { '/usr/bin/thanos':
    ensure => link,
    target => "/usr/local/thanos/${version}/thanos-${version}.linux-amd64/thanos",
  }


}
