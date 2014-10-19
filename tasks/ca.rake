# encoding: utf-8


###################
# process geojson
#  see github.com/mezzoblue/canadian-craft-breweries

def read_breweries_ca( path )
  ary = []

  txt = File.read( path )
  puts "txt.length: #{txt.length}"

  h = JSON.parse( txt )
  features  = h[ 'features' ]

  puts "features.size: #{features.size}"

  features.each do |feature|
    if feature['type'] == 'Feature' 

      props = feature['properties']

      ## puts "name: #{props['Name']}"

      by = Brewery.new.from_row_ca( props )
      ary << by
    else
      puts "*** warn: unknown type: >#{feature['type']}<"
    end
  end
  ary
end


task :ca do

  in_path = './dl/ca/breweries.geojson'
  breweries = read_breweries_ca( in_path )

  country_list = CountryList.new
  
  breweries.each_with_index do |by,i|
    print '.' if i % 100 == 0
    country_list.update_brewery( by )
  end

  ary = country_list.to_a

  puts "  #{ary.size} countries"
  puts ""

  c = ary[0]  ## assume only one country (canada)

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

          ca_state_dir = CA_STATES[ state.name.downcase ]

          if ca_state_dir
            path = "#{CA_ROOT}/#{ca_state_dir}/breweries.csv"
            save_breweries( path, state.breweries )
          else
            puts "*** warn: no state mapping defined for >#{state.name}<"
          end
       end
    end

end  # task :ca

