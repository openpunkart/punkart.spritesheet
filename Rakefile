# encoding: utf-8


require 'csv'
require 'pp'
require 'fileutils'


##############
# our own code

require './countries'

require './scripts/countries'
require './scripts/breweries'



############################################
# add more tasks (keep build script modular)

Dir.glob('./tasks/**/*.rake').each do |r|
  puts " importing task >#{r}<..."
  import r
  # see blog.smartlogicsolutions.com/2009/05/26/including-external-rake-files-in-your-projects-rakefile-keep-your-rake-tasks-organized/
end



##
# note/todo:
##  breweries - same name possible for record!! - add city to make "unique"

task :by do |t|    # check breweries file
  in_path = './dl/breweries.csv'     ## 1414 rows

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
            us_root = './o/us-united-states'
            ## us_root = '../us-united-states'
            us_state_dir = US_STATES[ state.name ]

            path = "#{us_root}/#{us_state_dir}/breweries.csv"
            ### make path
            puts "path=>#{path}<"

            FileUtils.mkdir_p(File.dirname(path))   unless File.exists?(File.dirname(path))

            File.open( path, 'w') do |file|
              
              ## write csv headers
              file.puts ['Name','Address1', 'Address2', 'City', 'State', 'Code', 'Website'].join(',')
             
              ## write records
              state.breweries.each do |by|
              
                name      = by.name
                ## NOTE: replace commas in address line w/ pipe (|)
                address1  = by.address1 ? by.address1.gsub(',',' |') : '?'
                address2  = by.address2 ? by.address2.gsub(',',' |') : '?'
                city      = by.city     ? by.city : '?'
                state     = if by.state
                              ## NOTE: us-specific ??   map us states to two-letter abbrev
                              US_STATES_MAPPING[ by.state ].upcase
                            else
                              '?'
                            end
                code      = by.code     ? by.code : '?'
                website   = if by.website
                              ## NOTE: cleanup url - remove leading http:// or https://
                              website = by.website
                              website = website.sub( /^(http|https):\/\//, '' )
                              website = website.sub( /\/$/, '' )  # remove trailing slash (/)
                            else
                              '?'
                            end
             
                file.puts [name,address1,address2,city,state,code,website].join(',')
              end
            end
          end

          ## state.dump  # dump breweries
      end
    end


  end

  puts 'done'
end



task :bycheck do |t|    # check breweries file
  in_path = './dl/breweries.csv'     ## 1414 rows

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
  in_path = './dl/beers.csv'     ## 5861 rows

  ## try a dry test run

  i = 0
  CSV.foreach( in_path, headers: true ) do |row|
    i += 1
    print '.' if i % 100 == 0
  end
  puts " #{i} rows"
end

