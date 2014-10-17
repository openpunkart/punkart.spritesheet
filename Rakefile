# encoding: utf-8


require 'csv'
require 'pp'
require 'fileutils'


##############
# our own code

require './countries'
require './country_us'
require './country_be'


require './scripts/countries'

require './scripts/breweries'
require './scripts/beers'
require './scripts/list'



############################################
# add more tasks (keep build script modular)

Dir.glob('./tasks/**/*.rake').each do |r|
  puts " importing task >#{r}<..."
  import r
  # see blog.smartlogicsolutions.com/2009/05/26/including-external-rake-files-in-your-projects-rakefile-keep-your-rake-tasks-organized/
end


task :repairb do |t|

  ## clean/repair beers.csv

  in_path  = "./dl/beers.csv"
  out_path = "./o/beers.csv"

  ## columns
  ##  "id","brewery_id","name",
  #     "cat_id","style_id",
  #     "abv","ibu","srm","upc",
  #     "filepath","descript","last_mod"

  i = 0 
  File.open( out_path, 'w') do |out|
    File.open( in_path, 'r' ).each_line do |line|
      i += 1
      if i % 100
        print '.'
      end

      if line =~ /^"id",/   # header
         ## cut-off last columns
         line = line.sub( /,\"upc\",\"filepath\",\"descript\",\"last_mod\",+$/, '') 
         out.puts line
      elsif line =~ /^"+\d+"+,/    # e.g. "5445" or ""5445"",  assume new record
         line = line.sub( /,+$/,'' )   # remove trailing commas ,,,,,,
         line = line.sub( /^"{2,}(\d+)"{2,},/, '"\1",' )   # simplify  # ""4216""" to "4216"

         ## remove last col timestamp
         ## eg ,"2010-07-22 20:00:20"
         line = line.sub( /,\"\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}\"$/, '' )

         ## remove pictures/filepath entries
         # e.g. "hudson.jpg"
         # note: keep komma
         line = line.sub( /\"[A-Za-z0-9_\-]+\.(jpg|png)\"/, '' )

         ## finally remove last columns (that is, descript), assumes upc is always empty !!
         ## "0","0",,"Our 
         ## "13","0",,"Our
         ## "13.1","17.4",,"Our 
         ## "0","0",,,"2010-

         ## note: keep "0,"0" - just cut of the rest
         line = line.sub( /(\"[0-9.]+\",\"[0-9.]+\"),,+(\".+)?$/, '\1' )

         out.puts line
      else
         # skip descr lines
      end
    end
  end
end

task :repairby do |t|

  ## clean/repair breweries.csv

  # remove entries ??
  #  "1174","357",,,,,,,,,,
  #   check for (Closed)   ????

  in_path  = "./dl/breweries.csv"
  out_path = "./o/breweries.csv"

  ## columns
  # "id","name",
  #   "address1","address2","city","state","code","country",
  #   "phone","website",
  #   "filepath","descript","last_mod"

  i = 0
  File.open( out_path, 'w') do |out|
    File.open( in_path, 'r' ).each_line do |line|
      i += 1
      if i % 100
        print '.'
      end

      if line =~ /^"id",/    # header
         ## cut-off last columns
         line = line.sub( /,\"filepath\",\"descript\",\"last_mod\"/, '' )
         out.puts line
      elsif line =~ /^"+\d+"+,/   # e.g. "5445" or ""5445"",  assume new record

         ## remove last col timestamp
         ## eg ,"2010-07-22 20:00:20"
         line = line.sub( /,\"\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}\"$/, '' )

         ## remove everything after incl. filpath entry
         ## remove pictures/filepath entries e.g. "hudson.jpg"
         ## note: keep comma
         line = line.sub( /\"[A-Za-z0-9_\-\.]+\.(jpg|png|gif)\".+$/, ',' )

         ## remove everything after url entry
         ##  e.g. "http://www.schlafly.com" or
         ##  "http://www.hertogjan.nl/site/"
         ##  note: keep commas
         line = line.sub( /(,\"http:\/\/[^\"]+\",+).+$/, ',\1')


         ## remove remain desc  / last column - MUST NOT be followed by comma
         ## check if line ends with ,,,
         ##   no more desc to cleanup -yeah         
         if line =~ /,+$/
           # do nothing
         else
           ##   cut-off starting from end-of-line until we hit ,,"
           pos = line.rindex( ',,"' )   #  find last occurence
           if pos
             line = line[0..pos]
           end
         end

         out.puts line
      else
         # skip descr lines
      end
    end
  end
end  # task repair

task :repair => [:repairb,:repairby] do
end



#######################
# move to tasks

task :cut do |t|

  in_root = './dl/fixed'
  out_root = './o'

  datasets = [
#    [ 'breweries', [0,1,2,3,4,5,6,7,9] ],  # skip phone(8) col too
    [ 'beers', [0,1,2] ],
  ]

  datasets.each do |dataset|
     name       = dataset[0]
     cols       = dataset[1]

     in_path   = "#{in_root}/#{name}.csv"
     out_path  = "#{out_root}/#{name}.csv"

     cut_csv( in_path, out_path, cols )
  end
end


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




def read_brewery_rows
  hash = {}

  in_path = './o/breweries.csv'     ## 1414 rows

  ## try a dry test run
  i = 0
  CSV.foreach( in_path, headers: true ) do |row|
    i += 1
    print '.' if i % 100 == 0
    
    by = Brewery.new
    by.from_row( row )
    hash[ row['id'] ] = by  ## index by id
  end
  puts " #{i} rows"
  
  hash  # return brewery map indexed by id
end


task :addr do |t|
  ## check address2 - if used at all ?
  in_path = './o/breweries.csv'     ## 1414 rows

  ## try a dry test run
  i = 0
  CSV.foreach( in_path, headers: true ) do |row|
    i += 1
    print '.' if i % 100 == 0

    address2 = row['address2']
    if address2
      puts "#{i} => >#{address2}<"
    end
  end
  puts " #{i} rows"
end


##
# note/todo:
##  breweries - same name possible for record!! - add city to make "unique"

task :by do |t|    # check breweries file
  in_path = './o/breweries.csv'     ## 1414 rows

  ## try a dry test run
  i = 0
  CSV.foreach( in_path, headers: true ) do |row|
    i += 1
    print '.' if i % 100 == 0
  end
  puts " #{i} rows"


  country_list = CountryList.new
  i = 0
  CSV.foreach( in_path, headers: true ) do |row|
    i += 1
    print '.' if i % 100 == 0

    country = row['country']
    state   = row['state']
    if country.nil?
      puts " *** row #{i} - country is nil; skipping: #{row.inspect}\n\n"
      next  ## skip line; issue warning
    end

    if state.nil? && country == 'United States'
      puts " *** row #{i} - united states - state is nil; #{row.inspect}\n\n"
    end

    if state.nil? && country == 'Belgium'
      puts " *** row #{i} - belgium - state is nil; #{row.inspect}\n\n"
    end

    country_list.update( row )
  end



  ### pp usage.to_a

  puts "\n\n"
  puts "## Country stats:"

  ary = country_list.to_a

  puts "  #{ary.size} countries"
  puts ""

  ary.each_with_index do |c,j|
    print '%5s ' % "[#{j+1}]"
    print '%-30s ' % c.name
    print ' :: %4d breweries' % c.count
    print "\n"
        
    ## check for states:
    states_ary = c.states.to_a
    if states_ary.size > 0
      puts "   #{states_ary.size} states:"
      states_ary.each_with_index do |state,k|
          print '   %5s ' % "[#{k+1}]"
          print '%-30s ' % state.name
          print '   :: %4d breweries' % state.count
          print "\n"

          if c.name == 'United States'
            # map file name
            ## us_root = './o/us-united-states'
            us_root = '../us-united-states'
            us_state_dir = US_STATES[ state.name ]

            path = "#{us_root}/#{us_state_dir}/breweries.csv"
            
            save_breweries( path, state.breweries )
          elsif c.name == 'Belgium'
            # map file name
            ## be_root = './o/be-belgium'
            be_root = '../be-belgium'
            be_state_dir = BE_STATES[ state.name ]

            path = "#{be_root}/#{be_state_dir}/breweries.csv"

            save_breweries( path, state.breweries )
          else
            # undefined country; do nothing
          end

          ## state.dump  # dump breweries
      end
    end


  end

  puts 'done'
end



task :bycheck do |t|    # check breweries file
  in_path = './o/breweries.csv'     ## 1414 rows

  ## try a dry test run
  i = 0
  CSV.foreach( in_path, headers: true ) do |row|
    i += 1
    print '.' if i % 100 == 0
  end
  puts " #{i} rows"


  usage = CountryUsage.new
  i = 0
  CSV.foreach( in_path, headers: true ) do |row|
    i += 1
    print '.' if i % 100 == 0

    country = row['country']
    state   = row['state']
    if country.nil?
      puts " *** row #{i} - country is nil; skipping: #{row.inspect}\n\n"
      next  ## skip line; issue warning
    end

    if state.nil? && country == 'United States'
      puts " *** row #{i} - united states - state is nil; #{row.inspect}\n\n"
    end

    usage.update( row )
  end

  ### pp usage.to_a

  puts "\n\n"
  puts "## Country stats:"

  ary = usage.to_a

  puts "  #{ary.size} countries"
  puts ""

  ary.each_with_index do |c,j|
    print '%5s ' % "[#{j+1}]"
    print '%-30s ' % c.name
    print ' :: %4d breweries' % c.breweries
    print "\n"
    
    ## check for states:
    states_ary = c.states.to_a
    if states_ary.size > 0
      puts "   #{states_ary.size} states:"
      states_ary.each_with_index do |state,k|
          print '   %5s ' % "[#{k+1}]"
          print '%-30s ' % state.name
          print '   :: %4d breweries' % state.breweries
          print "\n"
      end
    end
  end

  puts 'done'
end




task :b do |t|    # check beers file
  bymap = read_brewery_rows()

  in_path = './o/beers.csv'     ##  repaired  5901 rows (NOT repaired 5861 rows)

  country_list = CountryList.new

  i = 0
  CSV.foreach( in_path, headers: true ) do |row|
    i += 1
    print '.' if i % 100 == 0
    
    brewery_id = row['brewery_id']
    by = bymap[brewery_id]
    if by
      b = Beer.new
      b.brewery = by
      b.from_row( row )

      country = by.country
      state   = by.state
      if country.nil? && country == '?'
        puts " *** row #{i} - country is nil; skipping: #{row.inspect}\n\n"
        next  ## skip line; issue warning
      end

      if (state.nil? || state == '?') && country == 'United States'
        puts " *** row #{i} - united states - state is nil; #{row.inspect}\n\n"
      end

      if (state.nil? || state == '?') && country == 'Belgium'
        puts " *** row #{i} - belgium - state is nil; #{row.inspect}\n\n"
      end

      country_list.update_beer( b )
    else
      puts "** brewery #{i} with id >#{brewery_id}< not found; skipping beer row:"
      pp row
    end
  end
  puts " #{i} rows"


  ### pp usage.to_a

  puts "\n\n"
  puts "## Country stats:"

  ary = country_list.to_a

  puts "  #{ary.size} countries"
  puts ""

  ary.each_with_index do |c,j|
    print '%5s ' % "[#{j+1}]"
    print '%-30s ' % c.name
    print ' :: %4d beers' % c.count
    print "\n"
        
    ## check for states:
    states_ary = c.states.to_a
    if states_ary.size > 0
      puts "   #{states_ary.size} states:"
      states_ary.each_with_index do |state,k|
          print '   %5s ' % "[#{k+1}]"
          print '%-30s ' % state.name
          print '   :: %4d beers' % state.count
          print "\n"

          if c.name == 'United States'
            # map file name
            us_root = './o/us-united-states'
            ## us_root = '../us-united-states'
            us_state_dir = US_STATES[ state.name ]

            path = "#{us_root}/#{us_state_dir}/beers.csv"
            
            save_beers( path, state.beers )
          elsif c.name == 'Belgium'
            # map file name
            be_root = './o/be-belgium'
            ## be_root = '../be-belgium'
            be_state_dir = BE_STATES[ state.name ]

            path = "#{be_root}/#{be_state_dir}/beers.csv"

            save_beers( path, state.beers )
          else
            # undefined country; do nothing
          end

          ## state.dump  # dump breweries
      end
    end


  end

  puts 'done'
end  # task :b

