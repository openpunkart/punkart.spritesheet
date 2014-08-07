# encoding: utf-8


task :summary do |t|
  ## build/update stats summary page

  in_root = '../statistics'
  out_root = './o/statistics'

  # note: for now assume name of dataset is the name of the attribute to update too
  datasets = [
    'breweries',
    'consumption',
    'consumption_per_capita',
    'production',
  ]

  stats = CountryInfoStore.new

  datasets.each do |dataset|
    name = dataset
    attr = dataset

    in_path   = "#{in_root}/#{name}.csv"
    
    ## try a dry test run
    i = 0
    CSV.foreach( in_path, headers: true ) do |row|
      i += 1
      puts row.inspect   if i == 1   ## for debugging print first row
      print '.' if i % 100 == 0

      stats.update( attr, row )
    end
  end


  out_path = "#{out_root}/SUMMARY.md"

  ### make sure out_root path exists
  FileUtils.mkdir_p( out_root )   unless Dir.exists?( out_root )

  ### output a small report

  buf = ''
  buf << "\n"
  buf << "## List of countries by beer consumption per capita\n"
  buf << "\n\n"
  buf << "|            | Country            |         Consumption |          Production |     # Breweries |\n"
  buf << "| ---------: | ------------------ | ------------------: | ------------------: | --------------: |\n"


  stats.to_a.each do |country|
    buf << "| %6s (l) "   % country.consumption_per_capita
    buf << "| %-18s " % country.name
    buf << "| %10s (000 hl) "  % country.consumption
    buf << "| %10s (000 hl) "  % country.production
    buf << "| %5s breweries |"  % (country.breweries == 0 ? '?' : country.breweries)
    buf << "\n"
  end

  buf << "\n\n"

  puts "## summary:"
  puts buf

  File.open( out_path, 'w' ) do |out|
    out.puts buf
  end

  puts 'done'
end

