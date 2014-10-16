# encoding: utf-8


def save_breweries( path, breweries )
  ### make path
  puts "path=>#{path}<"

  FileUtils.mkdir_p(File.dirname(path))   unless File.exists?(File.dirname(path))

  File.open( path, 'w' ) do |file|
    ## write csv headers
    file.puts ['Name','Address1', 'Address2', 'City', 'State', 'Code', 'Website'].join(',')

    ## write records
    breweries.each do |by|
      file.puts [by.name,by.address1,by.address2,by.city,by.state,by.code,by.website].join(',')
    end
  end
end  # method save_breweries


class Beer
  attr_accessor :brewery
  
  attr_reader :name,
              :abv,
              :ibu,
              :srm,
              :upc,
              :cat,
              :style

  def initialize
    @brewery = nil
  end
  
  def from_row( row )
#  "id","brewery_id","name",
#    "cat_id","style_id",
#    "abv","ibu","srm","upc",
#    "filepath","descript","last_mod"
#
#  "1","812","Hocus Pocus",
#    "11","116",
#    "4.5","0","0","0",
#    ,"Our take on a classic summer ale.  A toast to weeds, rays, and summer haze.
#       A light, crisp ale for mowing lawns, hitting lazy fly balls, and communing with nature, Hocus Pocus is offered up as a summer sacrifice to clodless days.
#       its malty sweetness finishes tart and crisp and is best apprediated with a wedge of orange.","2010-07-22 20:00:20"
#
#  "2","264","Grimbergen Blonde",
#    "-1","-1",
#    "6.7","0","0","0",,,"2010-07-22 20:00:20"

    @name   = row['name']

    ## NOTE: replace commas in name, addresses w/ pipe (|)
    @name   = @name.gsub(',',' |')

    self   # NOTE: return self (to allow method chaining)
  end  
end  # class Beer



class Brewery

  attr_reader :name,
              :address1,
              :address2,
              :city,
              :state,
              :code,  # postal code
              :country,
              :website

  def initialize
    # do nothing for now
  end
  
  def from_row( row )
# "id","name","address1","address2",
#   "city","state","code","country","phone",
#    "website","filepath","descript","last_mod"
#
#  "1","(512) Brewing Company","407 Radam, F200",,
#   "Austin","Texas","78745","United States","512.707.2337",
#     "http://512brewing.com/",,"(512) Brewing Company is a microbrewery located in the heart of Austin that brews for the community using as many local, domestic and organic ingredients as possible.","2010-07-22 20:00:20"

    @name     = row['name']
    @address1 = row['address1']
    @address2 = row['address2']
    @city     = row['city']
    @state    = row['state']
    @code     = row['code']
    @country  = row['country']
    @website  = row['website']

    ## NOTE: replace commas in name, addresses w/ pipe (|)
    @name      = @name.gsub(',',' |')
    @address1  = @address1 ? @address1.gsub(',',' |') : '?'
    @address2  = @address2 ? @address2.gsub(',',' |') : '?'
    @city      = @city     ? @city : '?'
    @state     = if @state
                    if @country == 'United States'
                      mapping = US_STATES_MAPPING
                    elsif @country == 'Belgium'
                      mapping = BE_STATES_MAPPING
                    else
                      mapping = nil
                    end

                    if mapping
                      state_abbrev = mapping[ @state ]
                      if state_abbrev.nil?
                        puts "*** warn: no states mapping for >#{@state}< / >#{@country}<"
                        @state   ## check: what to return; keep unmapped state or use ? ???
                      else
                        state_abbrev.upcase
                      end
                    else
                      @state
                    end
                 else
                   '?'
                 end
    @code      = @code ? @code : '?'    ## postal code / zip code
    @website   = if @website
                    ## NOTE: cleanup url - remove leading http:// or https://
                    @website = @website.sub( /^(http|https):\/\//, '' )
                    @website = @website.sub( /\/$/, '' )  # remove trailing slash (/)
                    @website
                  else
                    '?'
                  end

    self   # NOTE: return self (to allow method chaining)
  end

end  # class Brewery



class StateItem
  attr_accessor  :name,
                 :count,          ## number of breweries
                 :breweries,       # "payload" -  use "generic" name? why? why not?
                 :beers

  def initialize( name )
    @name       = name
    @count      = 0
    @breweries  = []     ## use breweries.size  for count ?? why? why not?
    @beers      = []
  end
  
  def dump
    @breweries.each_with_index do |by,i|
      puts "[#{i+1}/#{@breweries.size}]   #{by.name}"
    end
  end
end # class StateItem


class CountryItem
  attr_accessor  :name,
                 :count,  ## number of breweries
                 :states

  def initialize( name )
    @name       = name
    @count      = 0
    @states     = StateList.new
  end
end # class CountryItem




class StateList
  def initialize( opts={} )
    @lines = {}   # StatsLines cached by state name/key
  end

  def update( row )

    country = row['country']
    state   = row['state']

    ## map/unify us states
    if country == 'United States'
      state = US_STATES_MAPPING[state]
      
      if state.nil?
        puts "*** skip unkown us state >#{row['state']}<; no mapping found"
        return
      end
    elsif country == 'Belgium'
      state = BE_STATES_MAPPING[state]
      
      if state.nil?
        puts "*** skip unkown belgium state/region >#{row['state']}<; no mapping found"
        return
      end
    else
      ## no mapping defined
    end

    line = @lines[ state ] || StateItem.new( state )

    line.count +=1
    
    line.breweries << Brewery.new.from_row( row )

    @lines[ state ] = line
  end

  def to_a
    ## return lines sorted a-z

    # build array from hash
    ary = []
    @lines.each do |k,v|
      ary << v
    end

    ## for now sort just by name (a-z)
    ary.sort! do |l,r|
      ## note: reverse order (thus, change l,r to r,l)
      value = r.count <=> l.count
      value = l.name <=> r.name            if value == 0
      value
    end

    ary
  end  # to_a
end


class CountryList

  def initialize( opts={} )
    @lines = {}   # StatssLines cached by country name/key
  end

  def update_beer( b )
    country = b.brewery.country
    line = @lines[ country ] || CountryItem.new( country )
    line.count +=1
    
    state = b.brewery.state
    if state.nil?
      ## do nothing for now (add to uncategorized state ???)
    else
      line.states.update_beer( b )   ## also track states e.g texas, california (US) etc.
    end

    @lines[ country ] = line
  end

  ## fix: rename to update_brewery( by )
  def update( row )
    country = row['country']
    line = @lines[ country ] || CountryItem.new( country )

    line.count +=1

    state = row['state']
    if state.nil?
      ## do nothing for now (add to uncategorized state ???)
    else
      line.states.update( row )   ## also track states e.g texas, california (US) etc.
    end

    @lines[ country ] = line
  end

  def to_a
    ## return lines sorted a-z

    # build array from hash
    ary = []
    @lines.each do |k,v|
      ary << v
    end

    ## for now sort just by name (a-z)
    ary.sort! do |l,r|
      ## note: reverse order (thus, change l,r to r,l)
      value = r.count <=> l.count
      value = l.name <=> r.name            if value == 0
      value
    end

    ary
  end  # to_a


end # class CountryList

