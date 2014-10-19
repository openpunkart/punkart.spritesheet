# encoding: utf-8



def build_brewery_map( path )    ## use (rename to) build_breweries_map (plural) why? why not?
  hash = {}
  breweries = read_breweries_openbeer( path )

  i = 0
  breweries.each do |by|
    i += 1
    print '.' if i % 100 == 0

    hash[ by.id ] = by  ## index by id
  end
  puts " #{i} rows"
  
  hash  # return brewery map indexed by id
end



def save_breweries( path, breweries )
  ### make path
  puts "path=>#{path}<"

  FileUtils.mkdir_p(File.dirname(path))   unless File.exists?(File.dirname(path))

  # sort breweries by name, city
  breweries.sort! do |l,r|
    value = l.name <=> r.name
    value = l.city <=> r.city   if value == 0
    value
  end


  File.open( path, 'w' ) do |file|
    ## write csv headers
    file.puts ['Name','Address', 'City', 'State', 'Code', 'Website', 'Tags'].join(',')

    ## write records
    breweries.each do |by|
      file.puts [by.name,
                 by.address,
                 by.city,
                 by.state_code.upcase,
                 by.postal_code,
                 by.website,
                 by.tags].join(',')
    end
  end
end  # method save_breweries


class Brewery

  # note: all fields/attribs are strings
  attr_reader :id,
              :name,
              :address,
              :city,
              :state,
              :state_code,    # eg. tx,b,bru,n,on, etc.
              :postal_code,   # postal code
              :country,
              :country_code,  # e.g. at,ca,us,eng,wal,etc.
              :website,
              :tags    # e.g. brewery,brewpub,nanobrewery,contract,etc.

  def closed?
    @closed == true
  end

  def initialize
    @closed      = false   # default; brewery NOT closed, that is, it's open
    
    @address      = '?'
    @postal_code  = '?'
    @state_code   = '?'
    @country_code = '?'
    @tags         = '?'
  end


  def norm_name( txt )
    ## NOTE: replace commas in name, addresses w/ pipe (|)
    txt  = txt.gsub(',',' |')

    # name cleanup
    #   remove trailing
    #       ,_LLC
    #       ,_Inc.
    #       _LLC

    txt = txt.sub( /,\s*LLC$/, '' )
    txt = txt.sub( /,\s*Inc\.$/, '' )
    txt = txt.sub( /\s+LLC$/, '' )

    ##
    # fix: do NOT include brewery if marked (Closed) in name
    if txt =~ /\(Closed\)/    # check for closed marker e.g (Closed)
      @closed = true
    end
    txt
  end

  def norm_city( txt )
    if txt
      txt = txt.sub('(no address available)', '')
      txt = txt.strip
      txt
    else
      '?'
    end
  end

  def norm_website( txt )
    if txt
      ## NOTE: cleanup url - remove leading http:// or https://
      txt = txt.sub( /^(http|https):\/\//, '' )
      txt = txt.sub( /\/$/, '' )  # remove trailing slash (/)
      txt
    else
      '?'
    end
  end
  


  def map_state( txt )
    ## todo/fix:
    ##   warn if txt is nil?  no state defined/present for mapping
    #      different from no mapping found
    return '?' if txt.nil?
    
    if @country == 'United States'
      mapping = US_STATES_MAPPING
    elsif @country == 'Belgium'
      mapping = BE_STATES_MAPPING
    elsif @country == 'Germany'
      mapping = DE_STATES_MAPPING
    elsif @country == 'Canada'
      mapping = CA_STATES_MAPPING
    else
     mapping = nil
    end

    if mapping
      txt = txt.gsub( ',' ,'' ) # remove any commas if present
      txt = txt.gsub( '|' ,'' ) # remove escaped commas if present
      txt = txt.sub( '(no address available)', '' )
      txt = txt.strip  # remove leading n trailing spaces

      key = mapping[ txt ]
      if key.nil?
        puts "*** warn: no states mapping for >#{txt}< / >#{@country}<"
        '?'
      else
        key
      end
    else
      '?'
    end
  end


  def from_row_ca( row )
#  "Name": "5 Paddles Brewing",
#  "City": "Whitby",
#  "Province": "ON",
#  "URL": "http://5paddlesbrewing.com/",
#  "Facebook": "https://www.facebook.com/5PaddlesBrewingCompany",
#  "Twitter": "https://twitter.com/5PaddlesBrewing",
#  "Type": "Brewery",
# "marker-color": "#f00"

    @name     = row['Name']
    @city     = row['City']
    @state    = row['Province']
    @website  = row['URL']

    @postal_code  = '?'
    @address      = '?'
    @country      = 'Canada'
    @country_code = 'ca'

    ## make Type e.g. Brewery,Brewpub,Brewpub Chain,Nanobrewery, etc. into a tag
    tagcand =  row['Type']
    @tags = tagcand.downcase.gsub(' ','_')

    @name    = norm_name( @name )
    @city    = norm_city( @city )
    @website = norm_website( @website )

    @state_code = map_state( @state )

    self   # NOTE: return self (to allow method chaining)
  end


  def from_row( row )
# "id","name","address1","address2",
#   "city","state","code","country","phone",
#    "website","filepath","descript","last_mod"
#
#  "1","(512) Brewing Company","407 Radam, F200",,
#   "Austin","Texas","78745","United States","512.707.2337",
#     "http://512brewing.com/",,"(512) Brewing Company is a microbrewery located in the heart of Austin that brews for the community using as many local, domestic and organic ingredients as possible.","2010-07-22 20:00:20"

    @id          = row['id']
    @name        = row['name']
    @city        = row['city']
    @state       = row['state']
    @postal_code = row['code']
    @country     = row['country']
    @website     = row['website']

    @address     = row['address1']

    ### NOTE: address2 used only 4 out of 1414 recs in open beer db
    ## merge into one if present use | for now; use // later ?
    #  1380 => >Wandsworth<
    #  1394 => >Suite 100<
    #  1406 => >Stanhope St<
    #  1408 => >1000 Murray Ross Parkway<
    address2 = row['address2']


    @address  =  @address ? @address.gsub(',',' |') : '?'

    if address2
      address2 = address2.gsub(',',' |')
      @address << " | #{address2}"
    end

    @name        = norm_name( @name )
    @city        = norm_city( @city )

    ### special cases for country/state
    if @country == 'United States'
      if @state == 'Virgin Islands'
        @country = 'US Virgin Islands'
        @state   = '?'
      end
    elsif @country == 'United Kingdom'
      if @state == 'Scotland'
        @country = 'Scotland'
        @state   = '?'
      elsif @state == 'Wales'
        @country = 'Wales'
        @state   = '?'
      else
        ## assume england
        @country = 'England'
      end
    else
      # do nothing; no special case
    end


    @state_code  = map_state( @state )

    @code      = @code ? @code : '?'    ## postal code / zip code


    @website   = norm_website( @website )

    self   # NOTE: return self (to allow method chaining)
  end

end  # class Brewery
