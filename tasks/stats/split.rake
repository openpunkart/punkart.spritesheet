# encoding: utf-8



task :split do |t|
  ### split <xxx>_stats.csv into folder w/ one file per row (country)

  in_root = '../statistics'
  out_root = './o/statistics'

  datasets = [
    [ 'breweries', [ 'Year', 'Total' ]],   # new header names
    [ 'consumption', [ 'Year', 'Total (000 hl)' ]],
    [ 'consumption_per_capita', [ 'Year', 'Total (l)' ]],
    [ 'imports', [ 'Year', 'Total (000 hl)']],
    [ 'exports', [ 'Year', 'Total (000 hl)']],
    [ 'production',  [ 'Year', 'Total (000 hl)']],
  ]

  datasets.each do |dataset|
     name    = dataset[0]
     headers = dataset[1]
     
     in_path   = "#{in_root}/#{name}.csv"
     out_path  = "#{out_root}/#{name}"    # note: its a folder/directory

     split_csv( in_path, out_path, headers )
  end
end
