module Bio
  module Chado
    module Pub

      # A documented provenance artefact - publications, documents,
      # personal communication.

      # Required properties for creating new {Pub} object are:
      # - type - {Bio::Chado::CV::CVTerm}
      # - uniquename - String
      #
      # The Chado schema dictates that all of the properties will be
      # stored as strings or text, so don't expect to get integers back
      # from pyear, volume etc.
      #
      # Creating a Pub object requires a {Bio::Chado::CV::CVTerm},
      # which in turn requires a {Bio::Chado::CV::CV} and a {Bio::Chado::General::DBxref}.
      # The {Bio::Chado::General::Dbxref} requires a {Bio::Chado::General::DB}.
      # @todo Put in some convenience methods in later to save the user creating the CV, CVTerm, DBxref and DB children.
      
      class Pub
        include DataMapper::Resource
        storage_names[:default] = 'pub'

        property :pub_id, Serial
        property :title, Text
        property :volumetitle, Text
        property :volume, Text
        property :series_name, String
        property :issue, String
        property :pyear, String
        property :pages, String
        property :miniref, String
        property :uniquename, Text
        property :is_obsolete, Boolean
        property :publisher, String
        property :pubplace, String

        belongs_to :type, 'Bio::Chado::CV::CVTerm', :child_key => [:type_id]

        has n, :feature_cvterms, 'Bio::Chado::Sequence::FeatureCVTerm', :child_key => [:pub_id]
        has n, :feature_cvterm_pubs, 'Bio::Chado::Sequence::FeatureCVTermPub', :child_key => [:pub_id]
        has n, :feature_pubs, 'Bio::Chado::Sequence::FeaturePub', :child_key => [:pub_id]
        has n, :feature_relationship_pubs, 'Bio::Chado::Sequence::FeatureRelationshipPub', :child_key => [:pub_id]
        has n, :feature_relationshipprop_pubs, 'Bio::Chado::Sequence::FeatureRelationshippropPub', :child_key => [:pub_id]
        has n, :feature_synonyms, 'Bio::Chado::Sequence::FeatureSynonym', :child_key => [:pub_id]
        has n, :featureloc_pubs, 'Bio::Chado::Sequence::FeaturelocPub', :child_key => [:pub_id]
        has n, :featureprop_pubs, 'Bio::Chado::Sequence::FeaturepropPub', :child_key => [:pub_id]
        has n, :pub_dbxrefs, 'PubDBxref', :child_key => [:pub_id]
        has n, :pub_relationships_as_object, 'PubRelationship', :child_key => [:object_id]
        has n, :pub_relationships_as_subject, 'PubRelationship', :child_key => [:subject_id]
        has n, :pubauthors, 'Pubauthor', :child_key => [:pub_id]
        has n, :pubprops, 'Pubprop', :child_key => [:pub_id]
        #TODO: has n, :feauremap_pubs, 'Bio::Chado::Map::FeatureMap', :child_key => [:pub_id]
      end

      # Handle links to repositories, e.g. Pubmed, Biosis, zoorec,
      # OCLC, Medline, ISSN, coden... 
      #
      # Required properties for creating new {PubDBxref} object are:
      # - pub - {Bio::Chado::Pub::Pub}
      # - dbxref - {Bio::Chado::General::DBxref}
      
      class PubDBxref
        include DataMapper::Resource
        storage_names[:default] = 'pub_dbxref'

        property :pub_dbxref_id, Serial
        property :is_current, Boolean

        belongs_to :pub, 'Pub', :child_key => [:pub_id]
        belongs_to :dbxref, 'Bio::Chado::General::DBxref', :child_key => [:dbxref_id]
      end

      # Handle relationships between publications, e.g. when one
      # publication makes others obsolete, when one publication
      # contains errata with respect to other publication(s), or when
      # one publication alsoappears in another pub.
      #
      # Required properties for creating new {PubRelationship} object are:
      # - type - {Bio::Chado::CV::CVTerm}
      # - subject - {Bio::Chado::Pub::Pub}
      # - object - {Bio::Chado::Pub::Pub}
      
      class PubRelationship
        include DataMapper::Resource
        storage_names[:default] = 'pub_relationship'

        property :pub_relationship_id, Serial

        belongs_to :subject, 'Pub', :child_key => [:subject_id]
        belongs_to :object, 'Pub', :child_key => [:object_id]
        belongs_to :type, 'Bio::Chado::CV::CVTerm', :child_key => [:type_id]
      end

      # An author for a publication. Note the denormalisation (hence
      # lack of _ in table name) - this is deliberate as it is in
      # general too hard to assignIDs to authors.
      #
      # Required properties for creating new {Pubauthor} object are:
      # - pub - {Bio::Chado::Pub::Pub}
      # - rank - Integer
      # - surname - String

      class Pubauthor
        include DataMapper::Resource
        storage_names[:default] = 'pubauthor'

        property :pubauthor_id, Serial
        property :rank, Integer
        property :editor, Boolean
        property :surname, String
        property :givennames, String
        property :suffix, String

        belongs_to :pub, 'Pub', :child_key => [:pub_id]
      end

      # Property-value pairs for a pub. Follows standard chado
      # pattern.
      # Required properties for creating new {Pubprop} object are:
      # - pub - {Bio::Chado::Pub::Pub}
      # - type - {Bio::Chado::CV::CVTerm}
      # - value - String
      
      class Pubprop
        include DataMapper::Resource
        storage_names[:default] = 'pubprop'
        
        property :pubprop_id, Serial
        property :value, Text
        property :rank, Integer

        belongs_to :pub, 'Pub', :child_key => [:pub_id]
        belongs_to :type, 'Bio::Chado::CV::CVTerm', :child_key => [:type_id]
      end

    end
  end
end
