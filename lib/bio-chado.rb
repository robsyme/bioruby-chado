require "pp"
require "data_mapper"
require "dm-constraints"
require "bio/db/chado/general"
require "bio/db/chado/cv"
require "bio/db/chado/organism"
require "bio/db/chado/sequence"
require "bio/db/chado/pub"
require "bio/db/chado/errors"
require "bio/db/chado/chado"

DataMapper::Property::String.length(255)

# Uncomment the next line to start logging
# LOG = DataMapper::Logger.new('datamapper.log', :debug)

