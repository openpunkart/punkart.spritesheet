# encoding: utf-8


class StateItem
  attr_accessor  :name,
                 :count      # number of rec(ord)s

  def initialize( name )
    @name       = name
    @count      = 0
  end
end # class BaseStateItem



class BeerStateItem < StateItem
  attr_accessor :beers

  def initialize( name )
    super( name )
    @beers = []
  end
end

class BreweryStateItem < StateItem
  attr_accessor :breweries

  def initialize( name )
    super( name )
    @breweries = []
  end
end


class CountryItem
  attr_accessor  :name,
                 :count,  ## number of rec(ord)s e.g. breweries/beers etc.
                 :states

  def initialize( name )
    @name       = name
    @count      = 0
    @states     = StateList.new
  end
end # class CountryItem

class BeerCountryItem < CountryItem
  attr_accessor :beers

  def initialize( name )
    super( name )
    @beers = []
  end
end # class BeerCountryItem

class BreweryCountryItem < CountryItem
  attr_accessor :breweries

  def initialize( name )
    super( name )
    @breweries = []
  end
end # class BreweryCountryItem

class StatsCountryItem < CountryItem
  attr_accessor  :breweries,  ## number of breweries
                 :breweries_year,
                 :consumption,
                 :consumption_year,
                 :consumption_per_capita,
                 :consumption_per_capita_year,
                 :production,
                 :production_year

  def initialize( name )
    super( name )

    @breweries = nil
    @breweries_year = nil
    @consumption = nil
    @consumption_year = nil
    @consumption_per_capita = nil
    @consumption_per_capita_year = nil
    @production = nil
    @production_year = nil
  end
end # class StatsCountryItem





class StateList
  def initialize( opts={} )
    @lines = {}   # StatsLines cached by state name/key
  end

  def update_beer( b )
    ## country = b.brewery.country
    state   = b.brewery.state_code   # todo: check for nil?
   
    ## note: include uncategorized (beers/breweries w/o state) to uncategorized
    line = @lines[ state ] || BeerStateItem.new( state )

    line.count +=1
    line.beers << b

    @lines[ state ] = line
  end

  def update_brewery( by )
    ## country = by.country
    state   = by.state_code

    line = @lines[ state ] || BreweryStateItem.new( state )

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
    line = @lines[ country ] || BeerCountryItem.new( country )
    line.count +=1
    line.beers << b

    state = b.brewery.state_code
    if state.nil? || state == '?'
      ## do nothing for now (add to uncategorized state ???)
    else
      line.states.update_beer( b )   ## also track states e.g texas, california (US) etc.
    end

    @lines[ country ] = line
  end

  def update_brewery( by )
    country = by.country
    line = @lines[ country ] || BreweryCountryItem.new( country )
    line.count +=1
    line.breweries << by

    ## state = by.state_code
    ### note: add breweries w/o state or undefined state to unclassified for now 
    line.states.update_brewery( by )   ## also track states e.g texas, california (US) etc.

    @lines[ country ] = line
  end


  def update_stats_attr( attr, row )
    ### fix: check task summary; cleanup code

    ## for now assume matching country names and country column
    ### fix/todo: map country name to country key (e.g. Austria => at etc.)
    country = row['Country']
    line = @lines[ country ] || StatsCountryItem.new( country )

    ## get second raw_assume it's the value
    # note: to_i will cut off remaining e.g 12 (59) or 12 / 1 / 1
    value = row[1].to_i

    puts " update #{country} - #{attr} => #{value}"
    line.send( "#{attr}=".to_sym, value )
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

