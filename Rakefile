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
require './scripts/csv'



############################################
# add more tasks (keep build script modular)

Dir.glob('./tasks/**/*.rake').each do |r|
  puts " importing task >#{r}<..."
  import r
  # see blog.smartlogicsolutions.com/2009/05/26/including-external-rake-files-in-your-projects-rakefile-keep-your-rake-tasks-organized/
end




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

    by = Brewery.new.from_row( row )
    if by.closed?
      puts "*** row #{i} - skip closed brewery >#{by.name}<"
      next ## skip closed breweries; issue warning
    end

    country_list.update_brewery( by )
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
            us_state_dir = US_STATES[ state.name.downcase ]

            if us_state_dir
              path = "#{us_root}/#{us_state_dir}/breweries.csv"
              save_breweries( path, state.breweries )
            else
              puts "*** warn: no state mapping defined for >#{state.name}<"
            end
          elsif c.name == 'Belgium'
            # map file name
            ## be_root = './o/be-belgium'
            be_root = '../be-belgium'
            be_state_dir = BE_STATES[ state.name.downcase ]

            if be_state_dir
              path = "#{be_root}/#{be_state_dir}/breweries.csv"
              save_breweries( path, state.breweries )
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
            ## us_root = './o/us-united-states'
            us_root = '../us-united-states'
            us_state_dir = US_STATES[ state.name.downcase ]

            if us_state_dir
              path = "#{us_root}/#{us_state_dir}/beers.csv"
              save_beers( path, state.beers )
            else
              puts "*** warn: no state mapping defined for >#{state.name}<"
            end
          elsif c.name == 'Belgium'
            # map file name
            ## be_root = './o/be-belgium'
            be_root = '../be-belgium'
            be_state_dir = BE_STATES[ state.name.downcase ]

            if be_state_dir
              path = "#{be_root}/#{be_state_dir}/beers.csv"
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

