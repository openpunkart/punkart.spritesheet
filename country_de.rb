# encoding: utf-8

DE_STATES_MAPPING = {
 'Bayern' => 'by',
 'Bavaria' => 'by',
 'Baden-Wurttemberg' => 'bw',
 'Baden-Wrttemberg' => 'bw',
 'Baden-WÃ¼rttemberg' => 'bw',     ## check/fix encoding  - what encoding??
}

=begin
 [3] nordrhein-westfalen               ::   37 beers
 [4] hessen                            ::   10 beers
 [5] niedersachsen                     ::    8 beers
 [6] bremen                            ::    7 beers
 [7] brandenburg                       ::    4 beers
 [8] sachsen                           ::    4 beers
 [9] hamburg                           ::    3 beers
[10] th├â┬╝ringen                      ::    3 beers
[12] berlin                            ::    2 beers
[13] rheinland-pfalz                   ::    2 beers
[14] schleswig-holstein                ::    2 beers
[17] sachsen-anhalt                    ::    1 beers
=end

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
}

