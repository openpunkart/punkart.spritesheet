# encoding: utf-8

STATES_MAPPING_BY_COUNTRY = {
  'be' => BE_STATES_MAPPING,
  'de' => DE_STATES_MAPPING,
  'ca' => CA_STATES_MAPPING,
  'us' => US_STATES_MAPPING,
}

STATES_BY_COUNTRY = {
  'be' => BE_STATES,
  'de' => DE_STATES,
  'ca' => CA_STATES,
  'us' => US_STATES, 
}



COUNTRIES_MAPPING = {
  'United States' => 'us',
  'Canada'        => 'ca',
  'Mexico'        => 'mx',

  'Germany'  => 'de',
  'Belgium'  => 'be',
  'Czech Republic'  => 'cz',
  'Netherlands' => 'nl',
  'France'    => 'fr',
  'Austria'   => 'at',
  'Ireland'   => 'ie',
  'Switzerland' => 'ch',
  'Poland'      => 'pl',
  'Russia'      => 'ru',
  'Sweden'      => 'se',
  'Italy'       => 'it',
  'Denmark'     => 'dk',
  'Hungary'     => 'hu',
  'Lithuania' => 'lt',
  'Norway'    => 'no',
  'Finland'    => 'fi',
  'Greece'     => 'gr',
  'Spain'      => 'es',
  'Croatia'    =>  'hr',
  'Estonia'    =>  'ee',
  'Latvia'   => 'lv',
  'Macedonia, the Former Yugoslav Republic of' => 'mk',
  'Portugal'  => 'pt',
  'Serbia and Montenegro' => 'rs',
  'Slovakia' => 'sk',
  'United Kingdom'  => 'gb',   # check - what to use for united kingdom? exlude? use only member countries??
  'England'    => 'eng',
  'Scotland'   => 'sco',
  'Wales'      => 'wal',

  'Australia'  => 'au',
  'New Zealand' => 'nz',
  'French Polynesia' => 'pf',

  'Japan'       => 'jp',
  'India'       => 'in',
  'Korea, Republic of' => 'kr',
  'China'     => 'cn',
  'Thailand'   => 'th',
  'Viet Nam'   =>  'vn',
  'Macao'    => 'mo',
  'Myanmar'   => 'mm',
  'Philippines' => 'ph',
  'Sri Lanka' => 'lk',
  'Taiwan, Province of China' => 'tw',

  'Argentina' => 'ar',
  'Brazil'    => 'br',
  'Colombia'   =>  'co',

  'El Salvador' => 'sv',
  'Belize'     =>  'bz',
  'Guatemala' => 'gt',
  'Honduras'  => 'hn',
  'Panama'  => 'pa',

  'Cuba'       =>  'cu',
  'Aruba'      =>  'aw',
  'Jamaica'   => 'jm',
  'US Virgin Islands'  => 'vi',

  'Egypt'      =>  'eg',
  'Kenya'     => 'ke',
  'Mauritius' => 'mu',
  'Namibia'  => 'na',
  'Sierra Leone' => 'sl',
  'Togo' => 'tg',

  'Israel'    => 'il',
}


### map country name to file name
COUNTRIES = {
  'us' => 'us-united-states',
  'ca' => 'ca-canada',
  'de' => 'de-deutschland',
  'be' => 'be-belgium',

  'cz' => 'world/europe/cz-czech-republic',
  'nl' => 'world/europe/nl-netherlands',
  'fr' => 'world/europe/fr-france',
  'at' => 'world/europe/at-austria',
  'ie' => 'world/europe/ie-ireland',
  'ch' => 'world/europe/ch-confoederatio-helvetica',
  'pl' => 'world/europe/pl-poland',
  'ru' => 'world/europe/ru-russia',
  'se' => 'world/europe/se-sweden',
  'it' => 'world/europe/it-italy',
  'dk' => 'world/europe/dk-denmark',
  'hu' => 'world/europe/hu-hungary',
  'lt' => 'world/europe/lt-lithuania',
  'no' => 'world/europe/no-norway',
  'fi' => 'world/europe/fi-finland',
  'gr' => 'world/europe/gr-greece',
  'es' => 'world/europe/es-espana',
  'hr' => 'world/europe/hr-croatia',
  'ee' => 'world/europe/ee-estonia',
  'lv' => 'world/europe/lv-latvia',
  'mk' => 'world/europe/mk-macedonia',
  'pt' => 'world/europe/pt-portugal',
  'rs' => 'world/europe/rs-serbia',
  'sk' => 'world/europe/sk-slovakia',
##  '' => 'United Kingdom'  => 'gb',   # check - what to use for united kingdom? exlude? use only member countries??
  'eng' => 'world/europe/eng-england',
  'sco' => 'world/europe/sco-scotland',
  'wal' => 'world/europe/wal-wales',

  'au' => 'world/pacific/au-australia',
  'nz' => 'world/pacific/nz-new-zealand',
  'pf' => 'world/pacific/pf-tahiti',

  'jp' => 'world/asia/japan',  
  'in' => 'world/asia/in-india',
  'kr' => 'world/asia/kr-south-korea',
  'cn' => 'world/asia/cn-china',
  'th' => 'world/asia/th-thailand',
  'vn' => 'world/asia/vn-vietnam',
  'mo' => 'world/asia/mo-macao',
  'mm' => 'world/asia/mm-myanmar',
  'ph' => 'world/asia/ph-philippines',
  'lk' => 'world/asia/lk-sri-Lanka',
  'tw' => 'world/asia/tw-taiwan',

  'mx' => 'world/north-america/mx-mexico',

  'ar' => 'world/south-america/ar-argentina',
  'br' => 'world/south-america/br-brazil',
  'co' => 'world/south-america/co-colombia',

  'sv' => 'world/central-america/sv-el-salvador',
  'bz' => 'world/central-america/bz-belize',
  'gt' => 'world/central-america/gt-guatemala',
  'hn' => 'world/central-america/hn-honduras',
  'pa' => 'world/central-america/pa-panama',

  'aw' => 'world/caribbean/aw-aruba',
  'cu' => 'world/caribbean/cu-cuba',
  'jm' => 'world/caribbean/jm-jamaica',
  'vi' => 'world/caribbean/vi-us-virgin-islands',  # assume US Virgin Islands for now

  'eg' => 'world/africa/eg-egypt',
  'ke' => 'world/africa/ke-kenya',
  'mu' => 'world/africa/mu-mauritius',
  'na' => 'world/africa/na-namibia',
  'sl' => 'world/africa/sl-sierra-leone',
  'tg' => 'world/africa/tg-togo',

  'il' => 'world/middle-east/il-israel',
}

