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


def rotate_csv( in_path, out_path, header1st )
  puts "## rotating >>#{in_path}<< to >>#{out_path}<<..."

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
  
  headers =  [header1st]
  recs = []

  ## cut of first header (gets dropped/changed)
  table.headers[1..-1].each do |header|
    recs << [header]   ## header is first value in record
  end

  table.each do |row|
    j = 0
    row.each do |k,v|
      j += 1
      if j == 1   ## first column
        headers << v    ## add first value to headers
      else          ## all others
        ## add value to new record
        # note: zero-based, thus -1 and -1 for skiping header line
        recs[j-2] << v
      end
    end
  end

  pp headers

  File.open( out_path, 'w' ) do |out|
    out.puts headers.join(',') # headers line
    ## all recs
    recs.each do |rec|
       out.puts rec.join(',')
    end
  end
end  # method rotate_csv
