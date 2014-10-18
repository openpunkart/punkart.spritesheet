# encoding: utf-8

class BeerCategory
  attr_reader :name

  def initialize
    # do nothing
  end

  def from_row( row )
    ## NOTE: replace commas in name, addresses w/ pipe (|)
    @name   = row['cat_name'].gsub(',',' |')
    self   # NOTE: return self (to allow method chaining)
  end
end # class BeerCat


class BeerStyle
  attr_reader :name
  attr_reader :cat

  def initialize( cat )
    @cat = cat
  end

  def from_row( row )
    ## NOTE: replace commas in name, addresses w/ pipe (|)
    @name = row['style_name'].gsub(',',' |')
    self   # NOTE: return self (to allow method chaining)
  end
end # class BeerStyle




def read_style_rows( path, catmap )
  ## NOTE: 2nd para - pass along category map
  hash = {}

  ## try a dry test run
  i = 0
  CSV.foreach( path, headers: true ) do |row|
    i += 1
    print '.' if i % 100 == 0

    cat_id = row['cat_id']
    cat = catmap[cat_id]
    if cat
      s = BeerStyle.new( cat )
      s.from_row( row )
      hash[ row['id'] ] = s  ## index by id
    else
      puts '*** warn: missing category for style:'
      pp row
    end
  end
  puts " #{i} rows"
  
  hash  # return beer styles map indexed by id
end

def read_category_rows( path )
  hash = {}

  ## try a dry test run
  i = 0
  CSV.foreach( path, headers: true ) do |row|
    i += 1
    print '.' if i % 100 == 0

    c = BeerCategory.new
    c.from_row( row )
    hash[ row['id'] ] = c  ## index by id
  end
  puts " #{i} rows"
  
  hash  # return beer cat(egory) map indexed by id
end

