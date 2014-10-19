# encoding: utf-8


task :b do |t|    # check beers file

  us_root = './o/us-united-states'
  be_root = './o/be-belgium'
  de_root = './o/de-deutschland'
  ## ca_root = './o/ca-canada'

  ## us_root = '../us-united-states'
  ## be_root = '../be-belgium'
  ## de_root = '../de-deutschland'
  ca_root = '../ca-canada'


  in_path = './o/beers.csv'     ##  repaired  5901 rows (NOT repaired 5861 rows)

  reader = BeerReader.new(
              breweries_path:  './o/breweries.csv',
              categories_path: './dl/categories.csv',
              styles_path:     './dl/styles.csv' )

  beers  = reader.read( in_path )

  country_list = CountryList.new

  i = 0
  beers.each do |b|
    country_list.update_beer( b )
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
            us_state_dir = US_STATES[ state.name.downcase ]

            if us_state_dir
              path = "#{us_root}/#{us_state_dir}/beers.csv"
              save_beers( path, state.beers )
            else
              puts "*** warn: no state mapping defined for >#{state.name}<"
            end
          elsif c.name == 'Belgium'
            be_state_dir = BE_STATES[ state.name.downcase ]

            if be_state_dir
              path = "#{be_root}/#{be_state_dir}/beers.csv"
              save_beers( path, state.beers )
            else
              puts "*** warn: no state mapping defined for >#{state.name}<"
            end
          elsif c.name == 'Germany'
            de_state_dir = DE_STATES[ state.name.downcase ]

            if de_state_dir
              path = "#{de_root}/#{de_state_dir}/beers.csv"
              save_beers( path, state.beers )
            else
              puts "*** warn: no state mapping defined for >#{state.name}<"
            end
          elsif c.name == 'Canada'
            ca_state_dir = CA_STATES[ state.name.downcase ]

            if ca_state_dir
              path = "#{ca_root}/#{ca_state_dir}/beers.csv"
              save_beers( path, state.beers )
            else
              puts "*** warn: no state mapping defined for >#{state.name}<"
            end
          else
            # undefined country; do nothing
          end

          ## state.dump  # dump breweries
      end
    end


  end

  puts 'done'
end  # task :b