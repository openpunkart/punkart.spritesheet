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


def reverse_csv( in_path, out_path )
  puts "## reversing >>#{in_path}<< to >>#{out_path}<<..."

  ## try a dry test run
  i = 0
  CSV.foreach( in_path, headers: true ) do |row|
    i += 1
    puts row.inspect   if i == 1   ## for debugging print first row

    print '.' if i % 100 == 0
  end
  puts " #{i} rows"


  ### make sure out_root path exists
  FileUtils.mkdir_p( File.dirname( out_path ))   unless Dir.exists?( File.dirname( out_path ))

  ### load all-at-once for now
  table = CSV.read( in_path, headers: true )
  

  headers =  [table.headers[0]] +            ## keep first column in place
              table.headers[1..-1].reverse   ## reverse headers (but the first entry)
  pp headers

  recs = []

  table.each do |row|
    j    = 0
    head = nil
    tail = []

    row.each do |k,v|
      j += 1
      if j == 1   ## first column
        head = v    ## add first value to head
      else
        tail << v   ## add value to tail (remaining values)
      end
    end
    recs << [head]+tail.reverse
  end


  File.open( out_path, 'w' ) do |out|
    out.puts headers.join(',') # headers line
    ## all recs
    recs.each do |rec|
       out.puts rec.join(',')
    end
  end
end  # method reverse_csv
