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


def split_csv( in_path, out_root, headers )
  puts "## splitting >>#{in_path}<< to >>#{out_root}<<..."

  ## try a dry test run
  i = 0
  CSV.foreach( in_path, headers: true ) do |row|
    i += 1
    puts row.inspect   if i == 1   ## for debugging print first row

    print '.' if i % 100 == 0
  end
  puts " #{i} rows"


  ### make sure out_root path exists
  FileUtils.mkdir_p( out_root )   unless Dir.exists?( out_root )


  i = 0
  CSV.foreach( in_path, headers: true ) do |row|
    i += 1
    print '.' if i % 100 == 0

    country  = row[0].strip    ### note: remove possible leading n trailing spaces
    country_slug = COUNTRIES[ country ]

    recs     = []      # reset recs; for new country

    puts "### country: #{country} (#{country_slug})"

    j = 0
    row.each do |k,v|
      j += 1
      next if j == 1   ## skip first column, that is, country
    
      puts "  #{k} => #{v}"

      ## cleanup key
      ## - assume it's a year w/ some extras only use year

      m = /^\s*(\d{4})\b/.match( k )
      if m
        year = m[1].to_i
        ### note: strip value (e.g. remove leading and trailing spaces)
        recs << [year,v.strip]
      else
        puts "*** !!! wrong year colum format >>#{k}<<; exit, sorry"
        exit 1
      end

    end

    ### (re)sort recs - lets latest years always go first (e.g. 2011,2010,2009,etc.)
    recs.sort! { |l,r| r[0] <=> l[0] }

    out_path = "#{out_root}/#{country_slug}.csv"

    File.open( out_path, 'w' ) do |out|
      out.puts headers.join(',') # headers line
      ## all recs
      recs.each do |rec|
        out.puts rec.join(',')
      end
    end
  end

  puts 'done'
end

