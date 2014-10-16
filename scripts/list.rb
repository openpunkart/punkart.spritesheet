
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

    by = Brewery.new.from_row( row )
    if by.closed?
      puts "*** skip closed brewery >#{by.name}<"
      return
    end

    line = @lines[ state ] || StateItem.new( state )

    line.count +=1
    line.breweries << by

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

