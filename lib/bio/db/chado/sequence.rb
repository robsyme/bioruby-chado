module Bio
  module Chado
    module Sequence

      # A feature is a biological sequence or a section of a
      # biological sequence, or a collection of such
      # sections. Examples include genes, exons, transcripts,
      # regulatory regions, polypeptides, protein domains, chromosome
      # sequences, sequence variations, cross-genome match regions
      # such as hits and HSPs and soon; see the Sequence Ontology for
      # more. 
      #
      # Required properties for creating a new {Feature} are:
      # - dbxref - {General::DBxref}
      # - organism - {Organism::Organism}
      # - uniquename - String
      # - type - {CV::CVTerm}
      
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
        has n, :feaureprops, 'Featureprop', :child_key => [:feature_id]

        #TODO: has n, :featureposs, 'Bio::Chado::Map::Featurepos', :child_key => [:feature_id]
        #TODO: has n, :featureranges, 'Bio::Chado::Map::Featurerange', :child_key => [:feature_id]
      end

      
      # Associate a term from a cv with a feature, for example, GO
      # annotation. Remember that the {Feature}
      # class has a {Feature#type type} property for primary cvterms,
      # so this class should only be used when the feature has two or
      # more cvterms.
      # 
      # Required properties for creating a new {FeatureCVTerm} are:
      # - feature - {Feature}
      # - cvterm - {CV::CVTerm}
      # - pub - {Pub::Pub}
      
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


      # Additional dbxrefs for an association. Rows in the
      # feature_cvterm table may be backed up by dbxrefs. For example,
      # a feature_cvterm association that was inferred via a
      # protein-protein interaction may be backed by by refering to
      # the dbxref for the alternate protein. Corresponds to the WITH
      # column in a GO gene association file (but can also be used for
      # other analagous associations). See
      # http://www.geneontology.org/doc/GO.annotation.shtml#file for
      # more details. 
      # 
      # Required properties for creating a new {FeatureCVTermDBxref} are:
      # - feature_cvterm - {FeatureCVTerm}
      # - dbxref - {General::DBxref}

      class FeatureCVTermDBxref
        include DataMapper::Resource
        storage_names[:default] = 'feature_cvterm_dbxref'

        property :feature_cvterm_dbxref_id, Serial

        belongs_to :feaure_cvterm, 'FeatureCVTerm', :child_key => [:feature_cvterm_id]
        belongs_to :dbxref, 'Bio::Chado::General::DBxref', :child_key => [:dbxref_id]
      end


      # Secondary pubs for an association. Each feature_cvterm
      # association is supported by a single primary
      # publication. Additional secondary pubs can be added using this
      # linking table (in a GO gene association file, these
      # corresponding to any IDs after the pipe symbol in the
      # publications column. 
      #
      # Required properties for creating a new {FeatureCVTermPub} are:
      # - feature_cvterm - {FeatureCVTerm}
      # - pub - {Pub::Pub}

      class FeatureCVTermPub
        include DataMapper::Resource
        storage_names[:default] = 'feature_cvterm_pub'

        property :feature_cvterm_pub_id, Serial

        belongs_to :feature_cvterm, 'FeatureCVTerm', :child_key => [:feature_cvterm_id]
        belongs_to :pub, 'Bio::Chado::Pub::Pub', :child_key => [:pub_id]
      end


      # Extensible properties for feature to cvterm
      # associations. Examples: GO evidence codes; qualifiers;
      # metadata such as the date on which the entry was curated and
      # the source of the association. See the featureprop table for
      # meanings of type_id, value and rank. 
      #
      # Required properties for creating a new {FeatureCVTermProp}
      # are:
      # - feature_cvterm - {FeatureCVTerm}
      # - type - {CV::CVTerm}
      # - rank - Integer

      class FeatureCVTermProp
        include DataMapper::Resource
        storage_names[:default] = 'feature_cvterm_prop'

        property :feature_cvterm_prop_id, Serial
        property :value, Text
        property :rank, Integer

        belongs_to :feature_cvterm, 'FeatureCVTerm', :child_key => [:feature_cvterm_id]
        belongs_to :type, 'Bio::Chado::CV::CVTerm', :child_key => [:type_id]
      end


      # Links a feature to dbxrefs. This is for secondary identifiers;
      # primary identifiers should use feature.dbxref_id.
      #
      # Required properties for creating a new {FeatureDBxref} are:
      # - feature - {Feature}
      # - dbxref - {General::DBxref}
      
      class FeatureDBxref

        include DataMapper::Resource
        storage_names[:default] = 'feature_dbxref'

        property :feature_dbxref_id, Serial
        property :is_current, Boolean

        belongs_to :feature, 'Feature', :child_key => [:feature_id]
        belongs_to :dbxref, 'Bio::Chado::General::DBxref', :child_key => [:dbxref_id]
      end


      # Provenance. Linking table between features and publications
      # that mention them. 
      #
      # Required properties for creating a new {FeaturePub} are:
      # - feature - {Feature}
      # - pub - {Pub::Pub}
      
      class FeaturePub
        include DataMapper::Resource
        storage_names[:default] = 'feature_pub'

        property :feature_pub_id, Serial

        belongs_to :feature, 'Feature', :child_key => [:feature_id]
        belongs_to :pub, 'Bio::Chado::Pub::Pub', :child_key => [:pub_id]
      end


      # Property or attribute of a feature_pub link.
      #
      # Requried properties for creating a new {FeaturePubprop} are:
      # - feature - {Feature}
      # - type - {CV::CVTerm}
      # - rank - Integer

      class FeaturePubprop
        include DataMapper::Resource
        storage_names[:default] = 'feature_pubprop'

        property :feature_pubprop_id, Serial
        property :value, Text
        property :rank, Integer

        belongs_to :feature, 'Feature', :child_key => [:feature_id]
        belongs_to :type, 'Bio::Chado::CV::CVTerm', :child_key => [:type_id]
      end


      # Features can be arranged in graphs, e.g. "exon part_of
      # transcript part_of gene"; If type is thought of as a verb, the
      # each arc or edge makes a statement [Subject Verb Object]. The
      # object can also be thought of as parent (containing feature),
      # and subject as child (contained feature or subfeature). We
      # include the relationship rank/order, because even though most
      # of the time we can order things implicitly by sequence
      # coordinates, we can not always do this - e.g. transpliced
      # genes. It is also useful for quickly getting implicit
      # introns. 
      #
      # Requried properties for creating a new {FeatureRelationship} are:
      # - subject - {Feature}
      # - object - {Feature}
      # - type - {CV::CVTerm}
      # - rank - Integer

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


      # Provenance. Attach optional evidence to a feature_relationship
      # in the form of a publication. 
      #
      # Requried properties for creating a new {FeatureRelationshipPub} are:
      # - pub - {Pub::Pub}
      # - feature_relationship {FeatureRelationship}

      class FeatureRelationshipPub
        include DataMapper::Resource
        storage_names[:default] = 'feature_relationship_pub'

        property :feature_relationship_pub_id, Serial
        property :value, Text

        belongs_to :pub, 'Bio::Chado::Pub::Pub', :child_key => [:pub_id]
        belongs_to :feature_relationship, 'FeatureRelationship', :child_key => [:feature_relationship_id]
      end

      
      # Extensible properties for feature_relationships. Analagous
      # structure to featureprop. This table is largely optional and
      # not used with a high frequency. Typical scenarios may be if
      # one wishes to attach additional data to a feature_relationship -
      # for example, to say that the feature_relationship is only
      # true in certain contexts. 
      #
      # Requried properties for creating a new
      # {FeatureRelationshipprop} are:
      #
      # - type - {CV::CVTerm}
      # - feature_relationship - {FeatureRelationship}
      # - rank - Integer

      class FeatureRelationshipprop
        include DataMapper::Resource
        storage_names[:default] = 'feature_relationshipprop'

        property :feature_relationshipprop_id, Serial
        property :value, Text
        property :rank, Integer

        belongs_to :feature_relationship, 'FeatureRelationship', :child_key => [:feature_relationship_id]
        belongs_to :type, 'Bio::Chado::CV::CVTerm', :child_key => [:type_id]
      end


      # Provenance for feature_relationshipprop.
      #
      # Requried properties for creating a new
      # {FeatureRelationshippropPub} are:
      # - pub - {Pub::Pub}
      # - feature_relationshipprop - {FeatureRelationshipprop}

      class FeatureRelationshippropPub
        include DataMapper::Resource
        storage_names[:default] = 'feature_relationshipprop_pub'

        property :feature_relationshipprop_pub_id, Serial 
        
        belongs_to :pub, 'Bio::Chado::Pub::Pub', :child_key => [:pub_id]
        belongs_to :feature_relationshipprop, 'FeatureRelationshipprop', :child_key => [:feature_relationshipprop_id]
      end


      # Linking table between feature and synonym.
      #
      # Requried properties for creating a new {FeatureSynonym} are:
      # - synonym - {Synonym}
      # - feature - {Feature}
      # - pub - {Pub::Pub}
      
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


      # The location of a feature relative to another
      # feature. Important: interbase coordinates are used. This is
      # vital as it allows us to represent zero-length features
      # e.g. splice sites, insertion points without an awkward fuzzy
      # system. Features typically have exactly ONE location, but this
      # need not be the case. Some features may not be localized
      # (e.g. a gene that has been characterized genetically but no
      # sequence or molecular information is available). Note on
      # multiple locations: Each feature can have 0 or more
      # locations. Multiple locations do NOT indicate non-contiguous
      # locations (if a feature such as a transcript has a
      # non-contiguous location, then the subfeatures such as exons
      # should always be manifested). Instead, multiple featurelocs
      # for a feature designate alternate locations or grouped
      # locations; for instance, a feature designating a blast hit or
      # hsp will have two locations, one on the query feature, one on
      # the subject feature. Features representing sequence variation
      # could have alternate locations instantiated on a feature on
      # the mutant strain. The column:rank is used to differentiate
      # these different locations. Reflexive locations should never be
      # stored - this is for -proper- (i.e. non-self) locations only;
      # nothing should be located relative to itself. 
      #
      # Requried properties for creating a new {Featureloc} are:
      # - feature - {Feature}
      # - srcfeature - {Feature}
      # - locgroup - Integer
      # - rank - Integer
      
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


      # Provenance of featureloc. Linking table between featurelocs
      # and publications that mention them. 
      #
      # Requried properties for creating a new {Featurelocpub} are:
      # - featureloc - {Featureloc}
      # - pub - {Pub::Pub}

      class FeaturelocPub
        include DataMapper::Resource
        storage_names[:default] = 'featureloc_pub'

        property :featureloc_pub_id, Serial

        belongs_to :featureloc, 'Featureloc', :child_key => [:featureloc_id]
        belongs_to :pub, 'Bio::Chado::Pub::Pub', :child_key => [:pub_id]
      end


      # A feature can have any number of slot-value property tags
      # attached to it. This is an alternative to hardcoding a list of
      # columns in the relational schema, and is completely
      # extensible. 
      # 
      # Requried properties for creating a new {Featureprop} are:
      # - featureloc - {Featureloc}
      # - type - {CV::CVTerm}
      # - rank - Integer
      
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


      # Provenance. Any featureprop assignment can optionally be
      # supported by a publication. 
      #
      # Requried properties for creating a new {FeaturepropPub} are:
      # - pub - {Pub::Pub}
      # - featureprop - {Featureprop}
      
      class FeaturepropPub
        include DataMapper::Resource
        storage_names[:default] = 'featureprop_pub'

        property :featureprop_pub_id, Serial

        belongs_to :pub, 'Bio::Chado::Pub::Pub', :child_key => [:pub_id]
        belongs_to :featureprop, 'Featureprop', :child_key => [:featureprop_id]
      end



      # A synonym for a feature. One feature can have multiple
      # synonyms, and the same synonym can apply to multiple
      # features.
      #
      # Requried properties for creating a new {Synonym} are:
      # - name - String
      # - type - {CV::CVTerm}
      # - synonym_sgml - String
      
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
