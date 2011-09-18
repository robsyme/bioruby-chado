require "pp"
require "data_mapper"
require "dm-constraints"

# Uncomment the next line to start logging
# LOG = DataMapper::Logger.new('datamapper.log', :debug)

# Chado uses properties stored as Strings up to 255 chars.
DataMapper::Property::String.length(255)

require "bio/db/chado/general"
require "bio/db/chado/cv"
require "bio/db/chado/organism"
require "bio/db/chado/sequence"
require "bio/db/chado/pub"
require "bio/db/chado/errors"
require "bio/db/chado/chado"
require "bio/db/chado/gff"


