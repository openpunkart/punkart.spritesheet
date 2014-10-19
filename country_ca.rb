# encoding: utf-8

CA_STATES_MAPPING = {
  'British Columbia' => 'bc',
  'Ontario'          => 'on',
  'ON'               => 'on',
  'Quebec'           => 'qc',
  'Alberta'          => 'ab',
  'Manitoba'         => 'mb',
  'New Brunswick'    => 'nb',
  'Nova Scotia'      => 'ns',
  'Saskatchewan'     => 'sk',
}


## map canadian states/provinces to file name

CA_STATES = {
  'bc' => '1--bc-british-columbia--pacific',
  'ab' => '2--ab-alberta--prairies',
  'mb' => '2--mb-manitoba--prairies',
  'sk' => '2--sk-saskatchewan--prairies',
  'on' => '3--on-ontario--central',
  'qc' => '4--qc-quebec--central',
  'nb' => '5--nb-new-brunswick--atlantic',
  'ns' => '5--ns-nova-scotia--atlantic',
  'pe' => '5--pe-prince-edward-island--atlantic',
  'nl' => '5--nl-newfoundland-n-labrador--atlantic',
  'yt' => '6--yt-yukon--northern',
  'nt' => '6--nt-northwest-territories--northern',
  'nu' => '6--nu-nunavut--northern',
  '?'  => '99--??--uncategorized',
}
