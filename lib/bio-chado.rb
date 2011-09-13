require "pp"
require "data_mapper"
require "dm-constraints"
require "bio/db/chado/general"
require "bio/db/chado/cv"
require "bio/db/chado/organism"
require "bio/db/chado/sequence"
require "bio/db/chado/pub"
require "bio/db/chado/errors"
require "bio/db/chado/chado_to_biosequence.rb"

DataMapper::Property::String.length(255)
