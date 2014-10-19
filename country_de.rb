# encoding: utf-8

DE_STATES_MAPPING = {
  'Bayern' => 'by',
  'Bavaria' => 'by',
  'Baden-Wurttemberg' => 'bw',
  'Baden-Wrttemberg' => 'bw',
  'Baden-WÃ¼rttemberg' => 'bw',     ## check/fix encoding  - what encoding??
  'Nordrhein-Westfalen' => 'nw',
  'Hessen' => 'he',
  'Niedersachsen' => 'ni',
  'Bremen' => 'hb',
  'Brandenburg' => 'bb',
  'Sachsen' => 'sn',
  'Hamburg' => 'hh',
  'ThÃ¼ringen' => 'th',   ## check/fix encoding  - what encoding??
  'Berlin' => 'be',
  'Rheinland-Pfalz' => 'rp',
  'Schleswig-Holstein' => 'sh',
  'Sachsen-Anhalt' => 'st',
}


## map german states to file name

DE_STATES = {
 'bb' => '1--bb-brandenburg--berlin',
 'be' => '1--be-berlin',
 'sn' => '2--sn-sachsen--saxony',
 'by' => '3--by-bayern',
 'bw' => '4--bw-baden-wuerttemberg--black-forest',
 'rp' => '5--rp-rheinland-pfalz--southern-rhineland',
 'sl' => '5--sl-saarland--southern-rhineland',
 'nw' => '6--nw-nordrhein-westfalen--northern-rhineland',
 'he' => '7--he-hessen--central',
 'st' => '7--st-sachsen-anhalt--central',
 'th' => '7--th-thueringen--central',
 'hb' => '8--hb-bremen--lower-saxony',
 'ni' => '8--ni-niedersachsen--lower-saxony',
 'hh' => '9--hh-hamburg--north',
 'mv' => '9--mv-mecklenburg-vorpommern--north',
 'sh' => '9--sh-schleswig-holstein--north',
  '?'  => '99--??--uncategorized',

}

