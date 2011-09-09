module Bio
  module Chado
    module Pub

      class Pub
        include DataMapper::Resource
        storage_names[:default] = 'pub'

        property :pub_id, Serial
        property :title, Text
        property :volumetitle, Text
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
        has n, :featureloc_pubs, 'Bio::Chado::Sequence::Featureloc', :child_key => [:pub_id]

        #TODO: has n, :feauremap_pubs, 'Bio::Chado::Map::FeatureMap', :child_key => [:pub_id]


        has n, :featureprop_pubs, 'Bio::Chado::Sequence::FeaturepropPub', :child_key => [:pub_id]
        has n, :pub_dbxrefs, 'PubDBxref', :child_key => [:pub_id]
        has n, :pub_relationships, 'PubRelationship', :child_key => [:pub_id]
        has n, :pubauthors, 'Pubauthor', :child_key => [:pub_id]
        has n, :pubprops, 'Pubprop', :child_key => [:pub_id]
      end

      class PubDBxref
        include DataMapper::Resource
        storage_names[:default] = 'pub_dbxref'

        property :pub_dbxref_id, Serial
        property :is_current, Boolean

        belongs_to :pub, 'Pub', :child_key => [:pub_id]
        belongs_to :dbxref, 'Bio::Chado::General::DBxref', :child_key => [:dbxref_id]
      end

      class PubRelationship
        include DataMapper::Resource
        storage_names[:default] = 'pub_relationship'

        property :pub_relationship_id, Serial

        belongs_to :subject, 'Pub', :child_key => [:subject_id]
        belongs_to :object, 'Pub', :child_key => [:object_id]
        belongs_to :type, 'Bio::Chado::CV::CVTerm', :child_key => [:type_id]
      end

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
