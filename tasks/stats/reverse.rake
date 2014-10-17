# encoding: utf-8


task :reverse do |t|
  ### split <xxx>_stats.csv into folder w/ one file per row (country)

  in_root = '../statistics'
  out_root = './o/statistics'

  datasets = [
    'breweries',
    'consumption',
    'consumption_per_capita',
    'imports',
    'exports',
    'production',
  ]

  datasets.each do |dataset|
     name    = dataset

     in_path   = "#{in_root}/#{name}.csv"
     out_path  = "#{out_root}/#{name}.csv"

     reverse_csv( in_path, out_path )
  end
end
