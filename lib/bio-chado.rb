require "pp"
require "data_mapper"
require "dm-constraints"
require "bio/db/chado/general"
require "bio/db/chado/cv"
require "bio/db/chado/organism"
require "bio/db/chado/sequence"
require "bio/db/chado/pub"


DataMapper::Property::String.length(255)
debug_file = File.open("datamapper_debug.log", 'w')
DataMapper::Logger.new(debug_file, :debug)
