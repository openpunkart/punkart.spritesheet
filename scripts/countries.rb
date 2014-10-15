# encoding: utf-8


class StateUsageLine
  attr_accessor  :name,
                 :breweries  ## number of breweries

  def initialize( name )
    @name       = name
    @breweries  = 0
  end
end # class StateUsageLine

class CountryUsageLine
  attr_accessor  :name,
                 :breweries,  ## number of breweries
                 :states

  def initialize( name )
    @name       = name
    @breweries  = 0
    @states     = StateUsage.new
  end
end # class CountryUsageLine



class StateUsage
  def initialize( opts={} )
    @lines = {}   # StatsLines cached by state name/key
  end

  def update( row )
    state = row['state']
    line = @lines[ state ] || StateUsageLine.new( state )

    line.breweries +=1

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
      value = r.breweries <=> l.breweries
      value = l.name <=> r.name            if value == 0
      value
    end

    ary
  end  # to_a
end

class CountryUsage

  def initialize( opts={} )
    @lines = {}   # StatssLines cached by country name/key
  end

  def update( row )
    country = row['country']
    line = @lines[ country ] || CountryUsageLine.new( country )

    line.breweries +=1

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
      value = r.breweries <=> l.breweries
      value = l.name <=> r.name            if value == 0
      value
    end

    ary
  end  # to_a


end # class CountryUsage

