# encoding: utf-8



def cut_csv( in_path, out_path, cols )
  puts "## cutting >>#{in_path}<< to >>#{out_path}<<..."

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

  ## 1) get headers
  headers = []
  cols.each do |col|
    headers << table.headers[col]
  end

  ## 2) get records (recs)
  recs = []
  i = 0
  table.each do |row|
    print '.' if i % 100

    rec = []
    cols.each do |col|
      rec << row[col]
    end
    recs << rec
  end

  pp headers

  ## NOTE: do NOT forget to escape commas !!! in cols/recs
  ##  use CSV to handle heavy lifting

  CSV.open( out_path, 'w' ) do |csv|
    csv << headers # headers line
    ## all recs
    recs.each do |rec|
      csv << rec
    end
  end

  # File.open( out_path, 'w' ) do |out|
  #  out.puts headers.join(',') # headers line
  #  ## all recs
  #  recs.each do |rec|
  #     out.puts rec.join(',')
  #  end
  #end
end  # method cut_csv


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





