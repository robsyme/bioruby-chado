module Bio
  module Chado
    module Sequence

      class Feature
        include DataMapper::Resource
        storage_names[:default] = 'feature'

        property :feature_id, Serial
        property :name, String
        property :uniquename, String
        property :residues, Text
        property :seqlen, Integer
        property :md5checksum, String
        property :is_analysis, Boolean
        property :is_obsolete, Boolean
        property :timeaccessioned, DateTime
        property :timelastmodified, DateTime

        belongs_to :dbxref, 'Bio::Chado::General::DBxref', :child_key => [:dbxref_id]
        belongs_to :organism, 'Bio::Chado::Organism::Organism', :child_key => [:organism_id]
        belongs_to :type, 'Bio::Chado::CV::CVTerm', :child_key => [:type_id]

        has n, :feature_cvterms, 'FeatureCVTerm', :child_key => [:feature_id]
        has n, :feature_dbxrefs, 'FeatureDBxref', :child_key => [:feature_id]
        has n, :feature_pubs, 'FeaturePub', :child_key => [:feature_id]
        has n, :feature_relationships, 'FeatureRelationship', :child_key => [:feature_id]
        has n, :featurelocs, 'Featureloc', :child_key => [:feature_id]
        has n, :featureposs, 'Featurepos', :child_key => [:feature_id]
        has n, :feaureprops, 'Featureprop', :child_key => [:feature_id]
        has n, :featureranges, 'Featurerange', :child_key => [:feature_id]
      end

      class FeatureCVTerm
        include DataMapper::Resource
        storage_names[:default] = 'feature_cvterm'

        property :feature_cvterm_id, Serial
        property :is_not, Boolean

        belongs_to :feature, 'Feature', :child_key => [:feature_id]
        belongs_to :cvterm, 'Bio::Chado::CV::CVTerm', :child_key => [:cvterm_id]
        belongs_to :pub, 'Bio::Chado::Pub::Pub', :child_key => [:pub_id]

        has n, :feature_cvterm_dbxrefs, 'FeatureCVTermDBxref', :child_key => [:feature_cvterm_id]
        has n, :feature_cvterm_pubs, 'FeatureCVTermPub', :child_key => [:feature_cvterm_id]
        has n, :feature_cvterm_props, 'FeatureCVTermProp', :child_key => [:feature_cvterm_id]
      end

      class FeatureCVTermDBxref
        include DataMapper::Resource
        storage_names[:default] = 'feature_cvterm_dbxref'

        property :feature_cvterm_dbxref_id, Serial

        belongs_to :feaure_cvterm, 'FeatureCVTerm', :child_key => [:feature_cvterm_id]
        belongs_to :dbxref, 'Bio::Chado::General::DBxref', :child_key => [:dbxref_id]
      end

      class FeatureCVTermPub
        include DataMapper::Resource
        storage_names[:default] = 'feature_cvterm_pub'

        property :feature_cvterm_pub_id, Serial

        belongs_to :feature_cvterm, 'FeatureCVTerm', :child_key => [:feature_cvterm_id]
        belongs_to :pub, 'Bio::Chado::Pub::Pub', :child_key => [:pub_id]
      end

      class FeatureCVTermProp
        include DataMapper::Resource
        storage_names[:default] = 'feature_cvterm_prop'

        property :feature_cvterm_prop_id, Serial
        property :value, Text
        property :rank, Integer

        belongs_to :feature_cvterm, 'FeatureCVTerm', :child_key => [:feature_cvterm_id]
        belongs_to :type, 'Bio::Chado::CV::CVTerm', :child_key => [:type_id]
      end

      class FeatureDBxref
        include DataMapper::Resource
        storage_names[:default] = 'feature_dbxref'

        property :feature_dbxref_id, Serial
        property :is_current, Boolean

        belongs_to :feature, 'Feature', :child_key => [:feature_id]
        belongs_to :dbxref, 'Bio::Chado::General::DBxref', :child_key => [:dbxref_id]
      end

      class FeaturePub
        include DataMapper::Resource
        storage_names[:default] = 'feature_pub'

        property :feature_pub_id, Serial

        belongs_to :feature, 'Feature', :child_key => [:feature_id]
        belongs_to :pub, 'Bio::Chado::Pub::Pub', :child_key => [:pub_id]
      end

      class FeaturePubprop
        include DataMapper::Resource
        storage_names[:default] = 'feature_pubprop'

        property :feature_pubprop_id, Serial
        property :value, Text
        property :rank, Integer

        belongs_to :feature, 'Feature', :child_key => [:feature_id]
        belongs_to :type, 'Bio::Chado::CV::CVTerm', :child_key => [:type_id]
      end

      class FeatureRelationship
        include DataMapper::Resource
        storage_names[:default] = 'feature_relationship'

        property :feature_relationship_id, Serial
        property :value, Text
        property :rank, Integer

        belongs_to :subject, 'Feature', :child_key => [:subject_id]
        belongs_to :object, 'Feature', :child_key => [:object_id]
        belongs_to :type, 'Bio::Chado::CV::CVTerm', :child_key => [:type_id]

        has n, :feature_relationship_pubs, 'FeatureRelationshipPub'
        has n, :feature_relationshipprops, 'FeatureRelationshipprop'
      end

      class FeatureRelationshipPub
        include DataMapper::Resource
        storage_names[:default] = 'feature_relationship_pub'

        property :feature_relationship_pub_id, Serial
        property :value, Text
        property :rank, Integer

        belongs_to :type, 'Bio::Chado::CV::CVTerm', :child_key => [:type_id]
        belongs_to :feature_relationship, 'FeatureRelationship', :child_key => [:feature_relationship_id]
      end

      class FeatureRelationshippropPub
        include DataMapper::Resource
        storage_names[:default] = 'feature_relationshipprop_pub'

        property :feature_relationshipprop_pub_id, Serial

        belongs_to :feature_relationshipprop, 'FeatureRelationshipprop', :child_key => [:feature_relationshipprop_id]
        belongs_to :pub, 'Bio::Chado::Pub::Pub', :child_key => [:pub_id]
      end

      class FeatureSynonym
        include DataMapper::Resource
        storage_names[:default] = 'feature_synonym'

        property :feature_synonym_id, Serial
        property :is_current, Boolean
        property :is_internal, Boolean

        belongs_to :synonym, 'Synonym', :child_key => [:synonym_id]
        belongs_to :feature, 'Feature', :child_key => [:feature_id]
        belongs_to :pub, 'Bio::Chado::Pub::Pub', :child_key => [:pub_id]
      end

      class Featureloc
        include DataMapper::Resource
        storage_names[:default] = 'featureloc'

        property :featureloc_id, Serial
        property :fmin, Integer
        property :is_fmin_partial, Boolean
        property :fmax, Integer
        property :is_fmax_partial, Boolean
        property :strand, Integer
        property :phase, Integer
        property :residue_info, Text
        property :locgroup, Integer
        property :rank, Integer

        belongs_to :feature, 'Feature', :child_key => [:feature_id]
        belongs_to :srcfeature, 'Feature', :child_key => [:srcfeature_id]
      end

      class FeaturelocPub
        include DataMapper::Resource
        storage_names[:default] = 'featureloc_pub'

        property :featureloc_pub_id, Serial

        belongs_to :featureloc, 'Featureloc', :child_key => [:featureloc_id]
        belongs_to :pub, 'Bio::Chado::Pub::Pub', :child_key => [:pub_id]
      end

      class Featureprop
        include DataMapper::Resource
        storage_names[:default] = 'feaureprop'

        property :featureprop_id, Serial
        property :value, Text
        property :rank, Integer

        belongs_to :feature, 'Feature', :child_key => [:feature_id]
        belongs_to :type, 'Bio::Chado::CV::CVTerm', :child_key => [:type_id]

        has n, :featureprop_pubs, 'FeaturepropPub', :child_key => [:featureprop_id]
      end

      class FeaturepropPub
        include DataMapper::Resource
        stroage_names[:default] = 'featureprop_pub'

        property :featureprop_pub_id, Serial

        belongs_to :pub, 'Bio::Chado::Pub::Pub', :child_key => [:pub_id]
        belongs_to :featureprop, 'Featureprop', :child_key => [:featureprop_id]
      end

      class Synonym
        include DataMapper::Resource
        storage_names[:default] = 'synonym'

        property :synonym_id, Serial
        property :name, String
        property :synonym_sgml, String

        belongs_to :type, 'Bio::Chado::CV::CVTerm', :child_key => [:type_id]

        has n, :feature_synonyms, 'FeatureSynonym', :child_key => [:synonym_id]
      end

    end
  end
end
