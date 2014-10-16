# encoding: utf-8


class Beer
  attr_accessor :brewery

  attr_reader :name,
              :abv,
              :ibu,
              :srm,
              :upc,
              :cat,
              :style

  def initialize
    @brewery = nil
  end

  def from_row( row )
#  "id","brewery_id","name",
#    "cat_id","style_id",
#    "abv","ibu","srm","upc",
#    "filepath","descript","last_mod"
#
#  "1","812","Hocus Pocus",
#    "11","116",
#    "4.5","0","0","0",
#    ,"Our take on a classic summer ale.  A toast to weeds, rays, and summer haze.
#       A light, crisp ale for mowing lawns, hitting lazy fly balls, and communing with nature, Hocus Pocus is offered up as a summer sacrifice to clodless days.
#       its malty sweetness finishes tart and crisp and is best apprediated with a wedge of orange.","2010-07-22 20:00:20"
#
#  "2","264","Grimbergen Blonde",
#    "-1","-1",
#    "6.7","0","0","0",,,"2010-07-22 20:00:20"

    @name   = row['name']

    ## NOTE: replace commas in name, addresses w/ pipe (|)
    @name   = @name.gsub(',',' |')

    self   # NOTE: return self (to allow method chaining)
  end  
end  # class Beer


