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
                 :states,
                 :breweries,  ## number of breweries
                 :breweries_year,
                 :consumption,
                 :consumption_year,
                 :consumption_per_capita,
                 :consumption_per_capita_year,
                 :production,
                 :production_year

  def initialize( name )
    @name       = name
    @states     = StateUsage.new

    @breweries = nil
    @breweries_year = nil
    @consumption = nil
    @consumption_year = nil
    @consumption_per_capita = nil
    @consumption_per_capita_year = nil
    @production = nil
    @production_year = nil

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


  def update_attr( attr, row )
    ### fix: check task summary; cleanup code

    ## for now assume matching country names and country column
    ### fix/todo: map country name to country key (e.g. Austria => at etc.)
    country = row['Country']
    line = @lines[ country ] || CountryInfo.new( country )

    ## get second raw_assume it's the value
    # note: to_i will cut off remaining e.g 12 (59) or 12 / 1 / 1
    value = row[1].to_i

    puts " update #{country} - #{attr} => #{value}"
    line.send( "#{attr}=".to_sym, value )
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

      ## fix: to be done - allow as option!!!!
      ## return lines sorted by consumption per capita
      ##  value = r.consumption_per_capita <=> l.consumption_per_capita  

      value = r.breweries <=> l.breweries
      value = l.name <=> r.name            if value == 0
      value
    end

    ary
  end  # to_a


end # class CountryUsage

