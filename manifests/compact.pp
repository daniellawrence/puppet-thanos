# thanos::compact
#
# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# @example
#   include thanos::compact
class thanos::compact(
  String  $log_level                               = 'info',
  Optional[String]  $gcloudtrace_project           = undef,
  Integer $gcloudtrace_sample_factor               = 0,
  Integer $http_port                               = 13902,
  String  $http_address                            = "0.0.0.0:${http_port}",
  String  $data_dir                                = '/var/data/thanos-compact',
  Optional[String]  $gcs_bucket                    = undef,
  Optional[String]  $s3_bucket                     = undef,
  Optional[String]  $s3_endpoint                   = undef,
  Optional[String]  $s3_access_key                 = undef,
  Optional[String]  $s3_secret_key                 = undef,
  Optional[Boolean]  $s3_insecure                   = false,
  Optional[Boolean]  $s3_signature_version2         = false,
  Optional[Boolean]  $s3_encrypt_sse                = false,
  String  $sync_delay                              = '30m',
  Boolean $wait                                    = true,
  Optional[String]  $compact_objstore_config_file  = '/etc/thanos/compact_bucket.yaml',
  Optional[Boolean] $disable_downsample            = false,
) {
  include systemd
  include thanos
  include thanos::install

  file { $data_dir:
      ensure => directory,
      owner  => $thanos::user,
      group  => $thanos::group,
      mode   => '0664',
    }

  if $compact_objstore_config_file {
    file { $compact_objstore_config_file:
      ensure  => present,
      group   => $thanos::group,
      mode    => '0750',
      owner   => $thanos::user,
      content => template('thanos/bucket.yaml.erb'),
    }
  }

  systemd::unit_file { 'thanos-compact.service':
  content => template('thanos/thanos-compact.service.erb'),

  } ~> service {'thanos-compact':
  ensure => 'running',
  enable => true,
}




}
