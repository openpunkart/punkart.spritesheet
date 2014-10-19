# encoding: utf-8

## openbeerdatabase.org  csv reader

class BeerReader
  
  def initialize( opts )
    breweries_path   = opts[:breweries_path]   # e.g. './o/breweries.csv'
    categories_path  = opts[:categories_path]  # e.g. './dl/categories.csv'
    styles_path      = opts[:styles_path]      # e.g. './dl/styles.csv'

    @bymap    = build_brewery_map( breweries_path )

    @catmap   = read_category_rows( categories_path )
    @stylemap = read_style_rows( styles_path, @catmap )
  end

  def read( path )
    # returns array of beers
 
    ary = []
    i = 0
    CSV.foreach( path, headers: true ) do |row|
      i += 1
      print '.' if i % 100 == 0
    
      brewery_id = row['brewery_id']
      by = @bymap[ brewery_id ]
      if by
        b = Beer.new
        b.brewery = by
        
        cat_id   = row['cat_id']
        style_id = row['style_id']
        
        if cat_id && cat_id != '-1'
          b.cat = @catmap[ cat_id ]
        else
          # do nothing
        end

        if style_id && style_id != '-1'
          b.style = @stylemap[ style_id ]
        else
          # do nothing
        end
        
        b.from_row( row )

        country = by.country
        state   = by.state
        if country.nil? && country == '?'
          puts " *** row #{i} - country is nil; skipping: #{row.inspect}\n\n"
          next  ## skip line; issue warning
        end

        if (state.nil? || state == '?') && country == 'United States'
          puts " *** row #{i} - united states - state is nil; #{row.inspect}\n\n"
        end

        if (state.nil? || state == '?') && country == 'Belgium'
          puts " *** row #{i} - belgium - state is nil; #{row.inspect}\n\n"
        end
        
        ary << b
      else
        puts "** brewery #{i} with id >#{brewery_id}< not found; skipping beer row:"
        pp row
      end
    end
    puts " #{i} rows"
    ary # return records
  end
  
end # class BeaeReader


