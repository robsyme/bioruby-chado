module Bio
  module Chado
    module CV

      class CV
        include DataMapper::Resource
        storage_names[:default] = 'cv'

        property :cv_id, Serial
        property :name, String
        property :definition, Text

        has n, :cvterms, 'CVTerm', :child_key => [:cv_id]
      end

      class CVTerm
        include DataMapper::Resource
        storage_names[:default] = 'cvterm'

        property :cvterm_id, Serial
        property :name, String
        property :definition, Text
        property :is_obsolete, Boolean
        property :is_relationshiptype, Integer

        has n, :cverm_dbxrefs, 'CVTermDBxref', :child_key => [:cvterm_id]

        belongs_to :cv, 'CV', :child_key => [:cv_id]
        belongs_to :dbxref, 'Bio::Chado::General::DBxref', :child_key => [:dbxref_id]
      end

      class CVTermDBxref
        include DataMapper::Resource
        storage_names[:default] = 'cvterm_dbxref'

        property :cvterm_dbxref_id, Serial
        property :is_for_definition, Integer

        belongs_to :cvterm, 'CVTerm', :child_key => [:cvterm_id]
        belongs_to :dbxref, 'Bio::Chado::General::DBxref', :child_key => [:dbxref_id]
      end

      class CVTermRelationship
        include DataMapper::Resource
        storage_names[:default] = 'cverm_relationship'

        property :cvterm_relationship_id, Serial

        belongs_to :type, 'CVTerm', :child_key => [:type_id], :parent_key => [:cvterm_id]
        belongs_to :subject, 'CVTerm', :child_key => [:subject_id], :parent_key => [:cvterm_id]
        belongs_to :object, 'CVTerm', :child_key => [:object_id], :parent_key => [:cvterm_id]
      end

    end
  end
end
