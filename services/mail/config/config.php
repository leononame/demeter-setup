<?php
$config['product_name'] = 'lho.io Webmail';
$config['identities_level'] = 1;

$front = getenv('FRONT_ADDRESS') ? getenv('FRONT_ADDRESS') : 'front';
$imap  = getenv('IMAP_ADDRESS')  ? getenv('IMAP_ADDRESS')  : 'imap';
// Mail servers
$config['default_host'] = $front;
$config['default_port'] = 10143;
$config['smtp_server'] = $front;
$config['smtp_port'] = 10025;
$config['smtp_user'] = '%u';
$config['smtp_pass'] = '%p';

// We access the IMAP and SMTP servers locally with internal names, SSL
// will obviously fail but this sounds better than allowing insecure login
// from the outter world
$ssl_no_check = array(
 'ssl' => array(
     'verify_peer' => false,
     'verify_peer_name' => false,
  ),
);
$config['imap_conn_options'] = $ssl_no_check;
$config['smtp_conn_options'] = $ssl_no_check;
$config['managesieve_conn_options'] = $ssl_no_check;


// Sieve script management
$config['managesieve_host'] = $imap;
$config['managesieve_usetls'] = false;

$config['des_key'] = getenv('SECRET_KEY');