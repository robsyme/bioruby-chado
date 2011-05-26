module Bio
  module Chado
    module Organism

      class Organism
        include DataMapper::Resource
        storage_names[:default] = 'organism'

        property :organism_id, Serial
        property :abbreviation, String
        property :genus, String
        property :species, String
        property :common_name, String
        property :comment, Text

#        has_many :features, 'Bio::Chado::Sequence::Feature', :child_key[:organism_id]
        has n, :organism_dbxrefs, 'OrganismDBxref', :child_key[:organism_id]
        has n, :organism_props, 'OrganismProp', :child_key[:organism_id]
        has n, :features, 'Bio::Chado::Sequence::Feature', :child_key [:organism_id]
      end

      class OrganismDBxref
        include DataMapper::Resource
        storage_names[:default] = 'organism_dbxref'

        property :organism_dbxref_id, Serial

        belongs_to :organism, 'Organism', :child_key => [:organism_id]
        belongs_to :dbxref, 'Bio::Chado::General::DBxref', :child_key => [:dbxref_id]
      end

      class OrganismProp
        include DataMapper::Resource
        storage_names[:default] = 'organismprop'

        property :organismprop_id, Serial
        property :value, Text
        property :rank, Integer

        belongs_to :organism, 'Organism', :child_key => [:organism_id]
        belongs_to :type, 'Bio::Chado::CV::CVTerm', :child_key => [:type_id]
      end

    end
  end
end
