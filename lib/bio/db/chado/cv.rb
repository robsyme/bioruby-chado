module Bio
  module Chado

    # Classes in this namespace correspond to tables and views in the
    # Chado CV module.
    module CV

      # A controlled vocabulary or ontology. A cv is composed of
      # cvterms (AKA terms, classes, types, universals - relations and
      # properties are also stored in cvterm) and the relationships
      # between them.
      
      class CV
        include DataMapper::Resource
        storage_names[:default] = 'cv'

        property :cv_id, Serial
        property :name, String
        property :definition, Text

        has n, :cvterms, 'CVTerm', :child_key => [:cv_id]
      end

      # A term, class, universal or type within an ontology or
      # controlled vocabulary. This table is also used for relations
      # and properties. cvterms constitute nodes in the graph defined
      # by the collection of cvterms and cvterm_relationships.

      class CVTerm
        include DataMapper::Resource
        storage_names[:default] = 'cvterm'

        property :cvterm_id, Serial
        property :name, String
        property :definition, Text
        property :is_obsolete, Boolean
        property :is_relationshiptype, Integer

        has n, :cverm_dbxrefs, 'CVTermDBxref', :child_key => [:cvterm_id]
        has n, :pubs, 'Pub::Pub', :child_key => [:type_id]
        has n, :pub_relationships, 'Pub::PubRelationship', :child_key => [:type_id]
        has n, :pubprops, 'Pub::Pubprop', :child_key => [:type_id]
        has n, :organism_props, 'Organism::OrganismProp', :child_key => [:type_id]
        has n, :features, 'Sequence::Feature', :child_key => [:type_id]
        has n, :feature_cvterms, 'Sequence::FeatureCVTerm', :child_key => [:cvterm_id]
        
        belongs_to :cv, 'CV', :child_key => [:cv_id]
        belongs_to :dbxref, 'General::DBxref', :child_key => [:dbxref_id]

        after :destroy do |cvterm|
          cvterm.dbxref.destroy if cvterm.dbxref
        end

        def self.so_terms
          so_cv = CV.first({ :name => "sequence" })
          raise Chado::SequenceOntologyCVMissing unless so_cv

          all( :cv => so_cv )
        end

        def self.method_missing(sym, *args)
          match = sym.to_s.match(/^so_(?<cvterm>.*)/)
          raise NoMethodError unless match

          cvterm = CVTerm.so_terms.first(:name => match[:cvterm])
          cvterm ||= CVTerm.so_terms.first(:dbxref => General::DBxref.first({ :accession => match[:cvterm],
                                                                              :db => General::DB.first(:name => "SO") }))
          raise Chado::MissingSequenceOntologyTerm, match[:cvterm] unless cvterm

          cvterm
        end

      end

      # In addition to the primary identifier (cvterm.dbxref_id) a
      # cvterm can have zero or more secondary identifiers/dbxrefs,
      # which may refer to records in external databases. The exact
      # semantics of cvterm_dbxref are not fixed. For example: the
      # dbxref could be a pubmed ID that is pertinent to the cvterm,
      # or it could be an equivalent or similar term in another
      # ontology. For example, GO cvterms are typically linked to
      # InterPro IDs, even though the nature of the relationship
      # between them is largely one of statistical association. The
      # dbxref may be have data records attached in the same database
      # instance, or it could be a "hanging" dbxref pointing to some
      # external database. NOTE: If the desired objective is to link
      # two cvterms together, and the nature of the relation is known
      # and holds for all instances of the subject cvterm then
      # consider instead using cvterm_relationship together with a
      # well-defined relation.
      
      class CVTermDBxref
        include DataMapper::Resource
        storage_names[:default] = 'cvterm_dbxref'

        property :cvterm_dbxref_id, Serial
        property :is_for_definition, Integer

        belongs_to :cvterm, 'CVTerm', :child_key => [:cvterm_id]
        belongs_to :dbxref, 'General::DBxref', :child_key => [:dbxref_id]
      end

      # A relationship linking two cvterms. Each cvterm_relationship
      # constitutes an edge in the graph defined by the collection of
      # cvterms and cvterm_relationships. The meaning of the
      # cvterm_relationship depends on the definition of the cvterm R
      # refered to by type_id. However, in general the definitions are
      # such that the statement "all SUBJs REL some OBJ" is true. The
      # cvterm_relationship statement is about the subject, not the
      # object. For example "insect wing part_of thorax".
      
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
