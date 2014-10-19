# encoding: utf-8


def read_brewery_rows( path )
  hash = {}

  ## try a dry test run
  i = 0
  CSV.foreach( path, headers: true ) do |row|
    i += 1
    print '.' if i % 100 == 0

    by = Brewery.new
    by.from_row( row )
    hash[ row['id'] ] = by  ## index by id
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
    file.puts ['Name','Address', 'City', 'State', 'Code', 'Website'].join(',')

    ## write records
    breweries.each do |by|
      file.puts [by.name,by.address,by.city,by.state,by.code,by.website].join(',')
    end
  end
end  # method save_breweries


class Brewery

  attr_reader :name,
              :address,
              :city,
              :state,
              :code,  # postal code
              :country,
              :website

  def closed?
    @closed == true
  end

  def initialize
    @closed = false   # default; brewery NOT closed, that is, it's open
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
    @city     = row['city']
    @state    = row['state']
    @code     = row['code']
    @country  = row['country']
    @website  = row['website']

    @address  = row['address1']

    ### NOTE: address2 used only 4 out of 1414 recs in open beer db
    ## merge into one if present use | for now; use // later ?
    #  1380 => >Wandsworth<
    #  1394 => >Suite 100<
    #  1406 => >Stanhope St<
    #  1408 => >1000 Murray Ross Parkway<
    address2 = row['address2']

    ## NOTE: replace commas in name, addresses w/ pipe (|)
    
    ##
    # fix: do NOT include brewery if marked (Closed) in name

    # name cleanup
    #   remove trailing
    #       ,_LLC
    #       ,_Inc.
    #       _LLC

    @name = @name.sub( /,\s*LLC$/, '' )
    @name = @name.sub( /,\s*Inc\.$/, '' )
    @name = @name.sub( /\s+LLC$/, '' )

    @name      = @name.gsub(',',' |')

    if @name =~ /\(Closed\)/    # check for closed marker e.g (Closed)
      @closed = true
    end

    @address  =  @address ? @address.gsub(',',' |') : '?'

    if address2
      address2 = address2.gsub(',',' |')
      @address << " | #{address2}"
    end

    @city      = @city     ? @city : '?'
    @state     = if @state
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
