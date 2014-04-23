# == Class: nsclient::service
#
# Class to manage the nsclient service

class nsclient::service(
  $service_state   = $nsclient::service_state,
  $service_enable  = $nsclient::service_enable,
  $allowed_hosts   = $nsclient::allowed_hosts,
  $config_template = $nsclient::config_template,
  $ext_script      = $nsclient::ext_script
) {

  case downcase($::osfamily) {
    'windows': {
      # $ext_script and $allowed_hosts may be used in this file
      file { 'C:\Program Files\NSClient++\nsclient.ini':
        ensure  => file,
        owner   => 'SYSTEM',
        mode    => '0664',
        content => template($config_template),
        notify  => Service['nscp']
      }

      service { 'nscp':
        ensure  => $service_state,
        enable  => $service_enable,
        require => File['C:\Program Files\NSClient++\nsclient.ini'],
      }
    }
    default: {
      fail('This module only works on Windows based systems.')
    }
  }
}
