# encoding: utf-8


#####
#  fix/todo:
#   add nil/uncategorized to state
#   - how to deal w/ unknown e.g. Virgin Islands (Us) ??? move to uncategorized or undefined/unknown?
#


require 'csv'
require 'pp'
require 'fileutils'
require 'json'


##############
# our own code

require './scripts/csv'  # generic - move to lib for (re)use ??


require './settings'

require './country_us'
require './country_be'
require './country_de'
require './country_ca'
require './countries'


require './scripts/countries'

require './scripts/breweries'
require './scripts/beers'
require './scripts/styles'

require './scripts/reader'


############################################
# add more tasks (keep build script modular)

Dir.glob('./tasks/**/*.rake').each do |r|
  puts " importing task >#{r}<..."
  import r
  # see blog.smartlogicsolutions.com/2009/05/26/including-external-rake-files-in-your-projects-rakefile-keep-your-rake-tasks-organized/
end


