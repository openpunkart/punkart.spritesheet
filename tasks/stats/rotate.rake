# encoding: utf-8


task :rotate do |t|

  in_root = '../statistics'
  out_root = './o/statistics'

  datasets = [
    [ 'breweries_de_deutschland_fixme', 'Name' ],   ## change Year to Name
  ]

  datasets.each do |dataset|
     name       = dataset[0]
     header1st  = dataset[1]   ## first header

     in_path   = "#{in_root}/#{name}.csv"
     out_path  = "#{out_root}/#{name}.csv"

     rotate_csv( in_path, out_path, header1st )
  end
end
