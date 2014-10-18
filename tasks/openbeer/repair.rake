# encoding: utf-8


task :chardet do
  require 'rchardet19'

  data = 'Ã¤Ã¼Ã¶Ã¡Ã¶Å‚Ã³Ã­'   ## CP850  ??
  cd = CharDet.detect(data)
  pp cd

  ## puts data
  ## data.force_encoding( )

  data = File.read( './dl/breweries.csv' )
  cd = CharDet.detect(data)
  pp cd
end




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

     ## todo: fix encoding ?? is windows cp850 ???
     ##

##
## check - augustiner bräu  - missing too Strae => Straße
##  eg . "Augustiner-BrÃ¤u MÃ¼nchen","Landsberger Strae 35",,"MÃ¼nchen","Bayern",,"Germany","49-(0)89-/-519940","http://www.augustiner-braeu.de",,

     ## fix: char non-ascii encoding  - what encoding gets used ??
     ##  add more/missing non-ascii chars
     ## line = line.gsub( 'Ã¤', 'ä' )
     ## line = line.gsub( 'Ã¼', 'ü' )
     ##  line = line.gsub( 'Ã¶', 'ö' )
     ## line = line.gsub( 'Ã¡', 'á' )
     ## line = line.gsub( 'Ã¶', 'ő' )
     ## line = line.gsub( 'Å‚', 'ł' )  ##  NamysÅ‚Ã³w  =>  Namysłów
     ## line = line.gsub( 'Ã³', 'ó' )  ##  NamysÅ‚Ã³w  =>  Namysłów
     ## line = line.gsub( 'Ã­', 'í' )  ##  CervecerÃ­a => cervecería  

##
# fix: cuvee  -- non-ascii missing
# Brasserie-Brouwerij Cantillon,Anderlecht,CuvÃ©e des Champions 2003-2004,belgian_and_french_ale|belgian_style_fruit_lambic
## Brasserie-Brouwerij Cantillon,Anderlecht,RosÃ© de Gambrinus,belgian_and_french_ale|belgian_style_fruit_lambic


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
         line = line.sub( /\"[A-Za-z0-9_\-\.]+\.(jpg|png|gif)\".+$/, ',,' )

         ## remove everything after url entry
         ##  e.g. "http://www.schlafly.com" or
         ##  "http://www.hertogjan.nl/site/"
         ##  note: keep commas
         line = line.sub( /(,\"http:\/\/[^\"]+\",+).+$/, '\1')


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


