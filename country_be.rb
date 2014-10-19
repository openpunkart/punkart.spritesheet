# encoding: utf-8

BE_STATES_MAPPING = {
  'West-Vlaanderen' => 'vwv',
  'Hainaut'         => 'wht',
  'Vlaams Brabant'  => 'vbr',
  'Oost-Vlaanderen' => 'vov',
  'Antwerpen'       => 'van',
  'Antwerp'         => 'van',
  'Namur'           => 'wna',
  'Luxembourg'      => 'wlx',
  'Lige'            => 'wlg',
  'Limburg'         => 'vli',
  'Brabant Wallon'  => 'wbr',
  'Brabant'         => 'wbr',
  'Brussel'         => 'bru'
}

## map belgium states/regions to file name

BE_STATES = {
  'bru' => '1--bru-bruxelles--capital',
  'van' => '2--van-antwerpen--flanders',
  'vbr' => '2--vbr-vlaams-brabant--flanders',
  'vli' => '2--vli-limburg--flanders',
  'vov' => '2--vov-oost-vlaanderen--flanders',
  'vwv' => '2--vwv-west-vlaanderen--flanders',
  'wbr' => '3--wbr-brabant-wallon--wallonia',
  'wht' => '3--wht-hainaut--wallonia',
  'wlg' => '3--wlg-liege--wallonia',
  'wlx' => '3--wlx-luxembourg--wallonia',
  'wna' => '3--wna-namur--wallonia',
  '?'   => '99--??--uncategorized',
}

