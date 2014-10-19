# encoding: utf-8



task :checkby do |t|    # check breweries file
  in_path = './o/breweries.csv'

  ## try a dry test run
  i = 0
  CSV.foreach( in_path, headers: true ) do |row|
    i += 1
    print '.' if i % 100 == 0
  end
  puts " #{i} rows"


  usage = CountryList.new
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

    by = Brewery.new.from_row( row )
    usage.update_brewery( by )
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
      end
    end
  end

  puts 'done'
end

