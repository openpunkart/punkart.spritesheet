# encoding: utf-8



task :repair => [:repairb,:repairby] do
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


