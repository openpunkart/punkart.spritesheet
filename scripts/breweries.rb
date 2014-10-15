# encoding: utf-8


class Brewery

  attr_reader :name

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
    @website  = row['website']
    
    self   # NOTE: return self (to allow method chaining)
  end

end  # class Brewery


class StateItem
  attr_accessor  :name,
                 :count,          ## number of breweries
                 :breweries       # "payload" -  use "generic" name? why? why not?

  def initialize( name )
    @name       = name
    @count      = 0
    @breweries  = []     ## use breweries.size  for count ?? why? why not?
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

