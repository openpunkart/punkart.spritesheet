# encoding: utf-8


class CountryInfo
  attr_accessor  :name,
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
    @breweries              = nil
    @breweries_year         = nil
    @consumption            = nil
    @consumption_year       = nil
    @consumption_per_capita = nil
    @consumption_per_capita_year = nil
    @production = nil
    @production_year = nil
  end
end # class CountryInfo


class CountryInfoStore    # find a better name ?? -use CountryInfoMap? CountryInfoCalculator/Updater/Hash/List ???

  def initialize( opts={} )
    @lines = {}   # stats lines cached by country name/key
  end

  def update( attr, row )
    ## for now assume matching country names and country column
    ###  fix/todo: map country name to country key (e.g. Austria => at etc.)
    country = row['Country']

    line = @lines[ country ] || CountryInfo.new( country )

    ## get second raw_assume it's the value
    # note: to_i will cut off remaining e.g 12 (59) or 12 / 1 / 1
    value   = row[1].to_i

    puts "  update #{country} - #{attr} => #{value}"
    line.send( "#{attr}=".to_sym, value )

    @lines[ country ] = line
  end

  def to_a
    ## return lines sorted by consumption per capita

    # build array from hash
    ary = []
    @lines.each do |k,v|
      ary << v
    end

    ## for now sort just by name (a-z)
    ary.sort! do |l,r|
      ## note: reverse order (thus, change l,r to r,l)
      value = r.consumption_per_capita <=> l.consumption_per_capita
      value = l.name <=> r.name            if value == 0
      value
    end

    ary
  end  # to_a


end # class CountryInfoStore

